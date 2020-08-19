/// @param x
/// @param y
/// @param z
/// @param params[]
function safc_fill_terrain(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;
    var params = argument3;

    var cell = map_get_grid_cell(xx, yy, zz);
    
    if (!cell[@ MapCellContents.MESH]) {
        var addition = instance_create_terrain();
        
        // there's no reason this should fail but just in case
        if (addition) {
            map_add_thing(addition, xx, yy, zz);
        }
    }


}
