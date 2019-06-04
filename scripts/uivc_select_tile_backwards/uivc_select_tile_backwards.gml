/// @param UITileSelector
/// @param tx
/// @param ty

var catch = argument0;

var ts = get_active_tileset();

switch (Camera.tile_on_click) {
    case TileSelectorOnClick.MODIFY:
        switch (Camera.tile_data_view) {
            case TileSelectorDisplayMode.PASSAGE:
                var data = ts.passage;
                // this is just an inversion with non-binary values so it's the exact same
                // thing that you'll find in the regular uivc_select_tile
                if (data[# argument1, argument2] == 0) {
                    data[# argument1, argument2] = TILE_PASSABLE;
                } else {
                    data[# argument1, argument2] = 0;
                }
                break;
            case TileSelectorDisplayMode.PRIORITY:
                var data = ts.priority;
                data[# argument1, argument2] = (--data[# argument1, argument2] + TILE_MAX_PRIORITY) % TILE_MAX_PRIORITY;
                uivc_select_tile_refresh(argument1, argument2);
                break;
            case TileSelectorDisplayMode.FLAGS:
                // modifying a bit flag just by clicking on it with no other
                // information seems kinda useless to me
                break;
            case TileSelectorDisplayMode.TAGS:
                var data = ts.tags;
                data[# argument1, argument2] = (--data[# argument1, argument2] + TileTerrainTags.FINAL) % TileTerrainTags.FINAL;
                uivc_select_tile_refresh(argument1, argument2);
                break;
        }
        break;
}