/// @param Dialog
/// @param default-color
/// @param [on-value-change]

var dialog = argument[0];
var color = argument[1];
var onvaluechange = (argument_count > 2) ? argument[2] : null;

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "Entities", dialog_default, dc_close_no_questions_asked, dialog);

var columns = 2;
var ew = dw / columns - 32 * columns;
var eh = 24;

var c2 = dw / columns;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

dg.el_list = create_list(16, yy, "All Entities: " + string(ds_list_size(Stuff.map.active_map.contents.all_entities)),
	"<no entities>", ew, eh, 20, onvaluechange, false, dg, Stuff.map.active_map.contents.all_entities);
dg.el_list.entries_are = ListEntries.INSTANCES_REFID;

var el_text = create_text(c2 + 16, dh / 2, "Only references to entities in the current map can be set.\n\n" +
"If you try to access an entity reference that is not in the current map during the game, the node will be skipped.\n\n" +
"If you set a reference in one map and edit the property while another is loaded, the value will be preserved but will not be named or appear in this list.\n\n" +
"It is recommended that events that reference specific entities only be called from the maps which the entities exist in.",
	ew, eh, fa_left, ew, dg);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Good", b_width, b_height, fa_center, dmu_dialog_commit_preferences, dg);

ds_list_add(dg.contents, dg.el_list, el_text,
    el_confirm);

return dg;