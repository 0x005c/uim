/*

  Copyright (c) 2003,2004 uim Project http://uim.freedesktop.org/

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

  THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

*/

/*
 * uim�Υ�����Хå��ؿ�
 */
#if HAVE_CONFIG_H
#include "config.h"
#endif
#ifndef DEBUG
#define NDEBUG
#endif
#if HAVE_STDLIB_H
#include <stdlib.h>
#endif
#if HAVE_STRING_H
#include <string.h>
#endif
#if HAVE_ASSERT_H
#include <assert.h>
#endif
#include "uim-fep.h"
#include "str.h"
#include "callbacks.h"

static uim_context s_context;
/* TRUE�ʤ饫��������֤�ȿž���ʤ� */
static int s_cursor_no_reverse;
/* ���ơ������饤����� */
static int s_statusline_width;

static char *s_commit_str;
static char *s_statusline_str;
static char *s_candidate_str;
static int s_candidate_col;
static char *s_index_str;
static struct preedit_tag *s_preedit;
static int s_mode;

static void start_callbacks(void);
static void end_callbacks(void);
static void activate_cb(void *ptr, int nr, int display_limit);
static void select_cb(void *ptr, int index);
static void shift_page_cb(void *ptr, int direction);
static void deactivate_cb(void *ptr);
static void clear_cb(void *ptr);
static void pushback_cb(void *ptr, int attr, const char *str);
static void update_cb(void *ptr);
static void mode_update_cb(void *ptr, int mode);
static void property_update_cb(void *ptr, const char *str);
static void property_list_update_cb(void *ptr, const char *str);
static struct preedit_tag *dup_preedit(struct preedit_tag *p);
static void make_page_strs(void);
static int numwidth(int n);
static int index2page(int index);
static void reset_candidate(void);
static void get_candidate(void);

struct candidate_tag {
  /* ����ο� */
  int nr;
  /* 1�٤�ɽ���������� */
  int limit;
  /* ��page�� */
  int nr_pages;
  /* ���ߤθ��� 0����Ϥޤ� */
  int index;
  /* ���ߤΥڡ��� 0����Ϥޤ� */
  int page;
  /* �ڡ���ʸ��������� ���ǿ�nr_pages */
  char **page_strs;
  /* ����ΰ��֤����� ���ǿ�nr */
  int *cand_col;
  /* �ڡ����κǽ�θ����index������ ���ǿ�nr_pages */
  int *page2index;
  /* ���ߤθ���Υ���ǥå��������褹�륫��� */
  int *index_col;
};

static struct candidate_tag s_candidate = {
  UNDEFINED, /* nr */
  UNDEFINED, /* limit */
  UNDEFINED, /* nr_pages */
  UNDEFINED, /* index */
  UNDEFINED, /* page */
  NULL,      /* page_strs */
  NULL,      /* cand_col */
  NULL,      /* page2index */
  NULL,      /* index_col */
};

/*
 * �����
 */
void init_callbacks(uim_context context, int status_type, int cursor_no_reverse, int statusline_width)
{
  s_context = context;
  s_cursor_no_reverse = cursor_no_reverse;
  s_statusline_width = statusline_width;
  s_commit_str = strdup("");
  s_candidate_str = strdup("");
  s_statusline_str = strdup("");
  s_candidate_col = UNDEFINED;
  s_index_str = strdup("");
  s_mode = uim_get_current_mode(s_context);
  s_preedit = create_preedit();
  uim_set_preedit_cb(s_context, clear_cb, pushback_cb, update_cb);
  uim_set_mode_cb(s_context, mode_update_cb);
  uim_set_prop_label_update_cb(s_context, property_update_cb);
  uim_set_prop_list_update_cb(s_context, property_list_update_cb);
  if (status_type != NONE) {
    uim_set_candidate_selector_cb(s_context, activate_cb, select_cb, shift_page_cb, deactivate_cb);
  }
}

int press_key(int key, int key_state)
{
  int raw;
#if DEBUG > 2
  if (32 <= key && key <= 127) {
    debug2(("press key = %c key_state = %d\n", key, key_state));
  } else {
    debug2(("press key = %d key_state = %d\n", key, key_state));
  }
#endif
  start_callbacks();
  raw = uim_press_key(s_context, key, key_state);
  uim_release_key(s_context, key, key_state);
  end_callbacks();
  return raw;
}

