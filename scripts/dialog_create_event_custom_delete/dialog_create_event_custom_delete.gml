/// @param DataEventNodeCustom
/// @param root

var custom = argument0;
var root = argument1;

var dw = 400;
var dh = 240;

var dg = dialog_create(dw, dh, "Delete Custom Event Node?", dialog_default, undefined, root);
dg.custom = custom;

var columns = 1;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var col1_x = dw * 0 / 3 + spacing;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var n_events = 0;
var n_nodes = 0;
#region count the number of nodes that will be deleted
for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
    var event = Stuff.all_events[| i];
    var this_event = false;
    for (var j = 0; j < ds_list_size(event.nodes); j++) {
        if (event.nodes[| j].custom_guid == custom.GUID) {
            n_nodes++;
            if (!this_event) {
                this_event = true;
                n_events++;
            }
        }
    }
}
#endregion

var el_text = create_text(col1_x, yy, "Are you sure you want to delete " + custom.name + "? This will also delete " + string(n_nodes) + " nodes in " + string(n_events) + " and may cause event logic to no longer work properly.", ew, eh, fa_left, ew, dg);
el_text.valignment = fa_top;
yy += el_text.height + spacing;

var el_yes = create_button(dw / 2 - b_width / 2 - spacing, dh - 32 - b_height / 2, "Yes", b_width, b_height, fa_center, uivc_event_custom_delete, dg, fa_center);
var el_no = create_button(dw / 2 + b_width / 2 + spacing, dh - 32 - b_height / 2, "No", b_width, b_height, fa_center, dc_default, dg, fa_center);

ds_list_add(dg.contents,
    el_text,
    el_yes,
    el_no,
);

return dg;