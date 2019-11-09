/// @param UIInput
/// @param x
/// @param y

var input = argument0;
var xx = argument1;
var yy = argument2;

var ts = get_active_tileset();

if (guid_get(ts.autotiles[Stuff.map.selection_fill_autotile])) {
    input.value = string(ts.at_tag[Stuff.map.selection_fill_autotile]);
}

ui_render_input(input, xx, yy);