static void start_callbacks(void)
{
  debug2(("\n\nstart_callbacks()\n"));
  if (s_commit_str != NULL) {
    free(s_commit_str);
  }
  s_commit_str = strdup("");
  if (s_candidate_str != NULL) {
    free(s_candidate_str);
    s_candidate_str = NULL;
  }
  if (s_index_str != NULL) {
    free(s_index_str);
    s_index_str = NULL;
  }
  if (s_statusline_str != NULL) {
    free(s_statusline_str);
    s_statusline_str = NULL;
  }
  s_candidate_col = UNDEFINED;
  s_mode = uim_get_current_mode(s_context);
}

static void end_callbacks(void)
{
  debug2(("end_callbacks()\n\n"));
  /* cursor�����ꤵ��Ƥ��ʤ��Ȥ��ϥץꥨ�ǥ��åȤ������ˤ��� */
  if (s_preedit->cursor == UNDEFINED) {
    s_preedit->cursor = s_preedit->width;
  }
  if (s_candidate.nr != UNDEFINED) {
    s_statusline_str = strdup(s_candidate.page_strs[s_candidate.page]);
    if (s_candidate.index != UNDEFINED) {
      get_candidate();
    } else {
      s_candidate_str = strdup("");
      s_candidate_col = UNDEFINED;
      s_index_str = strdup("");
    }
  } else {
    s_statusline_str = strdup("");
    s_candidate_str = strdup("");
    s_candidate_col = UNDEFINED;
    s_index_str = strdup("");
  }
}

/*
 * ����ʸ������֤�
 * �֤��ͤ�free����
 */
char *get_commit_str(void)
{
  return strdup(s_commit_str);
}

/*
 * �������ʸ������֤�
 * �֤��ͤ�free����
 */
char *get_statusline_str(void)
{
  return strdup(s_statusline_str);
}

/*
 * ����ʸ������֤�
 * �֤��ͤ�free����
 */
char *get_candidate_str(void)
{
  return strdup(s_candidate_str);
}

/*
 * ���򤵤�Ƥ�������column���֤�
 * ���򤵤�Ƥ��ʤ��Ȥ���UNDEFINED���֤�
 */
int get_candidate_col(void)
{
  return s_candidate_col;
}

/*
 * ���򤵤�Ƥ������Υ���ǥå�����ʸ������֤�
 * �֤��ͤ�free����
 */
char *get_index_str(void)
{
  return strdup(s_index_str);
}

/*
 * s_index_str�����褹�륫�����֤�
 * ���򤵤�Ƥ��ʤ��Ȥ���UNDEFINED���֤�
 */
int get_index_col(void)
{
  if (s_candidate.index != UNDEFINED) {
    return s_candidate.index_col[s_candidate.page];
  }
  return UNDEFINED;
}

/*
 * �ץꥨ�ǥ��åȤ��֤�
 * �֤��ͤ�free����
 */
struct preedit_tag *get_preedit(void)
{
  return dup_preedit(s_preedit);
}

/*
 * ���ߤΥ⡼�ɤ��֤�
 */
int get_mode(void)
{
  return s_mode;
}

/*
 * ���������ɽ������Ȥ��˸ƤФ�롣
 * s_candidate.nr = nr(�������)
 * s_candidate.limit = display_limit(ɽ����������)
 * s_candidate.cand_col���ΰ����ݤ��롣
 * make_page_strs��Ƥ֡�
 */
static void activate_cb(void *ptr, int nr, int display_limit)
{
  debug2(("activate_cb(nr = %d display_limit = %d)\n", nr, display_limit));
  reset_candidate();
  s_candidate.nr = nr;
  s_candidate.limit = display_limit;
  s_candidate.page = 0;
  s_candidate.cand_col = malloc(nr * sizeof(int));
  make_page_strs();
}

/*
 * ���䤬���򤵤줿�Ȥ��˸ƤФ�롣
 * s_candidate.index = index
 */
static void select_cb(void *ptr, int index)
{
  debug2(("select_cb(index = %d)\n", index));
  return_if_fail(s_candidate.nr != UNDEFINED);
  return_if_fail(0 <= index && index < s_candidate.nr);
  s_candidate.index = index;
  s_candidate.page = index2page(index);
}

