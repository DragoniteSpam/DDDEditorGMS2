/// @param UIList

var list = argument0;
var value = ui_list_selection(list);
var ts = get_active_tileset();

if (value) {
    value = value - 1;
    if (value >= 0) {
        ts.autotiles[Stuff.map.selection_fill_autotile] = value;
        var at_data = Stuff.all_graphic_autotiles[| value];
        if (is_array(at_data)) {
            Stuff.map.ui.t_p_autotile_editor.element_list.entries[| Stuff.map.selection_fill_autotile] = string(Stuff.map.selection_fill_autotile) + ". " + at_data[AvailableAutotileProperties.NAME];
        }
    } else {
        ts.autotiles[Stuff.map.selection_fill_autotile] = noone;
        Stuff.map.ui.t_p_autotile_editor.element_list.entries[| Stuff.map.selection_fill_autotile] = string(Stuff.map.selection_fill_autotile) + ". <none set>";
    }
}