/// @param Dialog

var dialog = argument0;

var dw = 320;
var dh = 640;

// you can assume that this is valid data because this won't be called otherwise
var index = ui_list_selection(Camera.ui.element_entity_events);
var list = Camera.selected_entities;
var entity = list[| 0];

var dg = dialog_create(dw, dh, "Trigger Type", dialog_default, dc_close_no_questions_asked, dialog);
var page = entity.object_events[| index];
dg.page = page;

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Select a trigger type", "<you should define some>", ew, eh, 20, null, false, dg, Stuff.all_event_triggers);
el_list.entries_are = ListEntries.STRINGS;
dg.el_list = el_list;

ds_map_add(el_list.selected_entries, page.trigger, true);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_dialog_entity_get_event_trigger, dg);

ds_list_add(dg.contents, el_list,
    el_confirm);

keyboard_string = "";

return dg;