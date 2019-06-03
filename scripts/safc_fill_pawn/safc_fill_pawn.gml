/// @description void safc_fill_pawn(x, y, z, params array);
/// @param x
/// @param y
/// @param z
/// @param params array

var params=argument3;

var cell=map_get_grid_cell(argument0, argument1, argument2);

if (cell[@ MapCellContents.MESHMOB]==noone) {
    var addition=instance_create_pawn();
    map_add_thing(addition, argument0, argument1, argument2);
}
