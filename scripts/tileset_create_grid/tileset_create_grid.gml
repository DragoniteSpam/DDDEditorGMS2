/// @description grid tileset_create_grid(picture, default);
/// @param picture
/// @param default

var grid=ds_grid_create(sprite_get_width(argument0) div Stuff.tile_size,
    sprite_get_height(argument0) div Stuff.tile_size);

ds_grid_clear(grid, argument1);

return grid;
