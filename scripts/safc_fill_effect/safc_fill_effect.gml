/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

var cell = map_get_grid_cell(xx, yy, zz);

if (!cell[@ MapCellContents.EFFECT]) {
    var addition = instance_create_depth(0, 0, 0, EntityEffect);
    map_add_thing(addition, xx, yy, zz);
}