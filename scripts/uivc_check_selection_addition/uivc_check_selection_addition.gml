/// @param UICheckbox
function uivc_check_selection_addition(argument0) {

    var checkbox = argument0;

    Settings.selection.addition = checkbox.value;
    setting_set("Selection", "addition", Settings.selection.addition);


}
