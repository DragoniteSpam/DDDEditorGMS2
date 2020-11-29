/// @param UICheckbox
function uivc_check_view_backface(argument0) {

    var checkbox = argument0;

    Stuff.settings.view.backface = checkbox.value;
    setting_set("View", "backface", Stuff.settings.view.backface);


}
