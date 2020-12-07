/// @param UICheckbox
function uivc_check_view_lighting(argument0) {

    var checkbox = argument0;

    Settings.view.lighting = checkbox.value;
    setting_set("View", "lighting", Settings.view.lighting);


}
