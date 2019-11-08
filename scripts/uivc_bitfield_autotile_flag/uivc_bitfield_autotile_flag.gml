/// @param UIThing

var ts = get_active_tileset();

if (ts.autotiles[Stuff.map.selection_fill_autotile]) {
    // you could use ^= but
    var longexpr = ts.at_flags[Stuff.map.selection_fill_autotile];
    longexpr = longexpr ^ argument0.value;
    
    ts.at_flags[Stuff.map.selection_fill_autotile] = longexpr;
}