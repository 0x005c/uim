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

#if HAVE_CONFIG_H
#include "config.h"
#endif
#ifndef DEBUG
#define NDEBUG
#endif
#include <stdio.h>
#if HAVE_CURSES_H
#include <curses.h>
#endif
#if HAVE_TERM_H
#include <term.h>
#endif
#if HAVE_UNISTD_H
#include <unistd.h>
#endif
#if HAVE_ASSERT_H
#include <assert.h>
#endif
#if HAVE_STDLIB_H
#include <stdlib.h>
#endif
#if HAVE_CTYPE_H
#include <ctype.h>
#endif
#if HAVE_STRING_H
#include <string.h>
#endif

#include "uim-fep.h"
#include "draw.h"
#include "escseq.h"
#include "str.h"
#include "read.h"

/* ���������ä��� */
static int s_use_civis = FALSE;
/* ���ơ������饤��μ��� */
static int s_status_type;
/* �����������TRUE */
static int s_init = FALSE;
/* ���ߤΥ���������� */
static struct point_tag s_cursor = {UNDEFINED, UNDEFINED};
/* ����������������ȼºݤΥ�������κ� */
static struct point_tag s_cursor_diff = {0, 0};
/* �������뤬�ä��Ƥ���Ȥ�TRUE */
static int s_cursor_invisible = FALSE;
/* ����������֤���¸�����Ȥ�TRUE */
static int s_save = FALSE;
/* ��¸������������ */
static struct point_tag s_save_cursor;
/* �ץꥨ�ǥ��åȤȥ��ơ������饤������褹��⡼�� */
static int s_uim_mode = FALSE;
/* uim_mode�ˤʤ�Ȥ��˽��Ϥ��륨�������ץ������� */
static const char *s_enter_uim_mode;
/* enter_underline_mode�˴ޤޤ����� */
static const char *s_enter_underline_num;
/* exit_underline_mode�˴ޤޤ����� */
static const char *s_exit_underline_num;
/* enter_standout_mode�˴ޤޤ����� */
static const char *s_enter_standout_num;
/* exit_standout_mode�˴ޤޤ����� */
static const char *s_exit_standout_num;
/* enter_bold_mode�˴ޤޤ����� */
static const char *s_bold_num;
/* enter_blink_mode�˴ޤޤ����� */
static const char *s_blink_num;
/* orig_pair�˴ޤޤ����� */
static const char *s_orig_pair_num;
/* orig_pair�˴ޤޤ��ǽ�ο��� */
static const char *s_orig_fore_num;
/* orig_pair�˴ޤޤ��2���ܤο��� */
static const char *s_orig_back_num;
/* ������ڤ�Ƥ��륨�������ץ������󥹤���¸����Хåե� */
static char *s_escseq_buf = NULL;

/* °���ʤ� */
static const struct attribute_tag s_attr_none = {
  FALSE,     /* underline */
  FALSE,     /* standout */
  FALSE,     /* bold */
  FALSE,     /* blink */
  FALSE,     /* foreground */
  FALSE      /* background */
};

/* uim�⡼�ɤ�°�� */
static struct attribute_tag s_attr_uim;
/* pty�⡼�ɤ�°�� */
static struct attribute_tag s_attr_pty = {
  FALSE,     /* underline */
  FALSE,     /* standout */
  FALSE,     /* bold */
  FALSE,     /* blink */
  FALSE,     /* foreground */
  FALSE      /* background */
};

/* ���ߤ�°�� */
static struct attribute_tag s_attr = {
  FALSE,     /* underline */
  FALSE,     /* standout */
  FALSE,     /* bold */
  FALSE,     /* blink */
  FALSE,     /* foreground */
  FALSE      /* background */
};

static void fixtty(void);
static char *escseq2n(const char *escseq);
static void escseq2n2(const char *escseq, const char **first, const char **second);
static const char *attr2escseq(const struct attribute_tag *attr);
static void set_attr(const char *str);
static void put_enter_uim_mode(void);
static void put_exit_uim_mode(void);
#ifndef HAVE_CFMAKERAW
static int cfmakeraw(struct termios *termios_p);
#endif

