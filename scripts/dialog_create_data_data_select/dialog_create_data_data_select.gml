/// @description  void dialog_create_data_data_select(Dialog);
/// @param Dialog

var dw=320;
var dh=640;

var dg=dialog_create(dw, dh, "Select Data", dialog_default, dc_close_no_questions_asked, argument0);

var columns=1;
var ew=(dw-columns*32)/columns;
var eh=24;

var vx1=dw/(columns*2)-16;
var vy1=0;
var vx2=vx1+dw/(columns*2)-16;
var vy2=vy1+eh;

var b_width=128;
var b_height=32;

var spacing=16;
var n_slots=20;

var yy=64;

var el_list=create_list(16, yy, "Data Types:", "<no data types>", ew, eh, n_slots, null, false, dg);
el_list.render=ui_render_list_data_data_only;
el_list.entries_are=ListEntries.INSTANCES;

dg.el_list_main=el_list;

el_confirm=create_button(dw/2-b_width/2, dh-32-b_height/2, "Done", b_width, b_height, fa_center, dc_data_property_set_data, dg);
dg.el_confirm=el_confirm;

ds_list_add(dg.contents, el_list,
    el_confirm);

keyboard_string="";

return dg;
