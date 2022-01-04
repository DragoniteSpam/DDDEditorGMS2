/// @description cleanup actions

if (!dialog_exists()) {
    control_global();
}

if (is_struct(mode)) {
    mode.Cleanup();
} else {
    mode.cleanup(mode);
}

// dialogs (or other things) to be killed

while (!ds_queue_empty(stuff_to_destroy)) {
    var thing = ds_queue_dequeue(stuff_to_destroy);
    instance_activate_object(thing);
    instance_destroy(thing);
}

gpu_set_state(gpu_base_state);

Controller.mouse_x_previous = mouse_x;
Controller.mouse_y_previous = mouse_y;

// this is very ugly but it's the easiest way to get rid of the screen flashing when
// one dialog box spawns another, due to the shades both being drawn and overlapping
drawn_dialog_shade = false;