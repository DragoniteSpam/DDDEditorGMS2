/// @param UICheckbox

var checkbox = argument0;

Stuff.terrain.terrain_fog_enabled = checkbox.value;
setting_set("Terrain", "fog-enabled", Stuff.terrain.terrain_fog_enabled);