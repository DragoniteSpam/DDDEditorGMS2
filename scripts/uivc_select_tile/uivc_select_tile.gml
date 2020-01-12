/// @param UITileSelector
/// @param tx
/// @param ty

var selector = argument[0];
var tx = argument[1];
var ty = argument[2];

var ts = get_active_tileset();

switch (Stuff.map.tile_on_click) {
    case TileSelectorOnClick.SELECT:
        Stuff.map.selection_fill_tile_x = tx;
        Stuff.map.selection_fill_tile_y = ty;
        selector.tile_x = tx;
        selector.tile_y = ty;
        break;
    case TileSelectorOnClick.MODIFY:
        break;
}