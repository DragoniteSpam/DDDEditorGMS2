/// @param x
/// @param y
/// @param z
/// @param params

var params = argument3;

var cell = map_get_grid_cell(argument0, argument1, argument2);

if (!cell[@ MapCellContents.MESHPAWN]) {
    var addition = instance_create_pawn();
    map_add_thing(addition, argument0, argument1, argument2);
}