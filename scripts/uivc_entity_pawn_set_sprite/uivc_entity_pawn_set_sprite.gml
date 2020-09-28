/// @param UIList
function uivc_entity_pawn_set_sprite(argument0) {

    var list_element = argument0;

    // this assumes that every selected entity is already an instance of Pawn
    var list = Stuff.map.selected_entities;
    var selection = ui_list_selection(list_element);

    if (selection + 1) {
        for (var i = 0; i < ds_list_size(list); i++) {
            list[| i].overworld_sprite = Stuff.all_graphic_overworlds[| selection].GUID;
        }
    }


}
