/// @param picture
/// @param default
function tileset_create_grid(argument0, argument1) {

	var picture = argument0;
	var def_value = argument1;

	var grid = ds_grid_create(sprite_get_width(picture) div Stuff.tile_size, sprite_get_height(picture) div Stuff.tile_size);

	ds_grid_clear(grid, def_value);

	return grid;


}