/*
 * �ڡ������Ѥ����Ȥ��˸ƤФ�롣
 * s_candidate.page = 1�ڡ���������(direction�ˤ��)
 * s_candidate.index = page�κǽ餫�Ǹ�(direction�ˤ��)
 */
static void shift_page_cb(void *ptr, int direction)
{
  int page;
  int index;
  debug2(("shift_page_cb(direction = %d)\n", direction));
  return_if_fail(s_candidate.nr != UNDEFINED);
  if (direction == 0) {
    direction = -1;
  }
  page = (s_candidate.page + direction + s_candidate.nr_pages) % s_candidate.nr_pages;
  index = s_candidate.page2index[page];
  return_if_fail(0 <= index && index < s_candidate.nr);
  s_candidate.page = page;
  s_candidate.index = index;
  uim_set_candidate_index(s_context, s_candidate.index);
}

/*
 * ���������ä��Ȥ��˸ƤФ�롣
 * reset_candidate��Ƥ֡�
 */
static void deactivate_cb(void *ptr)
{
  debug2(("deactivate_cb()\n"));
  reset_candidate();
}


void commit_cb(void *ptr, const char *commit_str)
{
  debug2(("commit_cb(commit_str = \"%s\")\n", commit_str));
  return_if_fail(commit_str != NULL);
  s_commit_str = realloc(s_commit_str, strlen(s_commit_str) + strlen(commit_str) + 1);
  strcat(s_commit_str, commit_str);
}

static void clear_cb(void *ptr)
{
  if (s_preedit != NULL) {
    free_preedit(s_preedit);
  }
  s_preedit = create_preedit();
  s_preedit->cursor = UNDEFINED;
  debug2(("clear_cb()\n"));
}

/*
 * clear_cb�θ��0��ʾ�ƤФ��
 * s_preedit��������
 */
static void pushback_cb(void *ptr, int attr, const char *str)
{
  int width;
  static int cursor = FALSE;
  debug2(("pushback_cb(attr = %d str = \"%s\")\n", attr, str));
  return_if_fail(str && s_preedit != NULL);
  width = strwidth(str);
  /* UPreeditAttr_Cursor�ΤȤ��˶�ʸ����Ȥϸ¤�ʤ� */
  if (attr & UPreeditAttr_Cursor) {
    /* skk�μ�����Ͽ�ϥ������뤬2�սꤢ�� */
    /* assert(s_preedit->cursor == UNDEFINED); */
    s_preedit->cursor = s_preedit->width;
    attr -= UPreeditAttr_Cursor;
    cursor = TRUE;
  }
  /* ��ʸ�����̵�� */
  if (width > 0) {
    /* ����������֤�ʸ����ȿž�����ʤ� */
    if (s_cursor_no_reverse && cursor && attr & UPreeditAttr_Reverse && s_preedit->cursor != UNDEFINED) {
      int *rval = width2byte2(str, 1);
      int first_char_byte = rval[0];
      int first_char_width = rval[1];
      char *first_char = malloc(first_char_byte + 1);
      strncpy(first_char, str, first_char_byte);
      first_char[first_char_byte] = '\0';
      cursor = FALSE;
      pushback_cb(NULL, attr - UPreeditAttr_Reverse, first_char);
      free(first_char);
      str += first_char_byte;
      width -= first_char_width;
      if (width <= 0) {
        return;
      }
    }
    /* attr������Ʊ����������ʸ������դ�­�� */
    if (s_preedit->nr_psegs > 0 && s_preedit->pseg[s_preedit->nr_psegs - 1].attr == attr) {
      /* char *tmp_str = s_preedit->pseg[s_preedit->nr_psegs - 1].str; */
      /* s_preedit->pseg[s_preedit->nr_psegs - 1].str = malloc(strlen(tmp_str) + strlen(str) + 1); */
      s_preedit->pseg[s_preedit->nr_psegs - 1].str = realloc(s_preedit->pseg[s_preedit->nr_psegs - 1].str, strlen(s_preedit->pseg[s_preedit->nr_psegs - 1].str) + strlen(str) + 1);
      /* sprintf(s_preedit->pseg[s_preedit->nr_psegs - 1].str, "%s%s", tmp_str, str); */
      strcat(s_preedit->pseg[s_preedit->nr_psegs - 1].str, str);
    } else {
      s_preedit->pseg = realloc(s_preedit->pseg,
          sizeof(struct preedit_segment_tag) * (s_preedit->nr_psegs + 1));
      s_preedit->pseg[s_preedit->nr_psegs].str = strdup(str);
      s_preedit->pseg[s_preedit->nr_psegs].attr = attr;
      s_preedit->nr_psegs++;
    }
    s_preedit->width += width;
  }
}

