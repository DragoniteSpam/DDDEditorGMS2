/// @param UITileSelector
/// @param tx
/// @param ty

var selector = argument[0];
var tx = argument[1];
var ty = argument[2];

var ts = get_active_tileset();

switch (Camera.tile_on_click) {
    case TileSelectorOnClick.SELECT:
        Camera.selection_fill_tile_x = tx;
        Camera.selection_fill_tile_y = ty;
        selector.tile_x = tx;
        selector.tile_y = ty;
        uivc_select_tile_refresh(tx, ty);
        break;
    case TileSelectorOnClick.MODIFY:
        switch (Camera.tile_data_view) {
            case TileSelectorDisplayMode.PASSAGE:
                var data = ts.passage;
                data[# tx, ty] = (data[# tx, ty] == 0) ? TILE_PASSABLE : 0;
                break;
            case TileSelectorDisplayMode.PRIORITY:
                var data = ts.priority;
                data[# tx, ty] = ++data[# tx, ty] % TILE_MAX_PRIORITY;
                uivc_select_tile_refresh(tx, ty);
                break;
            case TileSelectorDisplayMode.FLAGS:
                // modifying a bit flag just by clicking on it with no other
                // information seems kinda useless to me
                break;
            case TileSelectorDisplayMode.TAGS:
                var data = ts.tags;
                data[# tx, ty] = ++data[# tx, ty] % TileTerrainTags.FINAL;
                uivc_select_tile_refresh(tx, ty);
                break;
        }
        break;
}