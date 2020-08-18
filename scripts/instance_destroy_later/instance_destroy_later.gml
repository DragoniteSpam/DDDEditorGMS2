/// @param what
function instance_destroy_later(argument0) {
	// if you can't savely destroy anything until the end of the step

	ds_queue_enqueue(Stuff.stuff_to_destroy, argument0);


}
