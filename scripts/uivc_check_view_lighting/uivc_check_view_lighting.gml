/// @param UICheckbox
function uivc_check_view_lighting(argument0) {

    var checkbox = argument0;

    Stuff.setting_view_lighting = checkbox.value;
    setting_set("View", "lighting", Stuff.setting_view_lighting);


}
