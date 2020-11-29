/// @param UICheckbox
function uivc_check_view_selection_mask(argument0) {

    var checkbox = argument0;

    Stuff.settings.selection.mask = checkbox.value;
    setting_set("Selection", "mask", Stuff.settings.selection.mask);


}
