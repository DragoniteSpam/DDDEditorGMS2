/// @param UITileSelector
/// @param tx
/// @param ty
function uivc_select_tile() {

    var selector = argument[0];
    var tx = argument[1];
    var ty = argument[2];

    Stuff.map.selection_fill_tile_x = tx;
    Stuff.map.selection_fill_tile_y = ty;
    selector.tile_x = tx;
    selector.tile_y = ty;


}
