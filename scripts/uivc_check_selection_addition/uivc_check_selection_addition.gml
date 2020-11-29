/// @param UICheckbox
function uivc_check_selection_addition(argument0) {

    var checkbox = argument0;

    Stuff.settings.selection.addition = checkbox.value;
    setting_set("Selection", "addition", Stuff.settings.selection.addition);


}
