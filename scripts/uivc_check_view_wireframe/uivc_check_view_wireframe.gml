/// @param UICheckbox
function uivc_check_view_wireframe(argument0) {

    var checkbox = argument0;

    Stuff.settings.view.wireframe = checkbox.value;
    setting_set("View", "wireframe", Stuff.settings.view.wireframe);


}
