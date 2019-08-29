/// @param x
/// @param y
/// @param z
/// @param params

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

stack_trace();
var cell = map_get_grid_cell(xx, yy, zz);
    
if (!cell[@ MapCellContents.MESHMOB]) {
    var addition = instance_create_mesh(noone /* here */);
        
    // there's no reason this should fail but just in case
    if (addition) {
        map_add_thing(addition, xx, yy, zz);
    }
}