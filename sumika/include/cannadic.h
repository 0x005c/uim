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
 *  THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 *  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 *
 * This code is based on canna's code. For more information about canna,
 * visit http://canna.sourceforge.jp/ . Canna license is as follows,
 *
 * Copyright (c) 2002 Canna Project. All rights reserved.
 *
 * Permission to use, copy, modify, distribute and sell this software
 * and its documentation for any purpose is hereby granted without
 * fee, provided that the above copyright notice appear in all copies
 * and that both that copyright notice and this permission notice
 * appear in supporting documentation, and that the name of the
 * author and contributors not be used in advertising or publicity
 * pertaining to distribution of the software without specific, written
 * prior permission.  The author and contributors no representations
 * about the suitability of this software for any purpose.  It is
 * provided "as is" without express or implied warranty.
 *
 * THE AUTHOR AND CONTRIBUTORS DISCLAIMS ALL WARRANTIES WITH REGARD TO
 * THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS, IN NO EVENT SHALL THE AUTHOR AND CONTRIBUTORS BE LIABLE FOR
 * ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
 * RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
 * CONTRACT, NEGLIGENCE OR OTHER TORTUOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Copyright 1994 NEC Corporation, Tokyo, Japan.
 *
 * Permission to use, copy, modify, distribute and sell this software
 * and its documentation for any purpose is hereby granted without
 * fee, provided that the above copyright notice appear in all copies
 * and that both that copyright notice and this permission notice
 * appear in supporting documentation, and that the name of NEC
 * Corporation not be used in advertising or publicity pertaining to
 * distribution of the software without specific, written prior
 * permission.	NEC Corporation makes no representations about the
 * suitability of this software for any purpose.  It is provided "as
 * is" without express or implied warranty.
 *
 * NEC CORPORATION DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN
 * NO EVENT SHALL NEC CORPORATION BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
 * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTUOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef __CANNADIC_H__
#define __CANNADIC_H__

#include "word.h"
#include <glib.h>

#define SUPPORT_ANTHY 0x1 
#define SUPPORT_CANNA 0x2
#define SUPPORT_ANTHY_CANNA (SUPPORT_ANTHY|SUPPORT_CANNA)

enum {
    POS_VERB,
    POS_SUBSTANTIVE,
    POS_ADJECTIVE,
    POS_ADVERB,
    POS_ETC
};

typedef struct _category_code {
    char *code;
    char *desc;
    char *example;
    int   flag;
    int   type;
} category_code;

static category_code substantive_code[]= {
    { "#T00", "T00", "", 31, 3 },
    { "#T01", "T01", "", 31, 3 },
    { "#T02", "T02", "", 30, 3 },
    { "#T03", "T03", "", 29, 3 },
    { "#T04", "T04", "", 28, 3 },
    { "#T05", "T05", "", 27, 3 },
    { "#T06", "T06", "", 27, 3 },
    { "#T07", "T07", "", 26, 3 },
    { "#T08", "T08", "", 25, 3 },
    { "#T09", "T09", "", 24, 3 },
    { "#T10", "T10", "", 23, 3 },
    { "#T11", "T11", "", 23, 3 },
    { "#T12", "T12", "", 22, 3 },
    { "#T13", "T13", "", 21, 3 },
    { "#T14", "T14", "", 20, 3 },
    { "#T15", "T15", "", 19, 3 },
    { "#T16", "T16", "", 19, 3 },
    { "#T17", "T17", "", 18, 3 },
    { "#T18", "T18", "", 17, 3 },
    { "#T19", "T19", "", 16, 3 },
    { "#T20", "T20", "", 15, 3 },
    { "#T21", "T21", "", 15, 3 },
    { "#T22", "T22", "", 14, 3 },
    { "#T23", "T23", "", 13, 3 },
    { "#T24", "T24", "", 12, 3 },
    { "#T25", "T25", "", 11, 3 },
    { "#T26", "T26", "", 11, 3 },
    { "#T27", "T27", "", 10, 3 },
    { "#T28", "T28", "", 9,  3 },
    { "#T29", "T29", "", 8,  3 },
    { "#T30", "T30", "", 7,  3 },
    { "#T31", "T31", "", 7,  3 },
    { "#T32", "T32", "", 6,  3 },
    { "#T33", "T33", "", 5,  3 },
    { "#T34", "T34", "", 4,  3 },
    { "#T35", "T35", "", 3,  3 },
    { "#T36", "T36", "", 3,  3 },
    { "#T37", "T37", "", 2,  3 },
    { "#T38", "T38", "", 1,  3 },
    { "#T39", "T39", "", 0,  3 },
    { "#CN",  "��̾"                         , "���", 0, 3 },
    { "#CNS", "��̾(������)"                 , "�����", 0, 3 },
    { "#JCN", "��̾(�����)"                 , "Ĺ��", 0, 3 },
    { "#JN",  "��̾"                         , "����,��", 0, 3 },
    { "#JNS", "��̾(��)"                     , "¢��", 0, 3 },
    { "#JNM", "��̾(̾)"                     , "����", 0, 1 },
    { "#KK",  "���/����"                    , "�����ŵ�", 0, 3 },
};