#if DEBUG > 1
static void print_attr(struct attribute_tag *attr);
#endif

/*
 * termcap/terminfo�Υ���ȥ꤬���뤫��ǧ����
 */
void init_escseq(int use_civis, int use_ins_del, int status_type, const struct attribute_tag *attr_uim)
{
  s_use_civis = use_civis;
  s_status_type = status_type;
  s_attr_uim = *attr_uim;

  if (enter_underline_mode == NULL) {
    printf("enter_underline_mode is not available\n");
    done(EXIT_FAILURE);
  }
  if (exit_underline_mode == NULL) {
    printf("exit_underline_mode is not available\n");
    done(EXIT_FAILURE);
  }
  if (enter_standout_mode == NULL) {
    printf("enter_standout_mode is not available\n");
    done(EXIT_FAILURE);
  }
  if (exit_standout_mode == NULL) {
    printf("exit_standout_mode is not available\n");
    done(EXIT_FAILURE);
  }
  if (exit_attribute_mode == NULL) {
    printf("exit_attribute_mode is not available\n");
    done(EXIT_FAILURE);
  }
  if (clr_eol == NULL) {
    printf("clr_eol is not available\n");
    done(EXIT_FAILURE);
  }
  if (cursor_address == NULL) {
    printf("cursor_address is not available\n");
    done(EXIT_FAILURE);
  }
  if (s_status_type == LASTLINE) {
    if (change_scroll_region == NULL) {
      printf("change_scroll_region is not available\n");
      done(EXIT_FAILURE);
    }
  }
  if (use_ins_del) {
    if (parm_ich == NULL) {
      printf("parm_ich is not available\n");
      done(EXIT_FAILURE);
    }
    if (parm_dch == NULL) {
      printf("parm_dch is not available\n");
      done(EXIT_FAILURE);
    }
  }
  s_enter_underline_num = escseq2n(enter_underline_mode);
  s_exit_underline_num = escseq2n(exit_underline_mode);
  s_enter_standout_num = escseq2n(enter_standout_mode);
  s_exit_standout_num = escseq2n(exit_standout_mode);
  s_bold_num = escseq2n(enter_bold_mode);
  s_blink_num = escseq2n(enter_blink_mode);
  s_orig_pair_num = escseq2n(orig_pair);
  escseq2n2(orig_pair, &s_orig_fore_num, &s_orig_back_num);
  s_enter_uim_mode = attr2escseq(&s_attr_uim);
  if (s_enter_uim_mode != NULL) {
    s_enter_uim_mode = strdup(s_enter_uim_mode);
  }
  fixtty();
  s_init = TRUE;
}

/*
 * ^[[7m$<2>����7����Ф�
 */
static char *escseq2n(const char *escseq)
{
  char *free_n;
  char *n;
  char *n2;
  if (escseq == NULL) {
    return NULL;
  }
  free_n = n = cut_padding(escseq);
  if ((n = strstr(n, "\033[")) == NULL) {
    free(free_n);
    return NULL;
  }
  n2 = n += 2;
  while (isdigit(n2[0])) {
    n2++;
  }
  if (n2[0] == 'm') {
    n2[0] = '\0';
    return n;
  } else {
    free(free_n);
    return NULL;
  }
}

/*
 * ^[[39;49m����39��49����Ф�
 */
static void escseq2n2(const char *escseq, const char **first, const char **second)
{
  char *free_n;
  char *n;
  char *n2;
  *first = *second = NULL;
  if (escseq == NULL) {
    return;
  }
  free_n = n = cut_padding(escseq);
  if ((n = strstr(n, "\033[")) == NULL) {
    free(free_n);
    return;
  }
  n2 = n += 2;
  while (isdigit(n2[0])) {
    n2++;
  }
  if (n2[0] == ';') {
    n2[0] = '\0';
    *first = n;
  } else {
    free(free_n);
    return;
  }
  n = ++n2;
  while (isdigit(n2[0])) {
    n2++;
  }
  if (n2[0] == 'm') {
    n2[0] = '\0';
    *second = n;
  } else {
    free(free_n);
    return;
  }
}

