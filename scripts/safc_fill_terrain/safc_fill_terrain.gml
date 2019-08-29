/// @param x
/// @param y
/// @param z
/// @param params

var params = argument3;

stack_trace();

var cell = map_get_grid_cell(argument0, argument1, argument2);
    
if (!cell[@ MapCellContents.MESHMOB]) {
    var addition = instance_create_terrain();
        
    // there's no reason this should fail but just in case
    if (addition) {
        map_add_thing(addition, argument0, argument1, argument2);
    }
}