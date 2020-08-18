/// @param UIThing
function uivc_animation_set_name(argument0) {

	var thing = argument0;

	if (thing.root.root.root.active_animation) {
	    thing.root.root.root.active_animation.name = thing.value;
	}


}
