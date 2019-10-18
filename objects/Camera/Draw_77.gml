/// @description step cleanup actions

// UI stuff may block these keyboard shortcuts - do it here, after they've all
// been drawn and everything
if (!dialog_exists()) {
    control_global();
}

var base_map = Stuff.active_map;
var map = base_map.contents;

// dialogs (or other things) to be killed

while (!ds_queue_empty(stuff_to_destroy)) {
    var thing = ds_queue_dequeue(stuff_to_destroy);
    instance_activate_object(thing);
    instance_destroy(thing);
}

// batch updates

// the list may still be appended to while it's being looped over - which is a
// TERRIBLE idea, but i don't have the time to come up with something that will
// appease the stackoverflow gods so too bad for them

for (var i = 0; i < ds_list_size(changes); i++) {
    var thing = changes[| i];
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
			ds_list_add(deletions, thing);
            break;
    }
}

ds_list_clear(changes);

if (ds_list_size(deletions) > 0) {
	if (ds_list_size(deletions) < 25) {
		for (var i = 0; i < ds_list_size(deletions); i++) {
			var thing = deletions[| i];
			if (thing.xx < base_map.xx && thing.yy < base_map.yy && thing.zz < base_map.zz) {
				map_remove_thing(thing, true);
			}
		    instance_activate_object(thing);
		    instance_destroy(thing);
		}
	} else {
		var original_batch_sizes = ds_list_create();
		var clone_dynamic = ds_list_clone(map.dynamic);
		var clone_all = ds_list_clone(map.all_entities);
		ds_list_clear(map.dynamic);
		ds_list_clear(map.all_entities);
		
		for (var i = 0; i < ds_list_size(map.batch_instances); i++) {
			ds_list_add(original_batch_sizes, ds_list_size(map.batch_instances[| i]));
		}
		
		for (var i = 0; i < ds_list_size(clone_all); i++) {
			var thing = clone_all[| i];
			if (thing.modification != Modifications.REMOVE) {
				ds_list_add(map.all_entities, thing);
			}
		}
	
		for (var i = 0; i < ds_list_size(clone_dynamic); i++) {
			var thing = clone_dynamic[| i];
			if (thing.modification != Modifications.REMOVE) {
				ds_list_add(map.dynamic, thing);
			}
		}
	
		for (var i = 0; i < ds_list_size(deletions); i++) {
			var thing = deletions[| i];
			
			if (thing.batchable && thing.batch_index > -1) {
				var batch_list = map.batch_instances[| thing.batch_index];
				ds_list_delete(batch_list, ds_list_find_index(batch_list, thing));
			}
			
			if (thing.xx < base_map.xx && thing.yy < base_map.yy && thing.zz < base_map.zz) {
				map_remove_thing(thing, false);
			}
			
		    instance_activate_object(thing);
		    instance_destroy(thing);
		}
		
		for (var i = 0; i < ds_list_size(map.batch_instances); i++) {
			if (original_batch_sizes[| i] != ds_list_size(map.batch_instances[| i])) {
				batch_again(i);
			}
		}
		
		ds_list_destroy(clone_dynamic);
		ds_list_destroy(clone_all);
		ds_list_destroy(original_batch_sizes);
	}
}

ds_list_clear(deletions);

// you may add/delete/move stuff in bulk and doing this for each
// entity that was changed would slow the editor down quite a lot
if (ds_list_size(Stuff.active_map.contents.batch_in_the_future) > BATCH_CACHE_SIZE) {
    batch_cache();
}

// this is important, but gets turned back on when the 3D stuff gets dealt
// with in the next frame
gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);

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

// this needs to be updated at the very end, and the controller is invisible so its
// end draw events won't actually fire

Controller.mouse_x_previous = mouse_x;
Controller.mouse_y_previous = mouse_y;