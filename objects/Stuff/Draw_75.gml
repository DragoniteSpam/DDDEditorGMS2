/// @description cleanup actions

if (!dialog_exists()) {
    control_global();
}

script_execute(mode.cleanup, mode);

// dialogs (or other things) to be killed

while (!ds_queue_empty(stuff_to_destroy)) {
    var thing = ds_queue_dequeue(stuff_to_destroy);
    instance_activate_object(thing);
    instance_destroy(thing);
}

gpu_set_state(gpu_base_state);

var ts = get_active_tileset();

if (schedule_rebuild_master_texture) {
    if (sprite_exists(ts.master)) {
        sprite_delete(ts.master);
    }
    ts.master = tileset_create_master(ts);
    schedule_rebuild_master_texture = false;
}

if (schedule_view_master_texture) {
    sprite_save_fixed(ts.master, 0, "master-preview.png");
    ds_stuff_open_local("master-preview.png");
    schedule_view_master_texture = false;
}

if (schedule_view_particle_texture) {
    sprite_save_fixed(Stuff.all_graphic_particle_texture, 0, "particle-preview.png");
    ds_stuff_open_local("particle-preview.png");
    schedule_view_particle_texture = false;
}

if (schedule_view_ui_texture) {
    sprite_save_fixed(Stuff.all_graphic_ui_texture, 0, "ui-preview.png");
    ds_stuff_open_local("ui-preview.png");
    schedule_view_ui_texture = false;
}

if (schedule_save) {
    serialize_save_data();
    schedule_save = false;
}

if (schedule_open) {
    var fn = get_open_filename_ddd();
    if (file_exists(fn)) {
        serialize_load(fn);
    }
    
    schedule_open = false;
}

Controller.mouse_x_previous = mouse_x;
Controller.mouse_y_previous = mouse_y;