/// @param EditorMode
function editor_cleanup_map(argument0) {

	var mode = argument0;
	var base_map = Stuff.map.active_map;
	var map = base_map.contents;
	var modifications = ds_list_create();

	// let's try to keep the Modifications list separate because batching / rebatching
	// behaves differently depending on how many things are in it
	for (var i = 0; i < ds_list_size(mode.changes); i++) {
	    var thing = mode.changes[| i];
	    switch (thing.modification) {
	        case Modifications.CREATE:
	            instance_deactivate_object(thing);
	            script_execute(thing.on_create, thing);
	            thing.modification = Modifications.NONE;
	            break;
	        // we'd still like to know what the modification status on an entity is for
	        // when we re-batch everything
	        case Modifications.UPDATE:
	            ds_list_add(modifications, thing);
	            break;
	        case Modifications.REMOVE:
	            ds_list_add(modifications, thing);
	            break;
	    }
	}

	ds_list_clear(mode.changes);

	if (ds_list_size(modifications) > 0) {
	    var rebatch_all_threshold = 25;
	    var rebatch_these = ds_map_create();
	    // if there aren't enough changes to merit rebatching all
	    if (ds_list_size(modifications) < rebatch_all_threshold) {
	        for (var i = 0; i < ds_list_size(modifications); i++) {
	            var thing = modifications[| i];
	            if (thing.modification == Modifications.REMOVE) {
	                if (thing.batch_addr) {
	                    var list_instances = thing.batch_addr[? "instances"];
	                    ds_list_delete(list_instances, ds_list_find_index(list_instances, thing));
	                } else if (thing.batchable) {
	                    ds_list_delete(map.batch_in_the_future, ds_list_find_index(map.batch_in_the_future, thing));
	                } else {
	                    ds_list_delete(map.dynamic, ds_list_find_index(map.dynamic, thing));
	                }
                
	                if (thing.listed) {
	                    map_remove_thing(thing);
	                }
                
	                ds_list_delete(map.all_entities, ds_list_find_index(map.all_entities, thing));
	                rebatch_these[? thing.batch_addr] = true;
	                instance_activate_object(thing);
	                instance_destroy(thing);
	            } else if (thing.modification == Modifications.UPDATE) {
	                thing.modification = Modifications.NONE;
	                rebatch_these[? thing.batch_addr] = true;
	            }
	        }
	    } else {
	        var clone_dynamic = ds_list_clone(map.dynamic);
	        var clone_all = ds_list_clone(map.all_entities);
	        ds_list_clear(map.dynamic);
	        ds_list_clear(map.all_entities);
        
	        // after a certain point, it's easier to just re-add the entities to the
	        // appropriate lists than it is to delete a buttload of things in O(n) time
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
    
	        for (var i = 0; i < ds_list_size(modifications); i++) {
	            var thing = modifications[| i];
            
	            if (thing.modification == Modifications.REMOVE) {
	                if (thing.batch_addr) {
	                    var list_instances = thing.batch_addr[? "instances"];
	                    ds_list_delete(list_instances, ds_list_find_index(list_instances, thing));
	                } else if (thing.batchable) {
	                    ds_list_delete(map.batch_in_the_future, ds_list_find_index(map.batch_in_the_future, thing));
	                } else {
	                    ds_list_delete(map.dynamic, ds_list_find_index(map.dynamic, thing));
	                }
                
	                if (thing.listed) {
	                    map_remove_thing(thing);
	                }
                
	                ds_list_delete(map.all_entities, ds_list_find_index(map.all_entities, thing));
	                rebatch_these[? thing.batch_addr] = true;
	                instance_activate_object(thing);
	                instance_destroy(thing);
	            } else {
	                rebatch_these[? thing.batch_addr] = true;
	                thing.modification = Modifications.NONE;
	            }
	        }
        
	        ds_list_destroy(clone_dynamic);
	        ds_list_destroy(clone_all);
	    }
    
	    // once the batches that need to be recalculated have been worked out, re-batch them
	    var rebatch_indices = ds_map_to_list(rebatch_these);
	    for (var i = 0; i < ds_list_size(rebatch_indices); i++) {
	        batch_again(rebatch_indices[| i]);
	    }
	    ds_list_destroy(rebatch_indices);
	}

	ds_list_clear(modifications);

	// you may add/delete/move stuff in bulk and doing this for each
	// entity that was changed would slow the editor down quite a lot
	if (ds_list_size(map.batch_in_the_future) > BATCH_CACHE_SIZE) {
	    batch_cache();
	}


}