void quit_escseq(void)
{
  if (s_init == FALSE) {
    return;
  }
  put_exit_attribute_mode();
  if (s_status_type == LASTLINE) {
    put_save_cursor();
    put_change_scroll_region(0, g_win->ws_row);
    put_goto_lastline(0);
    putp(clr_eol);
    put_restore_cursor();
  }
  put_restore_cursor();
  put_cursor_normal();
}

/*
 * ü����raw�⡼�ɤˤ���
 */
static void fixtty(void)
{
  struct point_tag start_cursor;
  struct point_tag cursor;
  struct point_tag cursor2;
  static struct termios tios;

  tcgetattr(STDIN_FILENO, &tios);
  cfmakeraw(&tios);
  /* read_stdin�����ޤǤ��ɤޤʤ���Фʤ�ʤ��Ǿ���ʸ���� */
  tios.c_cc[VMIN] = 0;
  /* read_stdin�����ޤǤΥ����ॢ���� 0.1��ñ�� */
  tios.c_cc[VTIME] = 3;
  tcsetattr(STDIN_FILENO, TCSANOW, &tios);
  /* ���ϰ��֤���¸ */
  start_cursor = get_cursor_position();
  if (start_cursor.row == UNDEFINED) {
    printf("Report Cursor Position is not available\r\n");
    done(EXIT_FAILURE);
  }
  put_cursor_invisible();
  /* �ǲ��Ԥ��鳫�Ϥ����Ȥ��Τ���˥������� */
  if (s_status_type == LASTLINE) {
    putchar('\n');
  }
  /* �����ʰ��֤˰�ư */
  put_cursor_address(1, 1);
  s_cursor.row = s_cursor.col = UNDEFINED;
  /* ����������֤���� */
  cursor = get_cursor_position();
  s_cursor.row = s_cursor.col = UNDEFINED;
  /* ������������������֤˰�ư */
  put_cursor_address_p(&cursor);
  s_cursor.row = s_cursor.col = UNDEFINED;
  /* Ʊ������������֤������뤫 */
  cursor2 = get_cursor_position();
  /* �����ʤ��ä��麹ʬ��Ĵ�٤� */
  s_cursor_diff.row = cursor2.row - cursor.row;
  s_cursor_diff.col = cursor2.col - cursor.col;
  start_cursor.row -= s_cursor_diff.row;
  start_cursor.col -= s_cursor_diff.col;
  if (s_status_type == LASTLINE) {
    put_change_scroll_region(0, g_win->ws_row - 1);
  }
  if (s_status_type != BACKTICK) {
    draw_statusline_no_restore();
  }
  /* ���ϰ��֤���� */
  put_cursor_address_p(&start_cursor);
  put_cursor_normal();
}

#ifndef HAVE_CFMAKERAW
static int cfmakeraw(struct termios *termios_p)
{
  termios_p->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
  termios_p->c_oflag &= ~OPOST;
  termios_p->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
  termios_p->c_cflag &= ~(CSIZE | PARENB);
  termios_p->c_cflag |= CS8;
  return 0;
}
#endif

/*
 * ����������֤���¸����
 */
void put_save_cursor(void)
{
  if (!s_save) {
    s_save = TRUE;
    s_save_cursor = get_cursor_position();
    debug(("<put_save_cursor>"));
  }
}

/*
 * ��¸��������������֤���������
 */
void put_restore_cursor(void)
{
  if (s_save) {
    s_save = FALSE;
    put_cursor_address_p(&s_save_cursor);
    debug(("<put_restore_cursor>"));
  }
}

/*
 * ���ߤΥ���������֤��֤�
 * �����0, 0
 * ����������֤������ʤ��ä���UNDEFINED���֤�
 */
