/// @param UICheckbox
function uivc_check_view_backface(argument0) {

    var checkbox = argument0;

    Settings.view.backface = checkbox.value;
    setting_set("View", "backface", Settings.view.backface);


}
