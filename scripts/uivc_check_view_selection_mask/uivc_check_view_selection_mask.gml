/// @param UICheckbox
function uivc_check_view_selection_mask(argument0) {

    var checkbox = argument0;

    Stuff.setting_selection_mask = checkbox.value;
    setting_set("Selection", "mask", Stuff.setting_selection_mask);


}
