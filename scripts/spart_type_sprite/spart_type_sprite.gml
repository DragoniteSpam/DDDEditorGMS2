/// @description spart_type_sprite(partType, sprite, image_speed, random)
/// @param partType
/// @param sprite
/// @param image_speed
/// @param random
function spart_type_sprite(argument0, argument1, argument2, argument3) {
    /*
        Defines the sprite of a particle. The sprite can be animated.
        This script will create a new sprite that conforms to the format required by the particle system.
        Set image_speed to -1 to make the animation stretch througout the entire life of the particle

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partType = argument0;
    var spr = argument1;
    var sprW = sprite_get_width(spr);
    var sprH = sprite_get_height(spr);
    var num = sprite_get_number(spr);
    if partType[| sPartTyp.Spr] != -1
    {    //If a new sprite has been generated for this particle type before, delete it
        sprite_delete(partType[| sPartTyp.Spr]);
    }
    partType[| sPartTyp.SprAnimSpd] = max(argument2, 0);
    partType[| sPartTyp.SprStretchRandomNum] = (argument2 < 0) + 2 * argument3 + 4 * num;
    partType[| sPartTyp.SprOrig] = [ - sprite_get_xoffset(spr) / sprW, - sprite_get_yoffset(spr) / sprH];

    gpu_set_zwriteenable(false);
    gpu_set_blendmode_ext(bm_one, bm_zero);
    var surfaceWidth = power(2, round(log2(sprW * num)));
    var surfaceHeight = power(2, round(log2(sprH)));
    var s = surface_create(surfaceWidth, surfaceHeight);
    surface_set_target(s);
    draw_clear_alpha(c_white, 0);
    for (var i = 0; i < num; i ++)
    {
        draw_sprite_stretched(spr, i, i / num * surfaceWidth, 0, surfaceWidth / num, surfaceHeight);
    }
    surface_reset_target();
    partType[| sPartTyp.Spr] = sprite_create_from_surface(s, 0, 0, surfaceWidth, surfaceHeight, 0, 0, 0, 0);
    surface_free(s);
    gpu_set_blendmode(bm_normal);


}
