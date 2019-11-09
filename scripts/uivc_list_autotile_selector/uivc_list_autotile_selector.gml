/// @param UIList

var list = argument0;
var value = ui_list_selection(list);
var ts = get_active_tileset();

if (value + 1) {
    var data = Stuff.all_graphic_autotiles[| value];
    ts.autotiles[Stuff.map.selection_fill_autotile] = data.GUID;
    Stuff.map.ui.t_p_autotile_editor.element_list.entries[| Stuff.map.selection_fill_autotile] = string(Stuff.map.selection_fill_autotile) + ". " + data.name;
} else {
    ts.autotiles[Stuff.map.selection_fill_autotile] = noone;
    Stuff.map.ui.t_p_autotile_editor.element_list.entries[| Stuff.map.selection_fill_autotile] = string(Stuff.map.selection_fill_autotile) + ". <none set>";
}