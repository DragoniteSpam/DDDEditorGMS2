/// @param sprite
/// @param subimg
/// @param [width]
/// @param [height]
// by yellowafterlife

var sprite = argument[0];
var frame = argument[1];
var qw = (argument_count > 2) ? argument[2] : sprite_get_width(sprite);
var qh = (argument_count > 3) ? argument[3] : sprite_get_height(sprite);
var qx = sprite_get_xoffset(sprite);
var qy = sprite_get_yoffset(sprite);

var t = surface_create(qw, qh);
surface_set_target(t);
draw_clear_alpha(c_black, 0);
gpu_set_blendmode(bm_add);
draw_sprite(sprite, frame, qx, qy);
gpu_set_blendmode(bm_normal);
surface_reset_target();

return t;