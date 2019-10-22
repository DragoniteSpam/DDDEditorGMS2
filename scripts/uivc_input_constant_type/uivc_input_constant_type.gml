/// @param UIRadioOption

var option = argument0;
var base_dialog = argument0.root.root;
var selection = ui_list_selection(base_dialog.el_list);

if (selection + 1) {
    var what = Stuff.all_game_constants[| selection];
    what.type = option.value;
}