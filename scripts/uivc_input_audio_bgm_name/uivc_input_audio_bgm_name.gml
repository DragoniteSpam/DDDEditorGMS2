/// @param UIInput

var selection = ui_list_selection(argument0.root.el_list);

if (selection) {
    // no alphabetize
    Stuff.all_bgm[| selection].name = argument0.value;
}