/// @description cleanup actions

if (!dialog_exists()) {
    control_global();
}

mode.cleanup(mode);

// dialogs (or other things) to be killed

while (!ds_queue_empty(stuff_to_destroy)) {
    var thing = ds_queue_dequeue(stuff_to_destroy);
    instance_activate_object(thing);
    instance_destroy(thing);
}

// I'm not actually sure why this seems to be so astonishginly slow that you
// literally have to do it one at a time to maintian a frame rate
if (ds_queue_size(c_object_cache) > C_OBJECT_CACHE_SIZE) {
    c_world_destroy_object(ds_queue_dequeue(c_object_cache));
}

gpu_set_state(gpu_base_state);

var ts = get_active_tileset();

if (schedule_rebuild_autotile_texture) {
    wtf("this has yet to be implemented");
    schedule_rebuild_autotile_texture = false;
}

if (schedule_save) {
    serialize_save_data();
    schedule_save = false;
}

Controller.mouse_x_previous = mouse_x;
Controller.mouse_y_previous = mouse_y;

// this is very ugly but it's the easiest way to get rid of the screen flashing when
// one dialog box spawns another, due to the shades both being drawn and overlapping
drawn_dialog_shade = false;