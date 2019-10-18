/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.el_list);

if (selection + 1) {
    Stuff.all_graphic_battlers[| selection].hframes = real(input.value);
}