/// @param UIList
function uivc_list_selection_mesh(argument0) {

    var list = argument0;

    Stuff.map.selection_fill_mesh = ui_list_selection(list);

    uivc_select_mesh_refresh(Stuff.map.selection_fill_mesh);


}
