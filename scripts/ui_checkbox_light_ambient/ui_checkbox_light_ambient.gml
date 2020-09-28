/// @param UIColorPicker
function ui_checkbox_light_ambient(argument0) {

    var picker = argument0;

    Stuff.terrain.terrain_light_ambient = picker.value;
    setting_set("Terrain", "light-ambient", Stuff.terrain.terrain_light_ambient);


}
