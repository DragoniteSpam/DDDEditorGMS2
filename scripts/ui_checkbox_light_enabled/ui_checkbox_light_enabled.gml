/// @param UICheckbox
function ui_checkbox_light_enabled(argument0) {

    var checkbox = argument0;

    Stuff.terrain.terrain_light_enabled = checkbox.value;
    setting_set("Terrain", "light-enabled", Stuff.terrain.terrain_light_enabled);


}
