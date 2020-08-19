/// @param UIList
function uivc_settings_map_skybox(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        list.root.map.skybox = Stuff.all_graphic_skybox[| selection].GUID;
    } else {
        list.root.map.skybox = NULL;
    }


}
