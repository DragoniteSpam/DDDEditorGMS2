/// @param x
/// @param y
/// @param z
/// @param params

var params = argument3;
var cell = map_get_grid_cell(argument0, argument1, argument2);

if (cell[@ MapCellContents.TILE] == noone) {
    var addition = instance_create_tile(Camera.selection_fill_tile_x, Camera.selection_fill_tile_y);
    map_add_thing(addition, argument0, argument1, argument2);
}