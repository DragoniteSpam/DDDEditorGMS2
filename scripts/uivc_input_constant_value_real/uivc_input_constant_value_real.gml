/// @param UIInput

var input = argument0;
var base_dialog = input.root;
var selection = ui_list_selection(base_dialog.el_list);

if (selection + 1) {
    Stuff.all_game_constants[| selection].value_real = real(input.value);
}