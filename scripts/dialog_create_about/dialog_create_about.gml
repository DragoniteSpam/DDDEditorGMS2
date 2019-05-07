/// @description  void dialog_create_about(Dialog);
/// @param Dialog

var dw=640;
var dh=320;

var dg=dialog_create(dw, dh, "Credits", dialog_default, dc_close_no_questions_asked, argument0);

var ew=(dw-64)/2;
var eh=24;

var vx1=dw/4+16;
var vy1=0;
var vx2=vx1+80;
var vy2=vy1+eh;

var el_text=create_text(16, 64, "DDD Game Editor", ew, eh, fa_left, dw-32, dg);
var el_author=create_text(16, 96, "Author: DragoniteSpam", ew, eh, fa_left, dw-32, dg);
var el_author_1=create_text(32, 112, "    Twitter: https://twitter.com/DragoniteSpam", ew, eh, fa_left, dw-32, dg);
var el_author_2=create_text(32, 128, "    Github: https://github.com/DragoniteSpam", ew, eh, fa_left, dw-32, dg);
var el_author_3=create_text(32, 144, "    YouTube: https://www.youtube.com/c/DragoniteSpam", ew, eh, fa_left, dw-32, dg);
var el_ex=create_text(16, 176, "Some extensions were used", ew, eh, fa_left, dw-32, dg);
var el_ex_venomous=create_text(16, 192, "    3D collisions (mostly raycasting): Venomous Bullet implementation", ew, eh, fa_left, dw-32, dg);
var el_ex_regex=create_text(16, 208, "    There's a really great regex extension but it appears to have been taken down", ew, eh, fa_left, dw-32, dg);

var b_width=128;
var b_height=32;
var el_close=create_button(dw/2-b_width/2, dh-32-b_height/2, "Thanks I guess", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_text, el_author, el_author_1, el_author_2, el_author_3, el_ex, el_ex_venomous, el_ex_regex, el_close);

return dg;
