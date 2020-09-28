/// @param UICheckbox
function uivc_check_selection_addition(argument0) {

    var checkbox = argument0;

    Stuff.setting_selection_addition = checkbox.value;
    setting_set("Selection", "addition", Stuff.setting_selection_addition);


}
