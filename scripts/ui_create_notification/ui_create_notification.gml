/// @param text
/// @param lifespan
function ui_create_notification(argument0, argument1) {
	// note: this is rendered using scribble, so you can use formatting tags

	with (instance_create_depth(32, 64 + 32 * instance_number(UINotification), 0, UINotification)) {
	    scribble = scribble_draw(0, 0, argument0);
	    lifespan = argument1;
	    scribble_autotype_fade_in(scribble, 1, 1, false, current_time);
    
	    return id;
	}


}
