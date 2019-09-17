/// @param UIInput

var input = argument0;

var ts = get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]) {
    ts.at_priority[Camera.selection_fill_autotile] = real(input.value);
}