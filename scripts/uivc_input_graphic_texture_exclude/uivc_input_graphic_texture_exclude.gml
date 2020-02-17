/// @param UICheckbox

var checkbox = argument0;
var list = input.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    list.entries[| selection].texture_exclude = checkbox.value;
}