struct point_tag get_cursor_position(void)
{
  char ibuf[100];
  char *ibuf_offset;
  ssize_t len;
  char *escseq = NULL;
  int loop_count = 0;
  char *unget_buf = NULL;
  char *unget_buf2 = NULL;
  int buf_size = 0;
  int offset = 0;
  if (s_cursor.row != UNDEFINED) {
    return s_cursor;
  }
  printf("\033[6n");

  do {
    /* 10��롼�פ��Ƥ������ä��齪λ */
    if (loop_count++ >= 10) {
      break;
    }
    ibuf_offset = ibuf + offset;
    len = read_stdin(ibuf_offset, sizeof(ibuf) - offset);
    if (len <= 0) {
      continue;
    }
    ibuf_offset[len] = '\0';
    debug2(("get = %s\n", ibuf));
    escseq = strstr(ibuf, "\033");
    if (escseq != NULL) {
      int n;
      unget_buf2 = malloc(offset + len);
      /* unget_buf2[0] == 'R' */
      n = sscanf(escseq, "\033[%d;%d%s", &(s_cursor.row), &(s_cursor.col), unget_buf2);
      if (n < 3) {
        /* ESC�Ϥ��뤬, ���������ץ������󥹤Ȥ��Ƥ��Խ�ʬ */
        offset += len;
        s_cursor.row = s_cursor.col = UNDEFINED;
      } else {
        char *R = strchr(escseq, 'R');
        /* R��ɬ������ */
        assert(R != NULL);
        /* R�μ���ʸ�������뤫 */
        if (R[1] != '\0') {
          strcpy(unget_buf2, R + 1);
        } else {
          free(unget_buf2);
          unget_buf2 = NULL;
        }
      }
    } else {
      offset += len;
    }
  } while (s_cursor.row == UNDEFINED);

  /* ���������ץ������󥹤�����ʸ���󤬤��뤫 */
  if (escseq > ibuf) {
    unget_buf = malloc(escseq - ibuf);
    memcpy(unget_buf, ibuf, escseq - ibuf);
    buf_size += (escseq - ibuf);
  }

  /* ���������ץ������󥹤θ��ʸ���󤬤��뤫 */
  if (unget_buf2 != NULL) {
    int buf_size2 = strlen(unget_buf2);
    unget_buf = realloc(unget_buf, buf_size + buf_size2);
    memcpy(unget_buf + buf_size, unget_buf2, buf_size2);
    buf_size += buf_size2;
    free(unget_buf2);
  }

  if (buf_size > 0) {
    unget_stdin(unget_buf, buf_size);
    free(unget_buf);
  }

  if (s_cursor.row == UNDEFINED) {
    /* ���� */
    /* s_cursor.row = s_cursor.col = 0; */
    return s_cursor;
  }

  s_cursor.row--;
  s_cursor.col--;
  s_cursor.row -= s_cursor_diff.row;
  s_cursor.col -= s_cursor_diff.col;

  /* screen�ǤϤ����ʤ뤳�Ȥ����� */
  if (s_cursor.col > g_win->ws_col - 1) {
    put_crlf();
  }
  debug(("<get row = %d col = %d>", s_cursor.row, s_cursor.col));
  return s_cursor;
}

/*
 * ��������򸫤��ʤ��褦�ˤ���
 */
void put_cursor_invisible(void)
{
  if (s_use_civis && !s_cursor_invisible && cursor_invisible != NULL && cursor_normal != NULL) {
    s_cursor_invisible = TRUE;
    putp(cursor_invisible);
    debug(("<invis>"));
  }
}

/*
 * ��������򸫤���褦�ˤ���
 */
void put_cursor_normal(void)
{
  if (s_cursor_invisible) {
    s_cursor_invisible = FALSE;
    putp(cursor_normal);
    debug(("<norm>"));
  }
}

/*
 * underline�⡼�ɤ򳫻Ϥ���
 */
