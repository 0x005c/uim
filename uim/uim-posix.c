/*

  Copyright (c) 2003-2008 uim Project http://code.google.com/p/uim/

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
  3. Neither the name of authors nor the names of its contributors
     may be used to endorse or promote products derived from this software
     without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

*/

#include <config.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <pwd.h>
#include <assert.h>

#include "uim-internal.h"
#include "uim-scm.h"
#include "uim-scm-abbrev.h"
#include "uim-util.h"
#include "uim-posix.h"

uim_bool
uim_get_user_name(char *name, int len, int uid)
{
  struct passwd *pw;

  if (len <= 0)
    return UIM_FALSE;
  pw = getpwuid(uid);
  if (!pw) {
    name[0] = '\0';
    return UIM_FALSE;
  }
  if (strlcpy(name, pw->pw_name, len) >= (size_t)len) {
    name[0] = '\0';
    endpwent();
    return UIM_FALSE;
  }
  endpwent();
  return UIM_TRUE;
}

static uim_lisp
user_name(void)
{
  char name[BUFSIZ];

  if (!uim_get_user_name(name, sizeof(name), getuid()))
    return uim_scm_f();

  return MAKE_STR(name);
}

uim_bool
uim_get_home_directory(char *home, int len, int uid)
{
  struct passwd *pw;

  if (len <= 0)
    return UIM_FALSE;
  pw = getpwuid(uid);
  if (!pw) {
    home[0] = '\0';
    return UIM_FALSE;
  }
  if (strlcpy(home, pw->pw_dir, len) >= (size_t)len) {
    home[0] = '\0';
    endpwent();
    return UIM_FALSE;
  }
  endpwent();
  return UIM_TRUE;
}

static uim_lisp
home_directory(uim_lisp user_)
{
  int uid;
  char home[MAXPATHLEN];

  if (INTP(user_)) {
    uid = C_INT(user_);
  } else if (STRP(user_)) {
    struct passwd *pw;

    pw = getpwnam(REFER_C_STR(user_));

    if (!pw)
      return uim_scm_f();

    uid = pw->pw_uid;
    endpwent();
  } else {
    return uim_scm_f();
  }

  if (!uim_get_home_directory(home, sizeof(home), uid)) {
    char *home_env = getenv("HOME");
    if (home_env)
      return MAKE_STR(home_env);
    return uim_scm_f();
  }

  return MAKE_STR(home);
}

uim_bool
uim_check_dir(const char *dir)
{
  struct stat st;

  if (stat(dir, &st) < 0)
    return (mkdir(dir, 0700) < 0) ? UIM_FALSE : UIM_TRUE;
  else {
    mode_t mode = S_IFDIR | S_IRUSR | S_IWUSR | S_IXUSR;
    return ((st.st_mode & mode) == mode) ? UIM_TRUE : UIM_FALSE;
  }
}

uim_bool
uim_get_config_path(char *path, int len, int is_getenv)
{
  char home[MAXPATHLEN];

  if (len <= 0)
    return UIM_FALSE;

  if (!uim_get_home_directory(home, sizeof(home), getuid()) && is_getenv) {
    char *home_env = getenv("HOME");

    if (!home_env)
      return UIM_FALSE;

    if (strlcpy(home, home_env, sizeof(home)) >= sizeof(home))
      return UIM_FALSE;
  }

  if (snprintf(path, len, "%s/.uim.d", home) == -1)
    return UIM_FALSE;

  if (!uim_check_dir(path)) {
    return UIM_FALSE;
  }

  return UIM_TRUE;
}

static uim_lisp
file_stat_mode(uim_lisp filename, mode_t mode)
{
  struct stat st;
  int err;

  err = stat(REFER_C_STR(filename), &st);
  if (err)
    return uim_scm_f();  /* intentionally returns #f instead of error */

  return MAKE_BOOL((st.st_mode & mode) == mode);
}

static uim_lisp
file_readablep(uim_lisp filename)
{
  return file_stat_mode(filename, S_IRUSR);
}

static uim_lisp
file_writablep(uim_lisp filename)
{
  return file_stat_mode(filename, S_IWUSR);
}

static uim_lisp
file_executablep(uim_lisp filename)
{
  return file_stat_mode(filename, S_IXUSR);
}

static uim_lisp
file_regularp(uim_lisp filename)
{
  return file_stat_mode(filename, S_IFREG);
}

static uim_lisp
file_directoryp(uim_lisp filename)
{
  return file_stat_mode(filename, S_IFDIR);
}

static uim_lisp
file_mtime(uim_lisp filename)
{
  struct stat st;
  int err;

  err = stat(REFER_C_STR(filename), &st);
  if (err)
    ERROR_OBJ("stat failed for file", filename);

  return MAKE_INT(st.st_mtime);
}

static uim_lisp
c_getenv(uim_lisp str)
{
  char *val;

  ENSURE_TYPE(str, str);

  val = getenv(REFER_C_STR(str));

  return (val) ? MAKE_STR(val) : uim_scm_f();
}

static uim_lisp
c_setenv(uim_lisp name, uim_lisp val, uim_lisp overwrite)
{
  int err;

  err = setenv(REFER_C_STR(name), REFER_C_STR(val), TRUEP(overwrite));

  return MAKE_BOOL(!err);
}

static uim_lisp
c_unsetenv(uim_lisp name)
{
  unsetenv(REFER_C_STR(name));

  return uim_scm_t();
}

static uim_lisp
setugidp(void)
{
  assert(uim_scm_gc_any_contextp());

  return MAKE_BOOL(uim_issetugid());
}

void
uim_init_posix_subrs(void)
{
  uim_scm_init_proc0("user-name", user_name);
  uim_scm_init_proc1("home-directory", home_directory);

  uim_scm_init_proc1("file-readable?", file_readablep);
  uim_scm_init_proc1("file-writable?", file_writablep);
  uim_scm_init_proc1("file-executable?", file_executablep);
  uim_scm_init_proc1("file-regular?", file_regularp);
  uim_scm_init_proc1("file-directory?", file_directoryp);
  uim_scm_init_proc1("file-mtime", file_mtime);

  uim_scm_init_proc0("setugid?", setugidp);

  uim_scm_init_proc1("getenv", c_getenv);
  uim_scm_init_proc3("setenv", c_setenv);
  uim_scm_init_proc1("unsetenv", c_unsetenv);
}
