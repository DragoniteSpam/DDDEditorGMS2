/// @param UIInput

var rv = real(argument0.value);
if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
    (get_active_tileset()).tags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y] = rv;
}