void put_enter_underline_mode(void)
{
  put_enter_uim_mode();
  if (!s_attr.underline) {
    s_attr.underline = TRUE;
    putp(enter_underline_mode);
    debug(("<{_>"));
  }
}

/*
 * underline�⡼�ɤˤʤäƤ����顢underline�⡼�ɤ�standout�⡼�ɤ�λ����
 */
void put_exit_underline_mode(void)
{
  if (s_attr.underline) {
    if (!s_uim_mode) {
      s_uim_mode = TRUE;
      debug(("<{uim>"));
      s_attr_pty = s_attr;
    }
    put_exit_attribute_mode();
    if (s_enter_uim_mode != NULL) {
      putp(s_enter_uim_mode);
      debug(("%s", s_enter_uim_mode));
    }
    /* debug(("<_}>")); */
  }
}

/*
 * standout�⡼�ɤ򳫻Ϥ���
 */
void put_enter_standout_mode(void)
{
  put_enter_uim_mode();
  if (!s_attr.standout) {
    s_attr.standout = TRUE;
    putp(enter_standout_mode);
    debug(("<{r>"));
  }
}

/*
 * standout�⡼�ɤˤʤäƤ����顢underline�⡼�ɤ�standout�⡼�ɤ�λ����
 */
void put_exit_standout_mode(void)
{
  if (s_attr.standout) {
    if (!s_uim_mode) {
      s_uim_mode = TRUE;
      debug(("<{uim>"));
      s_attr_pty = s_attr;
    }
    put_exit_attribute_mode();
    if (s_enter_uim_mode != NULL) {
      putp(s_enter_uim_mode);
      debug(("%s", s_enter_uim_mode));
      debug(("<{uim>"));
    }
    /* debug(("<r}>")); */
  }
}

/*
 * standout�⡼�ɡ�underline�⡼�ɤ�λ����
 * ʸ�������طʿ��򸵤��᤹
 */
void put_exit_attribute_mode(void)
{
  s_attr = s_attr_none;
  putp(exit_attribute_mode);
  debug(("<a}>"));
}

/*
 * °����from����to���ѹ�����
 */
static void change_attr(const struct attribute_tag *from, const struct attribute_tag *to)
{
  const char *escseq;
  if ((from->underline && !to->underline)
      || (from->standout && !to->standout)
      || (from->bold && !to->bold)
      || (from->blink && !to->blink)
      || (from->foreground != FALSE && to->foreground == FALSE)
      || (from->background != FALSE && to->background == FALSE)
      ) {
    put_exit_attribute_mode();
    escseq = attr2escseq(to);
  } else {
    struct attribute_tag attr = *to;
    if (from->underline == to->underline) {
      attr.underline = FALSE;
    }
    if (from->standout == to->standout) {
      attr.standout = FALSE;
    }
    if (from->bold == to->bold) {
      attr.bold = FALSE;
    }
    if (from->blink == to->blink) {
      attr.blink = FALSE;
    }
    if (from->foreground == to->foreground) {
      attr.foreground = FALSE;
    }
    if (from->background == to->background) {
      attr.background = FALSE;
    }
    escseq = attr2escseq(&attr);
  }
  if (escseq != NULL) {
    putp(escseq);
    debug(("change_attr %s\n", escseq));
  }
}

/*
 * uim�⡼�ɤ򳫻Ϥ���
 */
static void put_enter_uim_mode(void)
{
  if (!s_uim_mode) {
    s_uim_mode = TRUE;
    s_attr_pty = s_attr;
    s_attr_uim.standout = s_attr.standout;
    s_attr_uim.underline = s_attr.underline;
    change_attr(&s_attr, &s_attr_uim);
    debug(("<{uim>"));
    s_attr = s_attr_uim;
  }
}

/*
 * uim�⡼�ɤ�λ����
 */
static void put_exit_uim_mode(void)
{
  if (s_uim_mode) {
    s_uim_mode = FALSE;
    change_attr(&s_attr, &s_attr_pty);
    debug(("<uim}>"));
    s_attr = s_attr_pty;
  }
}

