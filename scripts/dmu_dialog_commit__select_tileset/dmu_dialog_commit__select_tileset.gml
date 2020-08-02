/// @param UIButton

var button = argument0;
var ts = ui_list_selection(button.root.el_list);

if (button.select_tileset && ts + 1) {
    Stuff.map.active_map.tileset = ts;
}

dmu_dialog_commit(button);