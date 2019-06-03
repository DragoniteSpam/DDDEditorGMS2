/// @description void dialog_create_manager_tileset(Dialog);
/// @param Dialog

var dw=512;
var dh=400;

var dg=dialog_create(dw, dh, "Data: Tileset", dialog_default, dc_close_no_questions_asked, argument0);

var ew=(dw-64)/2;
var eh=24;

var vx1=dw/4+16;
var vy1=0;
var vx2=vx1+80;
var vy2=vy1+eh;

var b_width=128;
var b_height=32;

var yy=64;

dg.el_vrax=create_text(16, yy, "Please make a way to load the tileset here eventually", ew, eh, fa_left, dw-32, dg);

dg.el_load=create_button(dw/2-b_width-32, dh-32-b_height/2, "Load", b_width, b_height, fa_center, null, dg);

dg.el_confirm=create_button(dw/2+32, dh-32-b_height/2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, dg.el_confirm, dg.el_load, dg.el_vrax);

keyboard_string="";

return dg;
