/// @param Dialog

var dw = 320;
var dh = 680;

var dg = dialog_create(dw, dh, "Data Settings: Event Triggers", dialog_default, dc_close_no_questions_asked, argument0);

var ew = dw - 64;
var eh = 24;

var vx1 = ew / 3;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var spacing = 16;

var yy = 64;
var yy_start = 64;

var el_list = create_list(32, yy, "Event Triggers (max 32)", "<no swiches>", ew, eh, 16, uivc_list_selection_event_triggers, false, dg, Stuff.all_event_triggers);
el_list.numbered = true;
el_list.allow_deselect = false;
ui_list_select(el_list, 0);
dg.el_list = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_name = create_input(32, yy, "Name:", ew, eh, uivc_global_trigger_name, "", "16 characters", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
ui_input_set_value(el_name, Stuff.all_event_triggers[| 0]);
yy = yy + el_name.height + spacing;
dg.el_name = el_name;

var el_add = create_button(32, yy, "Add Trigger", ew, eh, fa_center, omu_entity_add_event_trigger, dg);
dg.el_add = el_add;

yy = yy + el_add.height + spacing;

var el_remove = create_button(32, yy, "Remove Trigger", ew, eh, fa_center, omu_entity_remove_event_trigger, dg);
el_remove.interactive = ds_list_size(Stuff.all_event_triggers) > 4;
dg.el_remove = el_remove;

yy = yy + el_remove.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list, el_name, el_add, el_remove,
    el_confirm
);

return dg;