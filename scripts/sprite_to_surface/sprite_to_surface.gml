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
// I don't know why this is suddenly upside-down; it started rendering weirdly
// around when I refactored the editor modes and I haven't been able to figure
// out why. It probably has something to do with a camera setting somewhere (it
// seems to be originating in the 3D views). I need to move on to other stuff so
// instead of fixing it, sprites are just going to be written out upside-down instead.
draw_sprite_flipped(sprite, frame, 0, 0);
gpu_set_blendmode(bm_normal);
surface_reset_target();

return t;