/*

  Copyright (c) 2003-2007 uim Project http://code.google.com/p/uim/

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

#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <pwd.h>
#include <signal.h>
#include <errno.h>
#include <sys/stat.h>

#include "uim-internal.h"
#include "uim-helper.h"
#include "uim-util.h"

#ifndef HAVE_SIG_T
typedef void (*sig_t)(int);
#endif

enum RorW
  {
    READ,
    WRITE
  };

static int
uim_helper_fd(int fd, enum RorW rw)
{
    int rc;
    fd_set fds;
    struct timeval tv;

    /*   if (!fd || fd < 0)
	 return -1;*/

    FD_ZERO(&fds);
    FD_SET(fd, &fds);
    tv.tv_sec = tv.tv_usec = 0;

    if (rw == READ)
      rc = select(fd + 1 , &fds, NULL, NULL, &tv);
    else    
      rc = select(fd + 1, NULL, &fds, NULL, &tv);

    if (rc < 0)
      return -1;
    
    return FD_ISSET(fd, &fds) ? 1 : 0;
}

void
uim_helper_send_message(int fd, const char *message)
{
  int res;
  int len, out_len;
  sig_t old_sigpipe;
  char *buf, *bufp;

  if (UIM_CATCH_ERROR_BEGIN())
    return;

#if 0
  if (fd < 0)
    uim_fatal_error("uim_helper_send_message(): invaid fd");
  if (!message)
    uim_fatal_error("uim_helper_send_message(): NULL message");
#else
  /* The condition fd < 0 ordinarily occurs. */
  if (fd < 0 || !message)
    return;
#endif

  len = strlen(message) + 1;
  buf = uim_malloc(len + 1);
  snprintf(buf, len + 1, "%s\n", message);

  old_sigpipe = signal(SIGPIPE, SIG_IGN);

  out_len = len;
  bufp = buf;
  while (out_len > 0) {
    if ((res = write(fd, bufp, out_len)) < 0) {
      if (errno == EAGAIN || errno == EINTR)
	continue;
      perror("uim_helper_send_message(): unhandled error");
      break;
    }

    bufp += res;
    out_len -= res;
  }
  free(buf);
  signal(SIGPIPE, old_sigpipe);

  UIM_CATCH_ERROR_END();

  return;
}

static uim_bool
check_dir(const char *dir)
{
  struct stat st;

  if (stat(dir, &st) < 0)
    return (mkdir(dir, 0700) < 0) ? UIM_FALSE : UIM_TRUE;
  else {
    mode_t mode = S_IFDIR | S_IRUSR | S_IWUSR | S_IXUSR;
    return ((st.st_mode & mode) == mode) ? UIM_TRUE : UIM_FALSE;
  }
}

char *
uim_helper_get_pathname(void)
{
  char *path, *home = NULL;
  struct passwd *pw;
  int len;
 
  if (UIM_CATCH_ERROR_BEGIN())
    return NULL;

  pw = getpwuid(getuid());
  if (pw)
    home = pw->pw_dir;

  if (!home && !uim_issetugid())
    home = getenv("HOME");

  if (!home)
    uim_fatal_error("uim_helper_get_pathname()");

  /* check ~/.uim.d/ */
  len = strlen(home) + strlen("/.uim.d");
  path = uim_malloc(len + 1);
  snprintf(path, len + 1, "%s/.uim.d", home);
  if (!check_dir(path)) {
    free(path);
    uim_fatal_error("uim_helper_get_pathname()");
  }

  /* check ~/.uim.d/socket/ */
  len += strlen("/socket");
  path = uim_realloc(path, len + 1);
  strlcat(path, "/socket", len + 1);
  if (!check_dir(path)) {
    free(path);
    uim_fatal_error("uim_helper_get_pathname()");
  }

  len += strlen("/uim-helper");
  path = uim_realloc(path, len + 1);
  strlcat(path, "/uim-helper", len + 1);

  UIM_CATCH_ERROR_END();

  return path;
}

int
uim_helper_check_connection_fd(int fd)
{
  uid_t euid;
  gid_t egid;
  if (getpeereid(fd, &euid, &egid) < 0) {
    perror("getpeereid failed");
    return -1;
  }
  if ((euid != 0) && (euid != getuid())) {
    fprintf(stderr, "uid mismatch\n");
    return -1;
  }
  return 0;
}

int uim_helper_fd_readable(int fd)
{
  return uim_helper_fd(fd, READ);
}

int uim_helper_fd_writable(int fd)
{
  return uim_helper_fd(fd, WRITE);
}


int uim_helper_str_terminated(const char *str)
{
  if (!str)
    return 0;

  if (strlen(str) > 2 &&
     str[strlen(str) - 1] == '\n' &&
     str[strlen(str) - 2] == '\n')
    return 1;

  return 0;
}

char *
uim_helper_buffer_append(char *buf, const char *fragment, size_t fragment_size)
{
  size_t buf_size, extended_size;

  buf_size = strlen(buf);
  extended_size = buf_size + fragment_size + 1;
  buf = realloc(buf, extended_size);
  if (buf) {
    memcpy(&buf[buf_size], fragment, fragment_size);
    buf[extended_size - 1] = '\0';
  }

  return buf;
}

void
uim_helper_buffer_shift(char *buf, int count)
{
  int len = strlen(buf);
  memmove(buf, &buf[count], len - count);
  buf[len - count] = '\0';
}

char *
uim_helper_buffer_get_message(char *buf)
{
  size_t msg_size;
  char *msg, *msg_term;

  if (UIM_CATCH_ERROR_BEGIN())
    return NULL;

  msg_term = strstr(buf, "\n\n");
  if (msg_term) {
    msg_size = msg_term + 2 - buf;
    msg = uim_malloc(msg_size + 1);
    memcpy(msg, buf, msg_size);
    msg[msg_size] = '\0';
    uim_helper_buffer_shift(buf, msg_size);
  } else {
    msg = NULL;
  }

  UIM_CATCH_ERROR_END();

  return msg;
}

/* Public API for uim_issetugid(). */
/* TODO: should be renamed to uim_helper_issetugid() */
uim_bool
uim_helper_is_setugid(void)
{
  return (uim_issetugid()) ? UIM_TRUE : UIM_FALSE;
}

#if !HAVE_ISSETUGID
/* For internal use only. libuim clients should use uim_helper_is_setugid()
 * since this is not a core uim function. */
uim_bool
uim_issetugid(void)
{
  uid_t ruid = getuid();  /* real uid */
  gid_t rgid = getgid();  /* real gid */
  uid_t euid = geteuid(); /* effective uid */
  gid_t egid = getegid(); /* effective gid */

  return (ruid != euid || rgid != egid);
}
#endif /* !HAVE_ISSETUGID */
