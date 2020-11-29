/// @param UICheckbox
function uivc_check_view_lighting(argument0) {

    var checkbox = argument0;

    Stuff.settings.view.lighting = checkbox.value;
    setting_set("View", "lighting", Stuff.settings.view.lighting);


}
