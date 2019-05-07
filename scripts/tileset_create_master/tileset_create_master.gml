/// @description  sprite tileset_create_master(tileset);
/// @param tileset

// 3D and gpu_set_ztestenable have to be turned OFF when you do this otherwise things start acting broken

var surface=surface_create(TEXTURE_SIZE, TEXTURE_SIZE);

surface_set_target(surface);

/*
 * draw stuff
 */

// this is not stretched. if it's smaller than 2048x2048 things may not line up properly.
// if it's larger than 2048x2048 you may end up overlapping the autotiles, and also things may not
// line up properly. please try to use 2048x2048.

draw_sprite(argument0.picture, 0, 0, 0);

for (var i=0; i<AUTOTILE_MAX; i++){
    if (argument0.autotiles[i]!=noone){
        var atp=argument0.autotile_positions[i];
        var at_data=Stuff.available_autotiles[argument0.autotiles[i]];
        if (is_array(at_data)){
            draw_sprite(at_data[AvailableAutotileProperties.PICTURE], 0, atp[vec2.xx]*TEXTURE_SIZE, atp[vec2.yy]*TEXTURE_SIZE);
        }
    }
}

/*
 * administrative stuff
 */

surface_reset_target();

var back=sprite_create_from_surface(surface, 0, 0, TEXTURE_SIZE, TEXTURE_SIZE, false, false, 0, 0);
surface_free(surface);

return back;
