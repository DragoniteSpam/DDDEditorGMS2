/// @param UIInput

var input = argument0;

var ts = get_active_tileset();

if (ts.autotiles[Stuff.map.selection_fill_autotile]) {
    ts.at_priority[Stuff.map.selection_fill_autotile] = real(input.value);
}