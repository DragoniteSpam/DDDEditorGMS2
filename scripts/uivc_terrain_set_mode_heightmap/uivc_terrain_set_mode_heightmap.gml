/// @param UIButton
function uivc_terrain_set_mode_heightmap(argument0) {

	var button = argument0;

	button.root.root.t_general.element_mode.value = TerrainModes.Z;
	Stuff.terrain.mode = TerrainModes.Z;


}
