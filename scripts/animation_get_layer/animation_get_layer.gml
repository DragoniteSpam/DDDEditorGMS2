/// @param DataAnimation
/// @param layer
function animation_get_layer(argument0, argument1) {

	var animation = argument0;
	var timeline_layer = argument1;

	if (timeline_layer < ds_list_size(animation.layers)) {
	    var timeline_layer = animation.layers[| timeline_layer];
	    return timeline_layer ? timeline_layer : noone;
	}

	return noone;


}
