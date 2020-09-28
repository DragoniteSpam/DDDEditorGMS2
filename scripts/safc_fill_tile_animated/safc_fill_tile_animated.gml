/// @param x
/// @param y
/// @param z
/// @param params[]
function safc_fill_tile_animated(argument0, argument1, argument2, argument3) {

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


}
