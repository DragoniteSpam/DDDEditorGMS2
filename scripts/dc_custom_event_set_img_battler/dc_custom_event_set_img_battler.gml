/// @param UIButton
function dc_custom_event_set_img_battler(argument0) {

    var button = argument0;

    var list = button.root.el_list_main;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        list.node.custom_data[@ list.property_index][@ list.multi_index] = Game.graphics.battlers[selection].GUID;
    }

    dialog_destroy();


}
