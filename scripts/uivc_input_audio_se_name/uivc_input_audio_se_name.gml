/// @param UIInput

var selection = ui_list_selection(argument0.root.el_list);

if (selection != noone) {
    // no alphabetize
    Stuff.all_se[| selection].name = argument0.value;
}