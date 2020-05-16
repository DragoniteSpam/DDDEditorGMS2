/// @param UIColorPicker

var picker = argument0;

Stuff.terrain.terrain_fog_color = picker.value;
setting_set("Terrain", "fog-color", Stuff.terrain.terrain_fog_color);