/*
 * attr���б����륨�������ץ������󥹤��֤�
 * �֤��ͤ���Ū�ʥХåե�
 */
static const char *attr2escseq(const struct attribute_tag *attr)
{
  static char escseq[20];
  int add_semicolon = FALSE;
  if (!attr->underline && !attr->standout && !attr->bold && !attr->blink
      && attr->foreground == FALSE && attr->background == FALSE) {
    return NULL;
  }
  strcpy(escseq, "\033[");
  if (attr->underline && s_enter_underline_num != NULL) {
    add_semicolon = TRUE;
    strcat(escseq, s_enter_underline_num);
  }
  if (attr->standout && s_enter_standout_num != NULL) {
    if (add_semicolon) {
      strcat(escseq, ";");
    } else {
      add_semicolon = TRUE;
    }
    strcat(escseq, s_enter_standout_num);
  }
  if (attr->bold && s_bold_num != NULL) {
    if (add_semicolon) {
      strcat(escseq, ";");
    } else {
      add_semicolon = TRUE;
    }
    strcat(escseq, s_bold_num);
  }
  if (attr->blink && s_blink_num != NULL) {
    if (add_semicolon) {
      strcat(escseq, ";");
    } else {
      add_semicolon = TRUE;
    }
    strcat(escseq, s_blink_num);
  }
  if (attr->foreground != FALSE) {
    if (add_semicolon) {
      strcat(escseq, ";");
    } else {
      add_semicolon = TRUE;
    }
    sprintf(escseq + strlen(escseq), "%d", attr->foreground);
  }
  if (attr->background != FALSE) {
    if (add_semicolon) {
      strcat(escseq, ";");
    }
    sprintf(escseq + strlen(escseq), "%d", attr->background);
  }
  strcat(escseq, "m");
  debug2(("attr2escseq underline = %d standout = %d bold = %d blink = %d fore = %d back = %d\n",
      attr->underline, attr->standout, attr->bold, attr->blink,
      attr->foreground, attr->background));
  debug2(("attr2escseq = %s\n", escseq));
  return escseq;
}

/*
 * str����°�����ѹ����륨�������ץ������󥹤�õ��
 */