static category_code adverb_code[] = {
    { "#F00", "F00", "����,���뤰��,�Ҥ��Ҥ�,�ġ�", 15, 3 },
    { "#F01", "F01", "Ƚ��,����,����,����,����,����", 14, 3 },
    { "#F02", "F02", "����,����,�Ǹ�,Ʋ��,�䡹,�䡹", 13, 3 },
    { "#F03", "F03", "����,�´�,����,����,�ۡ�,����", 12, 3 },
    { "#F04", "F04", "�դä���,��ä���", 11, 3 },
    { "#F05", "F05", "��������,����,���老��,���Ĥ���", 10, 3 },
    { "#F06", "F06", "����,����,�١�,�ŤͽŤ�,�ޤ��ޤ�,�श�श",  9, 3 },
    { "#F07", "F07", "",  8, 3 },
    { "#F08", "F08", "",  7, 3 },
    { "#F09", "F09", "",  6, 3 },
    { "#F10", "F10", "",  5, 3 },
    { "#F11", "F11", "",  4, 3 },
    { "#F12", "F12", "���ä�,���ä�,�ۤä�,�դ�,�ۤä�,��ä�",  3, 3 },
    { "#F13", "F13", "",  2, 3 },
    { "#F14", "F14", "���Ѥ�餺,������,˰���ޤ�",  1, 3 },
    { "#F15", "F15", "",  0, 3 },
};

/**
 * K5,  ����5��,              �֤�   
 * K5r, ����5��:Ϣ�ѷ���̾��, ��   
 * C5r, �Ԥ�5��:Ϣ�ѷ���̾��, �Ԥ�
 * G5,  ����5��,              �Ĥ�
 * G5r, ����5��:Ϣ�ѷ���̾��, �ޤ�
 * S5,  ����5��,              ����
 * S5r, ����5��:Ϣ�ѷ���̾��, �ܤ�
 * T5,  ����5��,              ���
 * T5r, ����5��:Ϣ�ѷ���̾��, �Ǥ�
 * N5,  �ʹ�5��,              ���
 * B5,  �й�5��,              ž��
 * B5r, �й�5��:Ϣ�ѷ���̾��, ͷ��
 * M5,  �޹�5��,              ����
 * M5r, �޹�5��:Ϣ�ѷ���̾��, �Ԥ�
 * R5,  ���5��,              ��ĥ��
 * R5r, ���5��:Ϣ�ѷ���̾��, �դ�
 * L5,  ���5��:̿�������,   ����ä����
 * W5,  ���5��,              ����
 * W5r, ���5��:Ϣ�ѷ���̾��, ����
 * U5,  ��5��,              ��
 * U5r, ��5��:Ϣ�ѷ���̾��, �䤦
 * KS,  �岼1��,              �ߤ��
 *                            Ϳ����
 * KSr, �岼1��:�촴��̾��,   ������
 *                            �¤���
 * KX,  ���ѳ���ư��,         ���
 * SX,  ���ѳ���ư��,         �ؤ���
 * ZX,  ���ѳ���ư��,         ������
 * NZX, ���ѳ���ư��,       �Ť󤺤� 
 **/

