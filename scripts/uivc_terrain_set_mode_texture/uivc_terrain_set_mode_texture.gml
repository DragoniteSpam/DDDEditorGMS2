/// @param UIButton
function uivc_terrain_set_mode_texture(argument0) {

	var button = argument0;

	button.root.root.t_general.element_mode.value = TerrainModes.TEXTURE;
	Stuff.terrain.mode = TerrainModes.TEXTURE;


}
