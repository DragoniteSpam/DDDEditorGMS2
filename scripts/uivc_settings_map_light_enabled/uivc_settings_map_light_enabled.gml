/// @param UICheckbox
function uivc_settings_map_light_enabled(argument0) {

    var checkbox = argument0;

    checkbox.root.map.light_enabled = checkbox.value;
    checkbox.root.el_other_light_colour.interactive = checkbox.value;
    checkbox.root.el_other_light_list.interactive = checkbox.value;


}
