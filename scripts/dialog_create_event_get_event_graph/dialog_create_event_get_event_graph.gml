/// @param Dialog
/// @param node
/// @param index

var dialog = argument0;
var node = argument1;
var index = argument2;

var dw = 320;
var dh = 640;

var dg = dialog_create(dw, dh, "Select Event", dialog_default, dc_close_no_questions_asked, dialog);
dg.node = node;
dg.index = index;

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

var custom = guid_get(node.custom_guid);
var outbound_label = (custom ? custom.outbound[| index] : "#" + string(index));
var label = node.name + " / " + (string_length(outbound_label) > 0 ? outbound_label : "default");

var el_title_text = create_text(16, yy, label, ew, eh, fa_left, ew, dg);

yy = yy + el_title_text.height + spacing;

var el_list = create_list(16, yy, "Select an event", "<how do you even have no events?>", ew, eh, 18, null, false, dg, Stuff.all_events);
el_list.entries_are = ListEntries.INSTANCES;
dg.el_list = el_list;

for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
    if (Stuff.all_events[| i] == Stuff.event.active) {
        ui_list_select(el_list, i);
        break;
    }
}

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dialog_create_event_get_event_node, dg);

ds_list_add(dg.contents,
    el_title_text,
    el_list,
    el_confirm
);

return dg;