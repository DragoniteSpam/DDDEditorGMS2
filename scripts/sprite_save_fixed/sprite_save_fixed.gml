/// @description  sprite_save_fixed(sprite, subimg, path)
/// @param sprite
/// @param  subimg
/// @param  path
// by yellowafterlife

var t=sprite_to_surface(argument0, argument1);
surface_save(t, argument2);
surface_free(t);
