/// @param x
/// @param y
/// @param z
/// @param params[]
function safc_fill_tile(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;
    var params = argument3;
    var cell = Stuff.map.active_map.Get(xx, yy, zz);

    if (!cell[@ MapCellContents.TILE]) {
        Stuff.map.active_map.Add(new EntityTile(Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y), xx, yy, zz);
    }


}
