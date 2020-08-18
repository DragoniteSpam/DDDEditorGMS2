/// @param UIButton
function dmu_dialog_export_heightmap(argument0) {

	var button = argument0;

	terrain_export_heightmap(button.root.filename, real(button.root.el_scale.value));
	dialog_destroy();


}
