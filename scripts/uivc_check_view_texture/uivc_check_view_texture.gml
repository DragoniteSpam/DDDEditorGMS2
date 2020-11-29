/// @param UICheckbox
function uivc_check_view_texture(argument0) {

    var checkbox = argument0;

    Stuff.settings.view.texture = checkbox.value;
    setting_set("View", "texture", Stuff.settings.view.texture);


}
