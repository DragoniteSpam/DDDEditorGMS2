/// @description step cleanup actions

// UI stuff may block these keyboard shortcuts - do it here, after they've all
// been drawn and everything
if (!dialog_exists()) {
    control_global();
}

// dialogs (or other things) to be killed

while (!ds_queue_empty(stuff_to_destroy)) {
    var thing = ds_queue_dequeue(stuff_to_destroy);
    instance_activate_object(thing);
    instance_destroy(thing);
}

// batch updates

var future = ActiveMap.batch_in_the_future;

var cindex = 0;

// the list may still be appended to while it's being looped over - which is a
// TERRIBLE idea, but i don't have the time to come up with something that will
// appease the stackoverflow gods so too bad for them

while (cindex < ds_list_size(changes)) {
    var thing = changes[| cindex++];
    switch (thing.modification) {
        case Modifications.CREATE:
            instance_deactivate_object(thing);
            script_execute(thing.on_create, thing);
            thing.modification = Modifications.NONE;
            break;
        case Modifications.UPDATE:
            if (thing.batch_index == -1) {
                debug("how did you even get here?");
            } else {
                batch_again(thing.batch_index);
            }
            script_execute(thing.on_update, thing);
            thing.modification = Modifications.NONE;
            break;
        case Modifications.REMOVE:
            map_remove_thing(thing);
            
            instance_activate_object(thing);
            instance_destroy(thing);
            
            // no point changing thing.modification now
            break;
    }
    // it turns out you can't put any mode code involving thing here because if it
    // was deleted it'll break things
}

ds_list_clear(changes);

// you may add/delete/move stuff in bulk and doing this for each
// entity that was changed would slow the editor down quite a lot
if (ds_list_size(ActiveMap.batch_in_the_future) > BATCH_CACHE_SIZE) {
    batch_cache();
}

// this is important, but gets turned back on when the 3D stuff gets dealt
// with in the next frame
d3d_end();
gpu_set_ztestenable(false);

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

if (schedule_save_data) {
    serialize_save_data();
    schedule_save_data = false;
}

if (schedule_save_map) {
    serialize_save_map();
    schedule_save_map = false;
}

if (schedule_save_assets) {
    serialize_save_assets();
    schedule_save_assets = false;
}

if (schedule_open) {
    var fn = get_open_filename("DDD game files (" + EXPORT_EXTENSION_DATA + ", " + EXPORT_EXTENSION_MAP + ")|*" + EXPORT_EXTENSION_DATA+";*" + EXPORT_EXTENSION_MAP, "");
    
    if (file_exists(fn)) {
        serialize_load(fn);
    }
    
    schedule_open = false;
}

/*for (var i=0; i<ds_list_size(schedule_list_kill); i++) {
    var data = schedule_list_kill[| i];
    var victim = data[@ 0];
    var current = data[@ 1];
    for (var j = current; j<min(current + 100, ds_list_size(victim)); j++) {
        instance_activate_object(victim[| j]);
        instance_destroy(victim[| j]);
    }
    if (j == ds_list_size(victim)) {
        ds_list_destroy(victim);
        ds_list_delete(schedule_list_kill, i--);
    }
}*/

// controller is invisible so

Controller.mouse_x_previous = mouse_x;
Controller.mouse_y_previous = mouse_y;