/// @param x
/// @param y
/// @param z
/// @param params

var params = argument3;
var cell = map_get_grid_cell(argument0, argument1, argument2);

if (!cell[@ MapCellContents.TILE]) {
    var addition = instance_create_autotile(Camera.selection_fill_autotile);
    map_add_thing(addition, argument0, argument1, argument2);
}