static void update_cb(void *ptr)
{
  debug2(("update_cb()\n"));
}

/*
 * �⡼�ɤ��Ѥ�ä��Ȥ��˸ƤФ�롣
 * �ºݤ��Ѥ�äƤ��ʤ����Ȥ⤢�롣
 */
static void mode_update_cb(void *ptr, int mode)
{
  debug2(("mode_update_cb(mode = %d)\n", mode));
  s_mode = mode;
}

static void property_update_cb(void *ptr, const char *str)
{
  debug2(("prop(\"%s\")", str));
}
static void property_list_update_cb(void *ptr, const char *str)
{
  debug2(("proplist(\"%s\")", str));
}

/*
 * �������ץꥨ�ǥ��åȤ��ꡤ�ݥ��󥿤��֤�
 */
struct preedit_tag *create_preedit(void)
{
  struct preedit_tag *p = malloc(sizeof(struct preedit_tag));
  p->nr_psegs = 0;
  p->width = 0;
  p->cursor = 0;
  p->pseg = NULL;
  return p;
}

/*
 * p���ΰ��������
 */
void free_preedit(struct preedit_tag *p)
{
  int i;
  if (p == NULL) {
    return;
  }
  for (i = 0; i < p->nr_psegs; i++) {
    free(p->pseg[i].str);
  }
  if (p->pseg != NULL) {
    free(p->pseg);
  }
  free(p);
}

/*
 * p��ʣ�����ꡤ�ݥ��󥿤��֤�
 */
static struct preedit_tag *dup_preedit(struct preedit_tag *p)
{
  int i;
  struct preedit_tag *dup_p = create_preedit();
  *dup_p = *p;
  dup_p->pseg = malloc(sizeof(struct preedit_segment_tag) * (p->nr_psegs));
  for (i = 0; i < p->nr_psegs; i++) {
    dup_p->pseg[i].attr = p->pseg[i].attr;
    dup_p->pseg[i].str = strdup(p->pseg[i].str);
  }
  return dup_p;
}

/*
 * s_candidate.page_strs = �ڡ���ʸ���������
 * ʸ���������max_width��ۤ����Ȥ��ϡ��Ϥ߽Ф�����򼡤Υڡ����˰ܤ���
 * 1�Ĥ������䤬�ʤ��ƤϤ߽Ф��Ȥ��ϡ��ܤ��ʤ���
 * max_width��ü�����������ץ����ǻ��ꤵ�줿��
 * s_candidate.page2index = �ڡ����κǽ�θ����index
 * s_candidate.cand_col = ����ΰ���
 * s_candidate.nr_pages = �ڡ��������
 * s_candidate.index_col = ����Υ���ǥå����Υ����
 */