static void set_attr(const char *str)
{
  /* ���������ץ������󥹤γ��� */
  const char *start;
  const char *free_str = NULL;
  /* TRUE�ΤȤ�free_str��free����ɬ�פ����� */
  int must_free = FALSE;
  /* ���������ΥХåե������뤫 */
  if (s_escseq_buf != NULL) {
    const char *tmp_str = str;
    must_free = TRUE;
    free_str = str = malloc(strlen(s_escseq_buf) + strlen(tmp_str) + 1);
    sprintf((char *)str, "%s%s", s_escseq_buf, tmp_str);
    free(s_escseq_buf);
    s_escseq_buf = NULL;
  }

  while ((start = str = strstr(str, "\033")) != NULL) {
    str++;
    if (str[0] == '\0') {
      s_escseq_buf = strdup(start);
    }

    else if (str[0] == '[') {
      int nr_params = 1;
      /* ^[[1;2;3��1, 2, 3������� */
      int *params = malloc(sizeof(int));
      params[0] = 0;
      str++;

      while (isdigit(str[0]) || str[0] == ';') {
        if (isdigit(str[0])) {
          int n = 0;
          while (isdigit(str[0])) {
            n = n * 10 + str[0] - '0';
            str++;
          }
          params[nr_params - 1] = n;
        }
        if (str[0] == ';') {
          nr_params++;
          params = realloc(params, sizeof(int) * nr_params);
          params[nr_params - 1] = 0;
          str++;
        }
      }

      if (str[0] == '\0') {
        s_escseq_buf = strdup(start);
      }

      else if (str[0] == 'm') {
        int i;
        str++;
        for (i = 0; i < nr_params; i++) {
          if (params[i] == 0) {
            /* °���õ� */
            s_attr = s_attr_none;
          } else if (s_enter_underline_num != NULL && params[i] == atoi(s_enter_underline_num)) {
            s_attr.underline = TRUE;
          } else if (s_exit_underline_num != NULL && params[i] == atoi(s_exit_underline_num)) {
            s_attr.underline = FALSE;
          } else if (s_enter_standout_num != NULL && params[i] == atoi(s_enter_standout_num)) {
            s_attr.standout = TRUE;
          } else if (s_exit_standout_num != NULL && params[i] == atoi(s_exit_standout_num)) {
            s_attr.standout = FALSE;
          } else if (s_bold_num != NULL && params[i] == atoi(s_bold_num)) {
            s_attr.bold = TRUE;
          } else if (s_blink_num != NULL && params[i] == atoi(s_blink_num)) {
            s_attr.blink = TRUE;
          } else if (s_orig_pair_num != NULL && params[i] == atoi(s_orig_pair_num)) {
            s_attr.foreground = s_attr.background = FALSE;
          } else if (s_orig_fore_num != NULL && params[i] == atoi(s_orig_fore_num)) {
            s_attr.foreground = FALSE;
          } else if (s_orig_back_num != NULL && params[i] == atoi(s_orig_back_num)) {
            s_attr.background = FALSE;
          } else if (params[i] == 22) {
            s_attr.bold = FALSE;
          } else if (params[i] == 25) {
            s_attr.blink = FALSE;
          } else if ((30 <= params[i] && params[i] <= 37) || (90 <= params[i] && params[i] <= 97)) {
            s_attr.foreground = params[i];
          } else if ((40 <= params[i] && params[i] <= 47) || (100 <= params[i] && params[i] <= 107)) {
            s_attr.background = params[i];
          }
        }
      }
      free(params);
    }
  }
  if (must_free) {
    free((char *)free_str);
  }
}

/*
 * row�� col��˰�ư����
 * �����0, 0
 */
void put_cursor_address(int row, int col)
{
  if (row >= g_win->ws_row) {
    row = g_win->ws_row - 1;
  }
  /* ��ü�ؤΰ�ư�Ͼ�ά���ʤ� */
  if (row == s_cursor.row && col == s_cursor.col && col < g_win->ws_col - 2) {
    return;
  }
  putp(tparm(cursor_address, row, col));
  s_cursor.row = row;
  s_cursor.col = col;
  debug(("<go %d %d>", row, col));
}

void put_cursor_address_p(struct point_tag *p)
{
  put_cursor_address(p->row, p->col);
}

/*
 * nʸ����������
 */
void put_insert(int n)
{
  if (n <= 0) {
    return;
  }
  putp(tparm(parm_ich, n));
  debug(("<ins %d>", n));
}

/*
 * nʸ���õ��
 */
void put_delete(int n)
{
  if (n <= 0) {
    return;
  }
  if (back_color_erase) {
    put_exit_underline_mode();
    put_exit_standout_mode();
  }
  putp(tparm(parm_dch, n));
  debug(("<del %d>", n));
}

/*
 * ���Ԥ���
 */
void put_crlf(void)
{
  printf("\r\n");
  s_cursor.col = 0;
  s_cursor.row++;
  if (s_cursor.row >= g_win->ws_row) {
    s_cursor.row = g_win->ws_row - 1;
  }
  debug(("<crlf>"));
}

/*
 * �ǲ��Ԥ�col�˰�ư����
 */
void put_goto_lastline(int col)
{
  int row = g_win->ws_row;
  if (row == s_cursor.row && col == s_cursor.col) {
    return;
  }
  putp(tparm(cursor_address, row, col));
  s_cursor.row = row;
  s_cursor.col = col;
  debug(("<go %d %d>", row, col));
}

/*
 * underline�⡼�ɤ�standout�⡼�ɤ�λ����nʸ�����ڡ�������Ϥ���
 * ���̤α�ü��ۤ��ƤϤ����ʤ�
 */
