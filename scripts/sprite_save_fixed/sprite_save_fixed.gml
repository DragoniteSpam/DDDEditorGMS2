/// @param sprite
/// @param subimg
/// @param path
/// @param [width]
/// @param [height]
// by yellowafterlife

var sprite = argument[0];
var frame = argument[1];
var fn = argument[2];
var w = (argument_count > 3) ? argument[3] : sprite_get_width(sprite);
var h = (argument_count > 4) ? argument[4] : sprite_get_height(sprite);

var t = sprite_to_surface(sprite, frame, w, h);
surface_save(t, fn);
surface_free(t);