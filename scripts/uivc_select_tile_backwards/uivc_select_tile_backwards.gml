/// @param UITileSelector
/// @param tx
/// @param ty

var selector = argument0;
var tx = argument1;
var ty = argument2;

var ts = get_active_tileset();

switch (Stuff.map.tile_on_click) {
    case TileSelectorOnClick.MODIFY:
        switch (Stuff.map.tile_data_view) {
            case TileSelectorDisplayMode.PASSAGE:
                var data = ts.passage;
                // this is just an inversion with non-binary values so it's the exact same
                // thing that you'll find in the regular uivc_select_tile
                if (data[# tx, ty] == 0) {
                    data[# tx, ty] = TILE_PASSABLE;
                } else {
                    data[# tx, ty] = 0;
                }
                break;
            case TileSelectorDisplayMode.PRIORITY:
                var data = ts.priority;
                data[# tx, ty] = (--data[# tx, ty] + TILE_MAX_PRIORITY) % TILE_MAX_PRIORITY;
                uivc_select_tile_refresh(tx, ty);
                break;
            case TileSelectorDisplayMode.FLAGS:
                // modifying a bit flag just by clicking on it with no other
                // information seems kinda useless to me
                break;
            case TileSelectorDisplayMode.TAGS:
                var data = ts.tags;
                data[# tx, ty] = (--data[# tx, ty] + TileTerrainTags.FINAL) % TileTerrainTags.FINAL;
                uivc_select_tile_refresh(tx, ty);
                break;
        }
        break;
}