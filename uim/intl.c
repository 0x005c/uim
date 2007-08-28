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

/*
  Make this file plugin when alternative Scheme interpreter that has
  gettext feature has been added to libuim.  -- YamaKen 2004-01-10
*/

#include <config.h>

#include <stdlib.h>
#include <string.h>
#if ENABLE_NLS
#include <locale.h>
#endif

#include "gettext.h"
#include "uim-scm.h"
#include "uim-scm-abbrev.h"

/* for uim_init_intl_subrs() */
#include "uim-internal.h"

static uim_lisp
intl_gettext_package()
{
  return uim_scm_make_str(GETTEXT_PACKAGE);
}


static uim_lisp
intl_textdomain(uim_lisp domainname)
{
  const char *new_domain;

  if (FALSEP(domainname)) {
    new_domain = textdomain(NULL);
  } else {
    new_domain = textdomain(uim_scm_refer_c_str(domainname));
  }

  return uim_scm_make_str(new_domain);
}

static uim_lisp
intl_bindtextdomain(uim_lisp domainname, uim_lisp dirname)
{
  const char *domain, *new_dir;

  domain = uim_scm_refer_c_str(domainname);

  if (FALSEP(dirname)) {
    new_dir = bindtextdomain(domain, NULL);
  } else {
    new_dir = bindtextdomain(domain, uim_scm_refer_c_str(dirname));
  }

  return uim_scm_make_str(new_dir);
}

static uim_lisp
intl_bind_textdomain_codeset(uim_lisp domainname, uim_lisp codeset)
{
  const char *c_current_codeset, *c_codeset;
  uim_lisp current_codeset;

  if (!uim_scm_stringp(domainname)
      || !(uim_scm_stringp(codeset) || FALSEP(codeset)))
    return uim_scm_f();

  c_codeset = (FALSEP(codeset)) ? NULL : uim_scm_refer_c_str(codeset);
  c_current_codeset = bind_textdomain_codeset(uim_scm_refer_c_str(domainname),
					      c_codeset);
  if (c_current_codeset) {
    current_codeset = uim_scm_make_str(c_current_codeset);
  } else {
    current_codeset = uim_scm_f();
  }

  return current_codeset;
}

static uim_lisp
intl_gettext(uim_lisp msgid)
{
  return uim_scm_make_str(gettext(uim_scm_refer_c_str(msgid)));
}

static uim_lisp
intl_dgettext(uim_lisp domainname, uim_lisp msgid)
{
  const char *translated;

  if (!uim_scm_stringp(domainname) || !uim_scm_stringp(msgid))
    return uim_scm_f();

  translated = dgettext(uim_scm_refer_c_str(domainname),
			uim_scm_refer_c_str(msgid));

  return uim_scm_make_str(translated);
}

static uim_lisp
intl_dcgettext(uim_lisp domainname, uim_lisp msgid, uim_lisp category)
{
  return uim_scm_make_str(dcgettext(uim_scm_refer_c_str(domainname),
				    uim_scm_refer_c_str(msgid),
				    uim_scm_c_int(category)));
}

static uim_lisp
intl_ngettext(uim_lisp msgid1, uim_lisp msgid2, uim_lisp n)
{
  return uim_scm_make_str(ngettext(uim_scm_refer_c_str(msgid1),
				   uim_scm_refer_c_str(msgid2),
				   uim_scm_c_int(n)));
}

static uim_lisp
intl_dngettext(uim_lisp domainname, uim_lisp msgid1, uim_lisp msgid2, uim_lisp n)
{
  return uim_scm_make_str(dngettext(uim_scm_refer_c_str(domainname),
				    uim_scm_refer_c_str(msgid1),
				    uim_scm_refer_c_str(msgid2),
				    uim_scm_c_int(n)));
}

static uim_lisp
intl_dcngettext(uim_lisp domainname, uim_lisp msgid1, uim_lisp msgid2, uim_lisp n, uim_lisp category)
{
  return uim_scm_make_str(dcngettext(uim_scm_refer_c_str(domainname),
				     uim_scm_refer_c_str(msgid1),
				     uim_scm_refer_c_str(msgid2),
				     uim_scm_c_int(n),
				     uim_scm_c_int(category)));
}

static void
intl_init_locale(void)
{
#if ENABLE_NLS
  const char *current_locale;

  /* Perform setlocale() only if it maybe did not performed before. This  */
  current_locale = setlocale(LC_MESSAGES, NULL);
  if (!strcmp(current_locale, "C")) {
    setlocale(LC_ALL, "");
  }

  bindtextdomain(GETTEXT_PACKAGE, LOCALEDIR);
  /* bind_textdomain_codeset() should not be performed here. See
     UIM_EVAL_STRING()
  */

#if 0
  /* textdomain() must not be performed by a library because it masks
     application's one. Use dgettext() always.
  */
  textdomain(GETTEXT_PACKAGE);
#endif
#endif
}

void
uim_init_intl_subrs(void)
{
  intl_init_locale();

  uim_scm_init_proc0("gettext-package", intl_gettext_package);
  uim_scm_init_proc1("textdomain", intl_textdomain);
  uim_scm_init_proc2("bindtextdomain", intl_bindtextdomain);
  uim_scm_init_proc2("bind-textdomain-codeset", intl_bind_textdomain_codeset);
  uim_scm_init_proc1("gettext", intl_gettext);
  uim_scm_init_proc2("dgettext", intl_dgettext);
  uim_scm_init_proc3("dcgettext", intl_dcgettext);
  uim_scm_init_proc3("ngettext", intl_ngettext);
  uim_scm_init_proc4("dngettext", intl_dngettext);
  uim_scm_init_proc5("dcngettext", intl_dcngettext);

#if ENABLE_NLS
  uim_scm_callf("provide", "s", "nls");
#endif
}
