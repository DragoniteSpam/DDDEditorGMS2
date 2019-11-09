/// @param tileset

var tileset = argument0;

// 3D and gpu_set_ztestenable have to be turned OFF when you do this otherwise things start acting broken

var surface = surface_create(TEXTURE_SIZE, TEXTURE_SIZE);

surface_set_target(surface);
draw_clear_alpha(c_white, 0);

/*
 * draw stuff
 */

// this is not stretched. if it's smaller than 2048x2048 things may not line up properly.
// if it's larger than 2048x2048 you may end up overlapping the autotiles, and also things may not
// line up properly. please try to use 2048x2048.

draw_sprite(tileset.picture, 0, 0, 0);
var count = ds_list_size(Stuff.all_graphic_autotiles);

for (var i = 0; i < AUTOTILE_MAX; i++) {
    if (tileset.autotiles[i] <= count) {
        var xx = i div (AUTOTILE_MAX / 2);
        var yy = (i mod 2) / 4;
        draw_sprite(Stuff.all_graphic_autotiles[| tileset.autotiles[i]].picture, 0, xx * TEXTURE_SIZE, yy * TEXTURE_SIZE);
    }
}

/*
 * administrative stuff
 */

surface_reset_target();

var sprite = sprite_create_from_surface(surface, 0, 0, TEXTURE_SIZE, TEXTURE_SIZE, false, false, 0, 0);
surface_free(surface);

return sprite;