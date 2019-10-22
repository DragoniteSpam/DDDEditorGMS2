/// @param UIList

var list = argument0;
var base_dialog = list.root;
var selection = ui_list_selection(base_dialog.el_list);

if (selection + 1) {
    var datadata = list.entries[| ui_list_selection(base_dialog.el_type_guid)];
    Stuff.all_game_constants[| selection].type_guid = datadata.GUID;
}