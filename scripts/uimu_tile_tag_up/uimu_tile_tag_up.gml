/// @param UIThing

var ts = get_active_tileset();

var tt = ts.tags[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y];
tt = ++tt % TileTerrainTags.FINAL;
ts.tags[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y] = tt;
uivc_select_tile_refresh(Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y);