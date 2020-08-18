/// @param UIButton
function omu_tile_flags(argument0) {

	var button = argument0;
	var xx = Stuff.map.selection_fill_tile_x;
	var yy = Stuff.map.selection_fill_tile_y;

	var data = [xx, yy];
	var ts = get_active_tileset();
	dialog_create_asset_flags(noone, "(" + string(xx) + ", " + string(yy) + ")", ts.flags[# xx, yy], uivc_tile_set_flags, data);


}
