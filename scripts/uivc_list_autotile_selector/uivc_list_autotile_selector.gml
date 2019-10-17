/// @param UIList

var value = ui_list_selection(argument0);
var ts = get_active_tileset();

if (value) {
    value = value - 1;
    if (value >= 0) {
        ts.autotiles[Camera.selection_fill_autotile] = value;
        var at_data=Stuff.all_graphic_autotiles[value];
        if (is_array(at_data)) {
            Camera.ui.t_p_autotile_editor.element_list.entries[| Camera.selection_fill_autotile] = string(Camera.selection_fill_autotile) + ". " + at_data[AvailableAutotileProperties.NAME];
        }
    } else {
        ts.autotiles[Camera.selection_fill_autotile] = noone;
        Camera.ui.t_p_autotile_editor.element_list.entries[| Camera.selection_fill_autotile] = string(Camera.selection_fill_autotile) + ". <none set>";
    }
}