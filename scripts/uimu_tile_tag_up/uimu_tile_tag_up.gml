/// @description uimu_tile_tag_up(UIThing);
/// @param UIThing

var ts=get_active_tileset();

var tt=ts.tags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y];
tt=++tt%TileTerrainTags.FINAL;
ts.tags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]=tt;
uivc_select_tile_refresh(Camera.selection_fill_tile_x, Camera.selection_fill_tile_y);
