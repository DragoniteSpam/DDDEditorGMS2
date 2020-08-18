/// @param UIThing
function dc_map_resize(argument0) {

	var dialog = argument0.root;

	data_resize_map(dialog.map, dialog.xx, dialog.yy, dialog.zz);

	dialog_destroy();


}
