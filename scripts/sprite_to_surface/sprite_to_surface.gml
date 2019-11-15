/// @param sprite
/// @param subimg
// by yellowafterlife

var sprite = argument[0];
var frame = argument[1];
var sw = sprite_get_width(sprite);
var sh = sprite_get_height(sprite);

var t = surface_create(sw, sh);
surface_set_target(t);
draw_clear_alpha(c_black, 0);
gpu_set_blendmode(bm_add);
draw_sprite(sprite, frame, 0, 0);
gpu_set_blendmode(bm_normal);
surface_reset_target();

return t;