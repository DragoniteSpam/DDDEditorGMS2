/// @param x
/// @param y
/// @param z
/// @param params

var params = argument3;

not_yet_implemented();

var cell = map_get_grid_cell(argument0, argument1, argument2);
    
if (!cell[@ MapCellContents.MESHPAWN]) {
    var addition = instance_create_terrain();
        
    // there's no reason this should fail but just in case
    if (addition) {
        map_add_thing(addition, argument0, argument1, argument2);
    }
}