/// @param UIButton

var button = argument0;
var ts = get_active_tileset();

if (ts.autotiles[Stuff.map.selection_fill_autotile]) {
    var tt = ts.at_tags[Stuff.map.selection_fill_autotile];
    tt = ++tt % TileTerrainTags.FINAL;
    ts.at_tags[Stuff.map.selection_fill_autotile] = tt;
}