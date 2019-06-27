/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var selection = ui_list_selection(argument0.root.el_list);

    if (selection != noone) {
        // no alphabetize
        Stuff.all_bgm[| selection].name = argument0.value;
    }
}