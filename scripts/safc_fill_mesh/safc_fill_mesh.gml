/// @param x
/// @param y
/// @param z
/// @param params[]
function safc_fill_mesh(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;
    var params = argument3;

    var cell = map_get_grid_cell(xx, yy, zz);
    
    if (!cell[@ MapCellContents.MESH]) {
        var addition = instance_create_mesh(Stuff.all_meshes[| Stuff.map.selection_fill_mesh]);
    
        if (addition) {
            map_add_thing(addition, xx, yy, zz);
        }
    }


}
