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

#include <stdlib.h>
#include <string.h>
#include <iconv.h>

#ifdef HAVE_ALLOCA_H
# include <alloca.h>
#endif

#include "uim.h"
#include "uim-internal.h"
#include "uim-util.h"


static void *uim_iconv_open(const char *tocode, const char *fromcode);
static int uim_iconv_is_convertible(const char *tocode, const char *fromcode);
static void *uim_iconv_create(const char *tocode, const char *fromcode);
static char *uim_iconv_code_conv(void *obj, const char *str);
static void uim_iconv_release(void *obj);

static int check_encoding_equivalence(const char *tocode,
                                      const char *fromcode);
static const char **uim_get_encoding_alias(const char *encoding);


static struct uim_code_converter uim_iconv_tbl = {
  uim_iconv_is_convertible,
  uim_iconv_create,
  uim_iconv_code_conv,
  uim_iconv_release
};
struct uim_code_converter *uim_iconv = &uim_iconv_tbl;

#include "encoding-table.c"


static int
check_encoding_equivalence(const char *tocode, const char *fromcode)
{
  const char **alias_tocode;
  const char **alias_fromcode;
  int i, j;
  int alias_tocode_alloced = 0;
  int alias_fromcode_alloced = 0;
  int found = 0;

  alias_tocode = uim_get_encoding_alias(tocode);
  alias_fromcode = uim_get_encoding_alias(fromcode);

  if (!alias_tocode) {
    alias_tocode = malloc(sizeof(char *) * 2);
    alias_tocode[0] = tocode;
    alias_tocode[1] = NULL;
    alias_tocode_alloced = 1;
  }
  if (!alias_fromcode) {
    alias_fromcode = malloc(sizeof(char *) * 2);
    alias_fromcode[0] = fromcode;
    alias_fromcode[1] = NULL;
    alias_fromcode_alloced = 1;
  }

  for (i = 0; alias_tocode[i]; i++) {
    for (j = 0; alias_fromcode[j]; j++) {
      if (!strcmp(alias_tocode[i], alias_fromcode[j])) {
        found = 1;
	break;
      }
    }
    if (found)
      break;
  }

  if (alias_tocode_alloced)
    free(alias_tocode);
  if (alias_fromcode_alloced)
    free(alias_fromcode);
  return found;
}

static int
uim_iconv_is_convertible(const char *tocode, const char *fromcode)
{
  iconv_t ic;

  if (check_encoding_equivalence(tocode, fromcode))
    return 1;

  /* TODO cache the result */
  ic = (iconv_t)uim_iconv_open(tocode, fromcode);
  if (ic == (iconv_t)-1) {
    return 0;
  }
  iconv_close(ic);
  return 1;
}

static const char **
uim_get_encoding_alias(const char *encoding)
{
  int i, j;
  const char **alias;

  for (i = 0; (alias = uim_encoding_list[i]); i++) {
    for (j = 0; alias[j]; j++) {
      if (!strcmp(alias[j], encoding))
        return alias;
    }
  }
  return NULL;
}

static void *
uim_iconv_open(const char *tocode, const char *fromcode)
{
  iconv_t cd = (iconv_t)-1;
  int i, j;
  const char **alias_tocode, **alias_fromcode;
  int alias_tocode_alloced = 0;
  int alias_fromcode_alloced = 0;
  int opened = 0;

  alias_tocode = uim_get_encoding_alias(tocode);
  alias_fromcode = uim_get_encoding_alias(fromcode);

  if (!alias_tocode) {
    alias_tocode = malloc(sizeof(char *) * 2);
    alias_tocode[0] = tocode;
    alias_tocode[1] = NULL;
    alias_tocode_alloced = 1;
  }
  if (!alias_fromcode) {
    alias_fromcode = malloc(sizeof(char *) * 2);
    alias_fromcode[0] = fromcode;
    alias_fromcode[1] = NULL;
    alias_fromcode_alloced = 1;
  }

  for (i = 0; alias_tocode[i]; i++) {
    for (j = 0; alias_fromcode[j]; j++) {
      cd = iconv_open(alias_tocode[i], alias_fromcode[j]);
      if (cd != (iconv_t)-1) {
	opened = 1;
	break;
      }
    }
    if (opened)
      break;
  }

  if (alias_tocode_alloced)
    free(alias_tocode);
  if (alias_fromcode_alloced)
    free(alias_fromcode);
  return (void *)cd;
}

static void *
uim_iconv_create(const char *tocode, const char *fromcode)
{
  iconv_t ic;

  if (check_encoding_equivalence(tocode, fromcode))
    return NULL;

  ic = (iconv_t)uim_iconv_open(tocode, fromcode);
  if (ic == (iconv_t)-1) {
    /* since iconv_t is not explicit pointer, use 0 instead of NULL */
    ic = (iconv_t)0;
  }
  return (void *)ic;
}

static char *
uim_iconv_code_conv(void *obj, const char *str)
{
  iconv_t ic;
  size_t len;
  size_t buflen;
  char *realbuf;
  char *outbuf;
  const char *inbuf;

  ic = (iconv_t)obj;
  if (!str)
    return NULL;

  if (!ic)
    return strdup(str);

  len = strlen(str);
  buflen = (len * 6)+3;
  realbuf = alloca(buflen);
  outbuf = realbuf;
  inbuf = str;
  memset(realbuf, 0, buflen);
  iconv(ic, (ICONV_CONST char **)&inbuf, &len, &outbuf, &buflen);
  return strdup(realbuf);
}

static void
uim_iconv_release(void *obj)
{
  int err;
  err = iconv_close((iconv_t)obj);
}