static void make_page_strs(void)
{
  /* NULL��realloc���ƥ��ߤˤʤ�ʤ��褦�� */
  char *page_str = strdup("");
  int page_byte = 0;
  int page_width = 0;
  int index_in_page = 0;

  int index;

  int max_width = g_win->ws_col;

  if (s_statusline_width != UNDEFINED && s_statusline_width <= max_width) {
    max_width = s_statusline_width;
  }

  assert(s_candidate.nr != UNDEFINED);
  assert(s_candidate.limit != UNDEFINED);
  assert(s_candidate.cand_col != NULL);

  s_candidate.nr_pages = 0;

  for (index = 0; index < s_candidate.nr; index++) {
    int next = FALSE;
    /* "[10/20]" ���� */
    int index_width = 3 + numwidth(index + 1) + numwidth(s_candidate.nr);

    uim_candidate cand = uim_get_candidate(s_context, index, index_in_page);
    const char *cand_str_label = uim_candidate_get_heading_label(cand);
    char *cand_str_cand = tab2space(uim_candidate_get_cand_str(cand));
    int cand_label_width = strwidth(cand_str_label);
    int cand_width = cand_label_width + 1 + strwidth(cand_str_cand) + 1;
    int cand_byte = strlen(cand_str_label) + 1 + strlen(cand_str_cand) + 1;
    char *cand_str = malloc(cand_byte + 1);
    sprintf(cand_str, "%s:%s ", cand_str_label, cand_str_cand);
    uim_candidate_free(cand);
    free(cand_str_cand);

    if (index_in_page == 0) {
      s_candidate.page2index = realloc(s_candidate.page2index, (s_candidate.nr_pages + 1) * sizeof(int));
      s_candidate.page2index[s_candidate.nr_pages] = index;
      s_candidate.index_col = realloc(s_candidate.index_col, (s_candidate.nr_pages + 1) * sizeof(int));
    }

    if (page_width + cand_width + index_width > max_width && index_in_page != 0) {
      /* �Ϥ߽Ф��ΤǼ��Υڡ����˰ܤ� */
      index--;
      index_width = 3 + numwidth(index + 1) + numwidth(s_candidate.nr);
      next = TRUE;
    } else {
      if (cand_width + index_width > max_width && index_in_page == 0) {
        assert(page_width == 0);
        /* �Ϥ߽Ф��������˰ܤ��ʤ� */      /* ���ڡ���������1 */
        cand_width = max_width - index_width - 1;
        cand_width = strhead(cand_str, cand_width);
        if (cand_label_width > cand_width) {
          cand_label_width = cand_width;
        }
        cand_width++;
        cand_byte = strlen(cand_str);
        cand_str[cand_byte++] = ' ';
        cand_str[cand_byte] = '\0';
        next = TRUE;
      }
                                                             /* ':' */
      s_candidate.cand_col[index] = page_width + cand_label_width + 1;
      page_width += cand_width;
      page_byte += cand_byte;
      page_str = realloc(page_str, page_byte + 1);
      strcat(page_str, cand_str);

      index_in_page++;
      if (index_in_page == s_candidate.limit || index + 1 == s_candidate.nr) {
        next = TRUE;
      }
    }

    if (next) {
      int index_byte = index_width;
      char *index_str = malloc(index_byte + 1);
      int i;
      sprintf(index_str, "[%d/%d]", index + 1, s_candidate.nr);
      for (i = 0; i < numwidth(index + 1); i++) {
        index_str[1 + i] = ' ';
      }
      index_str[i] = '-';
      /* ��ۤ�ü�������������ʤ�������Ϥ߽Фʤ� */
      if (page_width + index_width > max_width) {
        index_width = max_width - page_width;
        index_width = strhead(index_str, index_width);
        index_byte = strlen(index_str);
      }
      s_candidate.index_col[s_candidate.nr_pages] = page_width + 1;
      page_byte += index_byte;
      page_str = realloc(page_str, page_byte + 1);
      strcat(page_str, index_str);
      s_candidate.page_strs = realloc(s_candidate.page_strs, (s_candidate.nr_pages + 1)* sizeof(char *));
      s_candidate.page_strs[s_candidate.nr_pages] = strdup(page_str);
      s_candidate.nr_pages++; 

      page_byte = 0;
      page_width = 0;
      index_in_page = 0;
      free(index_str);
      free(page_str);
      page_str = strdup("");
    }
    free(cand_str);
  }
  free(page_str);
}

/*
 * n��ʸ����ɽ���������֤�
 * n��0�ʾ�Ǥʤ���Фʤ�ʤ���
 */
static int numwidth(int n)
{
  int i;
  assert(n >= 0);
  for (i = 1;(n /= 10) > 0; i++);
  return i;
}

/*
 * index������ڡ������֤���
 */
static int index2page(int index)
{
  int i;
  assert(s_candidate.nr_pages != UNDEFINED);
  for (i = 0; i < s_candidate.nr_pages; i++) {
    if (s_candidate.page2index[i] > index) {
      break;
    }
  }
  return i - 1;
}

/*
 * s_candidate���������롣
 */
