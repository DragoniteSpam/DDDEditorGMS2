/// @param UIColorPicker

var picker = argument0;

Stuff.terrain.terrain_light_ambient = picker.value;
setting_set("Terrain", "light-ambient", Stuff.terrain.terrain_light_ambient);