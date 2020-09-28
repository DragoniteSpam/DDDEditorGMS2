/// @param UICheckbox
function uivc_check_view_wireframe(argument0) {

    var checkbox = argument0;

    Stuff.setting_view_wireframe = checkbox.value;
    setting_set("View", "wireframe", Stuff.setting_view_wireframe);


}
