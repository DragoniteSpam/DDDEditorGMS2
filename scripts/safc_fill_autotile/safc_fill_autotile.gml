/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

var cell = map_get_grid_cell(xx, yy, zz);

if (!cell[@ MapCellContents.TILE]) {
    var addition = instance_create_autotile(Stuff.map.selection_fill_autotile);
    map_add_thing(addition, xx, yy, zz);
}