/*

  Copyright (c) 2004-2005 uim Project http://uim.freedesktop.org/

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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif
#include <gtk/gtk.h>

#include <locale.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

#include <uim/uim.h>
#include <uim/uim-helper.h>
#include <uim/gettext.h>

#define BUTTON_H_ALIGN 5

gchar *alphabet_capital[] = {
  "A", "B", "C", "D", "E",
  "F", "G", "H", "I", "J",
  "K", "L", "M", "N", "O",
  "P", "Q", "R", "S", "T",
  "U", "V", "W", "X", "Y",
  "Z", NULL
};

gchar *alphabet_small[] = {
  "a", "b", "c", "d", "e",
  "f", "g", "h", "i", "j",
  "k", "l", "m", "n", "o",
  "p", "q", "r", "s", "t",
  "u", "v", "w", "x", "y",
  "z", NULL
};

gchar *numbers[] = {
  "0", "1", "2", "3", "4",
  "5", "6", "7", "8", "9",
  NULL
};

gchar *symbols[] = {
  "@",  ":", "_", "~", "/",
  "\\", "(", ")", "'", "\"",
  "-",  ",", ".", "!", "?",
  NULL
};

/* written in unicode */
gchar *katakana[] = {
  "ア", "イ", "ウ", "エ", "オ",
  "カ", "キ", "ク", "ケ", "コ",
  "サ", "シ", "ス", "セ", "ソ",
  "タ", "チ", "ツ", "テ", "ト",
  "ナ", "ニ", "ヌ", "ネ", "ノ",
  "ハ", "ヒ", "フ", "ヘ", "ホ",
  "マ", "ミ", "ム", "メ", "モ",
  "ヤ", "", "ユ", "", "ヨ",
  "ラ", "リ", "ル", "レ", "ロ",
  "ワ", "ヰ", "", "ヱ", "ヲ",
  "ン", "", "ヴ", "", "",
  "ガ", "ギ", "グ", "ゲ", "ゴ",
  "ザ", "ジ", "ズ", "ゼ", "ゾ",
  "ダ", "ヂ", "ヅ", "デ", "ド",
  "バ", "ビ", "ブ", "ベ", "ボ",
  "パ", "ピ", "プ", "ペ", "ポ",
  "ァ", "ィ", "ゥ", "ェ", "ォ",
  "ャ", "", "ュ", "", "ョ",
  "ッ", "（", "）", "「", "」",
  "ー", "、", "。", "！", "？",
  NULL
};

gchar *hiragana[] = {
  "あ", "い", "う", "え", "お",
  "か", "き", "く", "け", "こ",
  "さ", "し", "す", "せ", "そ",
  "た", "ち", "つ", "て", "と",
  "な", "に", "ぬ", "ね", "の",
  "は", "ひ", "ふ", "へ", "ほ",
  "ま", "み", "む", "め", "も",
  "や", "", "ゆ", "", "よ",
  "ら", "り", "る", "れ", "ろ",
  "わ", "ゐ", "", "ゑ", "を",
  "ん", "", "う゛", "", "",
  "が", "ぎ", "ぐ", "げ", "ご",
  "ざ", "じ", "ず", "ぜ", "ぞ",
  "だ", "ぢ", "づ", "で", "ど",
  "ば", "び", "ぶ", "べ", "ぼ",
  "ぱ", "ぴ", "ぷ", "ぺ", "ぽ",
  "ぁ", "ぃ", "ぅ", "ぇ", "ぉ",
  "ゃ", "", "ゅ", "", "ょ",
  "っ", "（", "）", "「", "」",
  "ー", "、", "。", "！", "？",
  NULL
};

static int uim_fd = -1;

static GtkWidget *buttontable_create(char **table, int tablelen);
static GtkWidget *create_hiragana_tab(void);
static GtkWidget *create_katakana_tab(void);
static GtkWidget *create_eisu_tab(void);

static void       check_helper_connection(void);
static void       helper_disconnect_cb(void);
static void       input_pad_create(void);
static GtkWidget *input_table_create(gchar *localename);
static void       padbutton_clicked(GtkButton *button, gpointer user_data);


static void
check_helper_connection(void)
{
  if (uim_fd < 0) {
    uim_fd = uim_helper_init_client_fd(helper_disconnect_cb);
    if (uim_fd < 0)
      return;
  }
}

static void
helper_disconnect_cb(void)
{
  uim_fd = -1;
}

