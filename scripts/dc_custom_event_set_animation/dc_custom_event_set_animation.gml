/// @param UIButton
function dc_custom_event_set_animation(argument0) {

    var list = argument0.root.el_list_main;
    var selection = ui_list_selection(list);

    if (selection >= 0) {
        var intermediate_list = list.node.custom_data[list.property_index];
        intermediate_list[list.multi_index] = Stuff.all_animations[| selection].GUID;
    }

    dialog_destroy();


}
