/// @param sprite
/// @param position
/// @param offset
function render_effect_add_sprite(argument0, argument1, argument2) {

	var sprite = argument0;
	var position = argument1;
	var offset = argument2;

	var mode = Stuff.map;
	var camera = camera_get_active();

	ds_queue_enqueue(Stuff.screen_icons, [sprite, [position[vec2.xx] + offset[vec2.xx], position[vec2.yy] + offset[vec2.yy]]]);


}
