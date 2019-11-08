/// @param UIThing

var ts = get_active_tileset();

if (ts.autotiles[Stuff.map.selection_fill_autotile]) {
    // value ^ 0 won't do what i want it to do
    ts.at_passage[Stuff.map.selection_fill_autotile] = 0;
}