static void reset_candidate(void)
{
  if (s_candidate.nr == UNDEFINED) {
    return;
  }
  if (s_candidate.page_strs != NULL) {
    int i;
    for (i = 0; i < s_candidate.nr_pages; i++) {
      free(s_candidate.page_strs[i]);
    }
    free(s_candidate.page_strs);
  }
  if (s_candidate.cand_col != NULL) {
    free(s_candidate.cand_col);
  }
  if (s_candidate.page2index != NULL) {
    free(s_candidate.page2index);
  }
  if (s_candidate.index_col != NULL) {
    free(s_candidate.index_col);
  }

  s_candidate.nr = UNDEFINED;
  s_candidate.limit = UNDEFINED;
  s_candidate.nr_pages = UNDEFINED;
  s_candidate.index = UNDEFINED;
  s_candidate.page_strs = NULL;
  s_candidate.cand_col = NULL;
  s_candidate.page2index = NULL;
  s_candidate.index_col = NULL;
}

/*
 * s_candidate_col��s_candidate_str��s_index_str�����ꤹ��
 */
static void get_candidate(void)
{
  uim_candidate cand;
  int cand_width;
  /* "[10/20]"���� */
  int index_width;
  int max_width = g_win->ws_col;
  /* ��ü�θ���Υ���ǥå��� */
  int right_edge_cand_index = s_candidate.page + 1 == s_candidate.nr_pages ? s_candidate.nr : s_candidate.page2index[s_candidate.page + 1];
  /* ��ü�θ���Υ���ǥå������� */
  int right_edge_cand_index_width = numwidth(right_edge_cand_index + 1);
  /* ���ߤθ���Υ���ǥå������� */
  int cand_index_width = numwidth(s_candidate.index + 1);
  int i;
  s_index_str = malloc(right_edge_cand_index_width + 1);
  for (i = 0; i < right_edge_cand_index_width - cand_index_width; i++) {
    s_index_str[i] = ' ';
  }
  s_index_str[i] = '\0';
  sprintf(s_index_str, "%s%d", s_index_str, s_candidate.index + 1);

  if (s_statusline_width != UNDEFINED && s_statusline_width <= max_width) {
    max_width = s_statusline_width;
  }

  s_candidate_col = s_candidate.cand_col[s_candidate.index];
  cand = uim_get_candidate(s_context, s_candidate.index, 0);
  if (uim_candidate_get_cand_str(cand) == NULL) {
    s_candidate_str = strdup("");
    s_candidate_col = UNDEFINED;
    uim_candidate_free(cand);
    return;
  }
  s_candidate_str = tab2space(uim_candidate_get_cand_str(cand));
  cand_width = strwidth(s_candidate_str);
  index_width = 3 + numwidth(s_candidate.index + 1) + numwidth(s_candidate.nr);
  /* ��ۤ�ü�������������ʤ�������Ϥ߽Фʤ� */
  if (s_candidate_col + cand_width + index_width > max_width) {
    strhead(s_candidate_str, max_width - s_candidate_col - index_width - 1);
  }
  uim_candidate_free(cand);
}

void callbacks_winch(void)
{
  if (s_candidate.nr != UNDEFINED) {
    if (s_candidate.page_strs != NULL) {
      int i;
      for (i = 0; i < s_candidate.nr_pages; i++) {
        free(s_candidate.page_strs[i]);
      }
      free(s_candidate.page_strs);
      s_candidate.page_strs = NULL;
    }
    if (s_candidate.page2index != NULL) {
      free(s_candidate.page2index);
      s_candidate.page2index = NULL;
    }
    if (s_candidate.index_col != NULL) {
      free(s_candidate.index_col);
      s_candidate.index_col = NULL;
    }
    make_page_strs();
    if (s_statusline_str != NULL) {
      free(s_statusline_str);
    }
    if (s_candidate_str != NULL) {
      free(s_candidate_str);
    }
    s_statusline_str = strdup(s_candidate.page_strs[s_candidate.page]);
    if (s_candidate.index != UNDEFINED) {
      get_candidate();
    } else {
      s_candidate_str = strdup("");
      s_candidate_col = UNDEFINED;
    }
  }
}

void callbacks_set_mode(int mode)
{
  s_mode = mode;
}