static void
padbutton_clicked(GtkButton *button, gpointer user_data)
{
  GString *tmp;
  const gchar *str = gtk_button_get_label(GTK_BUTTON(button));
  if (!str)
    return;

  tmp = g_string_new("commit_string\n");
  g_string_append(tmp, str);
  g_string_append(tmp, "\n");

  uim_helper_send_message(uim_fd, tmp->str);

  g_string_free(tmp, TRUE);
}

static GtkWidget *
buttontable_create(gchar **table, int len)
{
  GtkWidget *_table;
  GtkWidget *button;
  gint i,j;
  gint rows = ((len-2)/ BUTTON_H_ALIGN)+1;

  _table = gtk_table_new(rows,
			 BUTTON_H_ALIGN,
			 TRUE);
  gtk_table_set_row_spacings(GTK_TABLE(_table), 3);
  gtk_table_set_col_spacings(GTK_TABLE(_table), 3);

  for(i=0; i < rows; i++) {
    for(j=0; j < BUTTON_H_ALIGN; j++) {
      if(table[i*BUTTON_H_ALIGN + j] == NULL)
	goto out;
      if(strcmp(table[i*BUTTON_H_ALIGN + j], "") == 0)
	continue;

      button = gtk_button_new_with_label(table[i*BUTTON_H_ALIGN + j]);
      g_signal_connect(button, "clicked",
		       G_CALLBACK(padbutton_clicked), "button");
      
      gtk_table_attach_defaults(GTK_TABLE(_table),
				button,
				j, j + 1,
				i, i + 1);
    }
  }
 out:
  return _table;
}

static GtkWidget *
create_hiragana_tab(void)
{
  GtkWidget *vbox;

  vbox = gtk_vbox_new(FALSE, 10);

  gtk_box_pack_start(GTK_BOX(vbox),
		     buttontable_create(hiragana, sizeof(hiragana)/sizeof(gchar*)),
		     FALSE, FALSE, 0);

  return vbox;
}

static GtkWidget *
create_katakana_tab(void)
{
  GtkWidget *vbox;

  vbox = gtk_vbox_new(FALSE, 10);

  gtk_box_pack_start(GTK_BOX(vbox),
		     buttontable_create(katakana, sizeof(katakana)/sizeof(gchar*)),
		     FALSE, FALSE, 0);

  return vbox;
}

static GtkWidget *
create_eisu_tab(void)
{
  GtkWidget *vbox;

  vbox = gtk_vbox_new(FALSE, 10);

  gtk_box_pack_start(GTK_BOX(vbox),
		     buttontable_create(alphabet_capital, sizeof(alphabet_capital)/sizeof(gchar*)),
		     FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(vbox),
		     buttontable_create(alphabet_small, sizeof(alphabet_small)/sizeof(gchar*)),
		     FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(vbox),
		     buttontable_create(numbers, sizeof(numbers)/sizeof(gchar*)),
		     FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(vbox),
		     buttontable_create(symbols, sizeof(symbols)/sizeof(gchar*)),
		     FALSE, FALSE, 0);

  return vbox;

}

static void
input_pad_create(void)
{
  GtkWidget *input_pad_win;
  GtkWidget *input_table;

  input_pad_win = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(input_pad_win),
		       _("ja-pad"));
  g_signal_connect(G_OBJECT(input_pad_win), "destroy",
		   G_CALLBACK(gtk_main_quit), NULL);


  input_table = input_table_create(NULL);

  gtk_container_add(GTK_CONTAINER(input_pad_win), input_table);

  gtk_widget_show_all(input_pad_win);

}

static GtkWidget *
input_table_create(gchar *localename)
{
  GtkWidget *notebook;
  
  notebook = gtk_notebook_new();
  gtk_notebook_append_page(GTK_NOTEBOOK(notebook),
			   create_hiragana_tab(),
			   gtk_label_new(_("hiragana")));
  gtk_notebook_append_page(GTK_NOTEBOOK(notebook),
			   create_katakana_tab(),
			   gtk_label_new(_("katakana")));
  gtk_notebook_append_page(GTK_NOTEBOOK(notebook),
			   create_eisu_tab(),
			   gtk_label_new(_("eisu")));
  return notebook;
}

int
main(int argc, char *argv[])
{
  setlocale(LC_ALL, "");
  gtk_set_locale();
  bindtextdomain( PACKAGE, LOCALEDIR );
  textdomain( PACKAGE );
  bind_textdomain_codeset( PACKAGE, "UTF-8");

  gtk_init(&argc, &argv);

  /* create GUI parts */
  input_pad_create();

  /* confirm helper connection */
  check_helper_connection();

  gtk_main ();
  return 0;
}