static category_code verb_code[]= {
    { "#K5",  "����5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#K5r", "����5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#C5r", "�Ԥ�5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#G5" , "����5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#G5r", "����5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#S5" , "����5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#S5r", "����5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#T5" , "����5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#T5r", "����5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#N5",  "�ʹ�5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#N5r", "�ʹ�5��:Ϣ̾"  , "", 0, 1 },
    { "#B5",  "�й�5��"       , "ž/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#B5r", "�й�5��:Ϣ̾"  , "ͷ/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#M5",  "�޹�5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#M5r", "�޹�5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#R5" , "���5��"       , "��ĥ/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#R5r", "���5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#L5",  "���5��:̿�ᥤ", "����ä���/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#W5",  "���5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#W5r", "���5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#U5" , "��5��"       , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },
    { "#U5r", "��5��:Ϣ̾"  , "��/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 3 },

    { "#KS",  "�岼1��"       , "��,Ϳ/��,��(�ʤ�)/��,��(�ޤ�)/���,����/���,����(����)/���,����(��)/���,����(��)", 0, 3 },
    { "#KSr", "�岼1��:�촴̾", "��,��/��,��(�ʤ�)/��,��(�ޤ�)/����,����/����,����(����)/����,����(��)/����,����(��)", 0, 3 },
    { "#KX",  "���ѳ���ư��"  , "��/��(�ʤ�)/��(�ޤ�)/����/����(����)/����(��)/����(��)", 0, 2 },
    { "#SX",  "���ѳ���ư��"  , "��/��(�ʤ�)/��(�ޤ�)/����/����(����)/����(��)/����", 0, 3 },
    { "#ZX",  "���ѳ���ư��"  , "��/��(�ʤ�)/��(�ޤ�)/����/����(����)/����(��)/����", 0, 3 },
    { "#NZX", "���ѳ���ư��", "�Ť�/��(�ʤ�)/��(�ޤ�)/��/��(����)/��(��)/��(��)", 0, 2 },
};

/***
 * KY,    ��                   ������
 * KYT,   ̾�ʥΡ���    �ͳѤ�,������
 * KYna,  ��            ������,�礭��  (���Ѥ�[��(Ϣ����ˡ��]��������ƻ�)
 * KYmi,  ��            �������Ť�     (�ߤǽ����̾���ž��������ƻ�)
 * KYme,  ��            ���ᡢĹ��     (��ǽ���ȷ���ư���ž��������ƻ�)
 * KYmime,��            ���ߡ�����     KYmi, KYme ��ξ�����������碌����
 * KYU,   ��:������     �����夦
 **/

static category_code adjective_code[] = {
    { "#KY",     "���ƻ�"           , "������", 0, 3 },
    { "#KYT",    "���ƻ�:̾�ʥ�"    , "�ͳѤ�, ������", 0, 3 },
    { "#KYna",   "���ƻ�:Ϣ����ˡ��", "������, �礭��", 0, 3 },
    { "#KYmi",   "���ƻ�:��"        , "����, �Ť�", 0, 3 },
    { "#KYme",   "���ƻ�:��"        , "����, Ĺ��", 0, 3 },
    { "#KYmime", "���ƻ�:�ߤ�"      , "����, ����", 0, 3 },
    { "#KYU",    "���ƻ�:������"    , "�����夦", 0, 3 },
};

static category_code etc_code[] = {
    { "#KJ",  "��ʸ������"                   , "ñ�����Ѵ���", 0, 3 },
/*
    { "#CN",  "��̾"                         , "���", 0, 3 },
    { "#CNS", "��̾(������)"                 , "�����", 0, 3 },
    { "#JCN", "��̾(�����)"                 , "Ĺ��", 0, 3 },
    { "#JN",  "��̾"                         , "����,��", 0, 3 },
    { "#JNS", "��̾(��)"                     , "¢��", 0, 3 },
    { "#JNM", "��̾(̾)"                     , "����", 0, 1 },
    { "#KK",  "���/����"                    , "�����ŵ�", 0, 3 },
*/
    { "#CJ",  "��³��/��ư��/Ϣ��"           , "", 0, 3 },
    { "#RT",  "Ϣ�λ�"                       , "", 0, 3 },
    { "#OKX", "ư�����ǫɽ���θ촴"         , "", 0, 3 },
    { "#NN",  "����:����"                    , "��,��", 0, 3 },
    { "#N00", "����:x��,x��,x��"             , "x��,x��,x��", 0, 3 },
    { "#N01", "����:��,����,��,����"         , "��,����,��,����", 0, 3 },
    { "#N02", "����:ɴ,��ɴ,��,��ɴ"         , "ɴ,��ɴ,��,��ɴ", 0, 3 },
    { "#N03", "����:��,��,��,����"         , "��,��,��,����", 0, 3 },
    { "#KN",  "����̾��"                     , "����/����/����/����/", 0, 3 },
    { "#TKN", "������̾��"                   , "�Ϥ�/�櫓", 0, 2 },
    { "#JTNO","���θ�̾��"                   , "���餤/���餤/����", 0, 2 },
    { "#PRE", "��Ƭ��"                       , "", 0, 3 },
    { "#CNPRE", "��Ƭ��:����"                , "", 0, 3 },
    { "#JNPRE", "��Ƭ��:��̾"                , "", 0, 2 },
    { "#NNPRE", "��Ƭ��:����"                , "", 0, 3 },
    { "#SNPRE", "��Ƭ��:����̾��"            , "", 0, 2 },
    { "#SUN",   "������:����"                , "", 0, 2 },
    { "#CNSUC1","������:��̾ 1"              , "", 0, 3 },
    { "#CNSUC2","������:��̾ 2"              , "", 0, 3 },
    { "#JNSUC" ,"������:��̾"                , "", 0, 3 },
    { "#N2T30", "������:����̾�첽"          , "(̾)+��,��", 0, 3 },
    { "#N2T35", "������:̾�첽"              , "", 0, 3 },
    { "#D2T35", "������:ư��Ϣ�ѷ�+̾�첽"   , "(ư��Ϣ�ѷ�)+�äѤʤ�", 0, 3 },
    { "#D2T16", "������:����ư�첽"          , "(ư��Ϣ�ѷ�)+����", 0, 3 },
    { "#ND2KY", "������:���ƻ첽"            , "(̾,ư��)+���ޤ���,��(�Ť�)��: �����դ����ޤ���", 0, 3 },
    { "#D2KY",  "������:���ƻ첽(ư��Ϣ�ѷ�)", "(ưϢ)+���Ť餤,��(����)��", 0, 3 },
    { "#N2KYT", "������:���ƻ첽(̾�ʥ�)"    , "(̾)+��(����)��,��(�Ф�)��: ̾�⤤,���ᤤ", 0, 3 },
    { "#N2T10", "�ü����:����ư�첽(T10)"   , "(̾)+�Ť���", 0, 3 },
    { "#N2T15", "�ü����:����ư�첽(T15)"   , "(̾)+������", 0, 2 },
    { "#N2T16", "�ü����:����ư�첽(T16)"   , "(̾)+Ū,��,��,ή", 0, 3 },
    { "#N2T17", "�ü����:����ư�첽(T17)"   , "", 0, 1 },
    { "#N2T18", "�ü����:����ư�첽(T18)"   , "(̾)+�ߤ���,����", 0, 2 },
    { "#JS",    "������"                     , "", 0, 3 },
    { "#JSSUC", "������������"               , "", 0, 3 },
    { "#JNMUC", "������:��̾(̾)"            , "", 0, 1 },
    { "#JNMSUC","������:̾"                  , "", 0, 2 },
    { "#JNSSUC","������:��"                  , "", 0, 3 },
};

void   cannadic_parse_line      (unsigned char *, word **);
int    cannadic_import          (const char*, int);
int    cannadic_export          (const char*, int);
GList *cannadic_parse_line_glist(unsigned char *buf, GList *list);
char  *find_pos_from_code(const char *code, int type);
char  *find_code_from_pos(const char *code, int type);
#endif /* __CANNADIC_H__ */
