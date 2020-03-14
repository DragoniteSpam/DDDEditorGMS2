/// @param Dialog

var dialog = argument0;
var map = dialog.root.map;
var map_contents = map.contents;

var dw = 640;
var dh = 400;

var dg = dialog_create(dw, dh, "Map Default Lights", undefined, undefined, dialog);
dg.map = map;

var columns = 2;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;
var spacing = 16;

var col1_x = dw * 0 / columns + spacing;
var col2_x = dw * 1 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = 64;

var el_light_list = create_list(col1_x, yy, "Active Lights", "<no active lights>", ew, eh, 12, uivc_input_map_select_active_light, false, dg, map_contents.active_lights);
el_light_list.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. Effects with no light component (i.e. the light component has been removed) will be shown in red. Duplicate entries will be shown in orange. I recommend giving, at the very least, all of your Light entities unique names.";
el_light_list.render_colors = ui_list_color_effect_components;
el_light_list.entries_are = ListEntries.REFIDS;
dg.el_light_list = el_light_list;

yy += ui_get_list_height(el_light_list) + spacing;

yy = yy_base;

var el_available_lights = create_list(col2_x, yy, "Available Lights:", "<no available lights>", ew, eh, 12, uivc_input_map_select_light, false, dg);
el_available_lights.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. I recommend giving, at the very least, all of your Light entities unique names. Deselecting this list will clear the active light index.";
el_available_lights.entries_are = ListEntries.REFIDS;
for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
    var entity = map_contents.all_entities[| i];
    if (instanceof(entity, EntityEffect) && entity.com_light) {
        create_list_entries(el_available_lights, [entity.REFID, entity.com_light.label_colour]);
    }
}
dg.el_available_lights = el_available_lights;

yy += ui_get_list_height(el_available_lights) + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_light_list,
    el_available_lights,
    el_confirm
);

return dg;