void put_erase(int n)
{
  int i;
  char *spaces;
  if (n <= 0) {
    return;
  }
  spaces = malloc(n + 1);
  put_exit_underline_mode();
  put_exit_standout_mode();
  for (i = 0; i < n; i++) {
    spaces[i] = ' ';
  }
  spaces[n] = '\0';
  put_uim_str(spaces);
  free(spaces);
}

/*
 * underline�⡼�ɤ�standout�⡼�ɤ�λ���ƹ����ޤǾõ�
 * ����������֤��Ѥ��ʤ�
 */
void put_clear_to_end_of_line(int width)
{
  put_enter_uim_mode();
  if (s_attr_uim.background != FALSE && !back_color_erase) {
    put_erase(width);
    return;
  }
  if (back_color_erase) {
    put_exit_standout_mode();
    put_exit_underline_mode();
  }
  putp(clr_eol);
  debug(("<clear>"));
}

/*
 * ü���������ΰ��start����end�����ꤹ��
 */
void put_change_scroll_region(int start, int end)
{
  putp(tparm(change_scroll_region, start, end));
  s_cursor.row = s_cursor.col = 0;
  debug(("<region %d %d>", start, end));
}

/*
 * str��ü���˽��Ϥ���
 * ���̤α�ü��ۤ��ƤϤ����ʤ�
 * ���������ץ������󥹤ϴޤޤʤ�
 */
void put_uim_str(const char *str)
{
  if (str[0] == '\0') {
    return;
  }
  if (s_escseq_buf != NULL) {
    free(s_escseq_buf);
    s_escseq_buf = NULL;
  }
  put_enter_uim_mode();
  s_cursor.col += strwidth(str);
  assert(s_cursor.col <= g_win->ws_col);
  printf("%s", str);
  debug(("<put_uim_str \"%s\">", str));
}

/* str��len�������Ϥ���
 * const char *str�ȤʤäƤ��뤬�����Ū�˽񴹤���Τ�str��ʸ�������
 * �ˤ��ƤϤ����ʤ���
 */
void put_uim_str_len(const char *str, int len)
{
  char save_char = str[len];
  ((char *)str)[len] = '\0';
  put_uim_str(str);
  ((char *)str)[len] = save_char;
}

/*
 * pty����ν���str��ü���˽��Ϥ���
 * ���������ץ������󥹤�ޤ��礬����
 */
void put_pty_str(const char *str)
{
  if (str[0] == '\0') {
    return;
  }
  put_exit_uim_mode();
  printf("%s", str);
  set_attr(str);
  g_commit = FALSE;
  s_cursor.row = s_cursor.col = UNDEFINED;
  debug(("<put_pty_str \"%s\">", str));
}


/*
 * escseq����/$<\d+>/�����������Τ��֤�
 * escseq��NULL���ä���NULL���֤�
 */
char *cut_padding(const char *escseq)
{
  int i, j;
  char *cut_str;
  if (escseq == NULL) {
    return NULL;
  }
  cut_str = malloc(strlen(escseq) + 1);
  for (i = 0, j = 0; escseq[i] != '\0';) {
    if (escseq[i] == '$' && escseq[i + 1] == '<') {
      int i2 = i + 1;
      while (isdigit(escseq[++i2]));
      if (escseq[i2] == '>') {
        i = i2 + 1;
        if (escseq[i] == '\0') {
          break;
        }
      }
    }
    cut_str[j++] = escseq[i++];
  }
  cut_str[j] = '\0';
  return cut_str;
}

/*
 * ü�����������ѹ����줿�Ȥ��˸Ƥ�
 */
void escseq_winch(void)
{
  s_cursor.row = s_cursor.col = UNDEFINED;
}

#if DEBUG > 1
static void print_attr(struct attribute_tag *attr)
{
  debug(("underline = %d standout = %d bold = %d blink = %d fore = %d back = %d\n",
      attr->underline, attr->standout, attr->bold, attr->blink,
      attr->foreground, attr->background));
}
#endif
