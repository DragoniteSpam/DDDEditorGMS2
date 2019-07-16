/// @param UIThing

var ts = get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]) {
    var tt = ts.at_tags[Camera.selection_fill_autotile];
    tt = ++tt % TileTerrainTags.FINAL;
    ts.at_tags[Camera.selection_fill_autotile] = tt;
    uivc_select_autotile_refresh(/*Camera.selection_fill_autotile*/);
}