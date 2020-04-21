/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

show_error("WIP", false);
return noone;

var cell = map_get_grid_cell(xx, yy, zz);

if (!cell[@ MapCellContents.TILE]) {
    var addition = instance_create_tile_animated();
    map_add_thing(addition, xx, yy, zz);
}