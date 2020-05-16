/// @param UICheckbox

var checkbox = argument0;

Stuff.terrain.terrain_light_enabled = checkbox.value;
setting_set("Terrain", "light-enabled", Stuff.terrain.terrain_light_enabled);