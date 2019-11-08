/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

var cell = map_get_grid_cell(xx, yy, zz);

if (!cell[@ MapCellContents.MESHPAWN]) {
    var addition = instance_create_pawn();
    map_add_thing(addition, xx, yy, zz);
}