/*
 *  $Id:$
 *  Copyright (c) 2003,2004 Masahito Omote <omote@utyuuzin.net>
 *
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. Neither the name of authors nor the names of its contributors
 *     may be used to endorse or promote products derived from this software
 *     without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
 *  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 */

/*
 * 2004-10-15 Takuro Ashie <ashie@good-day.co.jp>
 *   * �����plugin���Τ���Υ��񤭤��ɲ�
 *     (�������ܸ���ä��Τǡ�������ܸ��)
 * 2004-09-30 Takuro Ashie <ashie@good-day.co.jp>
 *   * uim-pref�Ѥ˽���
 */

#ifndef __dict_word_h_included__
#define __dict_word_h_included__

/*
 *  enum�ǤϤʤ�ʸ������ѹ�?
 */
typedef enum _uim_word_type {
    WORD_TYPE_ANTHY,
    WORD_TYPE_CANNA,
    WORD_TYPE_SKK,
    WORD_TYPE_PRIME
} uim_word_type;

/* 
 *  - �ϥå���ơ��֥뤫�����ǥǡ������������charset��phon��desc�ʳ���
 *    ���ƤΥ��С��򱣤����ۤ����ɤ����⤷��ʤ���
 *    ���ƤΥǡ����ϴؿ���ͳ�ǥ�������
 *  - ����饯�������åȤϥ��ꥸ�ʥ�ξ��֤��ݻ��������ѻ���Ŭ���Ѵ����뤳��
 *  - �Ȥꤢ�����������Ǥ�GLib��¸���ӽ����뤳��
 *    (�������Ǥ�)���Υ��֥������Ȥ���Ѥ���Τ�Gtk+�ե��ȥ���ɤΤߤȤ�
 *    �¤�ʤ���
 *  - ¾�θ���ξ��Ϥ��θ����ǥǡ�����¤�򵭽Ҥ��������ڤǤ��ꡤ�ޤ�������
 *    �̤Ϥ���¿���ʤ��������餯���Ƥ��Ѵ����󥸥��ʬ��ޤ�Ƥ�1���⤢��е���
 *    �Ǥ���Ȼפ���Τǡ������������θ����Τ�̵��̣���⤷��ʤ���
 */
typedef struct _uim_word {
    uim_word_type   type;           /* ����: word_type*/
				    /* FIXME! enum����ʸ����������ɤ�����
				       (plugin�����θ) */

    /* common fields */
    char       *charset;            /* ʸ����Υ���饯�������å� */

    char       *phon;		    /* �ɤ� */
    char       *desc;	            /* ���� */
    char       *cclass_code;	    /* �ʻ쥳���� or �ʻ� */
				    /* FIXME! �ʻ쥳���ɤ��ʻ��ʬ�����ۤ����ɤ�? */
				    /* ���ߤ�(�����ɤǤϤʤ�)�ʻ�̾(����)����Ǽ����Ƥ��� */
    int	        freq;		    /* ���� */

    /* SKK specific fields */       /* FIXME! �����Τ��Ѿ���ʬΥ */
    int	        okuri;	            /* �����̵ͭ (boolean) */
    char       *following_kana;     /* ����ͭ��ξ��˼���³�����꤬�� XXX */
    char       *annotation;	    /* ���Υơ������ */

    struct _uim_word *next;
} uim_word;

/* ���ͤ���ޤäƤʤ��ΤǾ�ά���� */
/* prototypes */
void      word_append    (uim_word **head, uim_word_type type,
			  char *charset,
			  char *phon, char *desc,
			  char *cclass_code, int freq,
			  int okuri, char *annotation);
void      word_free_list (uim_word *head);
uim_word *word_last      (uim_word *list);

#endif /* __dict_word_h_included__ */
