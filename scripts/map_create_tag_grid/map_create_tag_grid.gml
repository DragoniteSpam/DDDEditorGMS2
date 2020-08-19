/// @param xx
/// @param yy
/// @param zz
function map_create_tag_grid(argument0, argument1, argument2) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;

    var grid = ds_grid_create(xx, yy);
    map_fill_tag_grid(grid, zz);

    return grid;


}
