/// @param UIColorPicker
function ui_checkbox_fog_color(argument0) {

    var picker = argument0;

    Stuff.terrain.terrain_fog_color = picker.value;
    setting_set("Terrain", "fog-color", Stuff.terrain.terrain_fog_color);


}
