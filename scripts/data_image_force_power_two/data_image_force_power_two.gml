/// @param DataImage

var data = argument0;
var ww = sprite_get_width(data.picture);
var hh = sprite_get_height(data.picture);

if (log2(hh) == floor(log2(hh)) && log2(ww) == floor(log2(ww))) {
    return 0;
}

var surface = surface_create(power(2, ceil(log2(ww))), power(2, ceil(log2(hh))));
surface_set_target(surface);
draw_clear_alpha(c_black, 0);
draw_sprite(data.picture, 0, 0, 0);
surface_reset_target();
sprite_delete(data.picture);
data.picture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_height(surface), false, false, 0, 0);
surface_free(surface);

data.width = sprite_get_width(data.picture);
data.height = sprite_get_height(data.picture);