/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.el_list);

if (selection) {
    Stuff.all_bgm[| selection].name = input.value;
}