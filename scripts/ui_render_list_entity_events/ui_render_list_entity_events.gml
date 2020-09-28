/// @param UIList
/// @param x
/// @param y
function ui_render_list_entity_events(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var selected_list = Stuff.map.selected_entities;

    if (ds_list_size(selected_list) == 1) {
        list.entries = selected_list[| 0].object_events;
    } // else please don't add anything to the list

    ui_render_list(list, xx, yy);


}
