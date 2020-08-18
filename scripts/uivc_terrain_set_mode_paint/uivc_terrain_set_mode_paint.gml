/// @param UIButton
function uivc_terrain_set_mode_paint(argument0) {

	var button = argument0;

	button.root.root.t_general.element_mode.value = TerrainModes.COLOR;
	Stuff.terrain.mode = TerrainModes.COLOR;


}
