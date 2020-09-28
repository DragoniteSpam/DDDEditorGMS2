/// @param UIButton
function dmu_dialog_commit__select_tileset(argument0) {

    var button = argument0;
    var ts = ui_list_selection(button.root.el_list);

    if (button.select_tileset && ts + 1) {
        Stuff.map.active_map.tileset = Stuff.all_graphic_tilesets[| ts].GUID;
    }

    dmu_dialog_commit(button);


}
