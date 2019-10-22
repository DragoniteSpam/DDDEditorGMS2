/// @param UIList

var selection = ui_list_selection(argument0);
var base_dialog = argument0.root;

if (selection + 1) {
    ui_input_set_value(base_dialog.el_name, Stuff.all_game_constants[| selection].name);
}