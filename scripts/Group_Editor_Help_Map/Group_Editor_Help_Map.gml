function editor_map_mark_changed(entity) {
    if (!MAP_BATCH_MESH_ENABLED) return;
    if (entity.modification == Modifications.NONE) {
        entity.modification = Modifications.UPDATE;
        ds_list_add(Stuff.map.changes, entity);
    }
}

function editor_cleanup_map() {
    var base_map = Stuff.map.active_map;
    var map = base_map.contents;
    var modifications = [];
    
    // let's try to keep the Modifications list separate because batching / rebatching
    // behaves differently depending on how many things are in it
    for (var i = 0; i < ds_list_size(self.changes); i++) {
        var thing = self.changes[| i];
        switch (thing.modification) {
            // we'd still like to know what the modification status on an entity is for
            // when we re-batch everything
            case Modifications.UPDATE:
                array_push(modifications, thing);
                break;
            case Modifications.REMOVE:
                array_push(modifications, thing);
                break;
        }
    }
    
    ds_list_clear(self.changes);
    
    if (!array_empty(modifications)) {
        var rebatch_all_threshold = 25;
        var rebatch_these = { };
        // if there aren't enough changes to merit rebatching all
        if (array_length(modifications) < rebatch_all_threshold) {
            for (var i = 0; i < array_length(modifications); i++) {
                var thing = modifications[i];
                if (thing.modification == Modifications.REMOVE) {
                    if (thing.batch_addr) {
                        var list_instances = thing.batch_addr.instances;
                        ds_list_delete(list_instances, ds_list_find_index(list_instances, thing));
                        rebatch_these[$ thing.batch_addr] = true;
                    } else if (thing.batchable) {
                        ds_list_delete(map.batch_in_the_future, ds_list_find_index(map.batch_in_the_future, thing));
                    } else {
                        ds_list_delete(map.dynamic, ds_list_find_index(map.dynamic, thing));
                    }
                    
                    base_map.Remove(thing);
                    ds_list_delete(map.all_entities, ds_list_find_index(map.all_entities, thing));
                    
                    thing.Destroy();
                } else if (thing.modification == Modifications.UPDATE) {
                    if (thing.batch_addr) {
                        rebatch_these[$ thing.batch_addr] = true;
                    }
                    thing.modification = Modifications.NONE;
                }
            }
        } else {
            var clone_dynamic = ds_list_to_array(map.dynamic);
            var clone_all = ds_list_to_array(map.all_entities);
            ds_list_clear(map.dynamic);
            ds_list_clear(map.all_entities);
            
            // after a certain point, it's easier to just re-add the entities to the
            // appropriate lists than it is to delete a buttload of things in O(n) time
            for (var i = 0; i < array_length(clone_all); i++) {
                var thing = clone_all[i];
                if (thing.modification != Modifications.REMOVE) {
                    ds_list_add(map.all_entities, thing);
                }
            }
            
            for (var i = 0; i < array_length(clone_dynamic); i++) {
                var thing = clone_dynamic[i];
                if (thing.modification != Modifications.REMOVE) {
                    ds_list_add(map.dynamic, thing);
                }
            }
        
            for (var i = 0; i < array_length(modifications); i++) {
                var thing = modifications[i];
                
                if (thing.modification == Modifications.REMOVE) {
                    // Update the current batch
                    if (thing.batch_addr) {
                        var list_instances = thing.batch_addr.instances;
                        ds_list_delete(list_instances, ds_list_find_index(list_instances, thing));
                        rebatch_these[$ thing.batch_addr] = true;
                    // Remove from the future batch list
                    } else if (thing.batchable) {
                        ds_list_delete(map.batch_in_the_future, ds_list_find_index(map.batch_in_the_future, thing));
                    // Remove from the dynamic list
                    } else {
                        ds_list_delete(map.dynamic, ds_list_find_index(map.dynamic, thing));
                    }
                    
                    base_map.Remove(thing);
                    ds_list_delete(map.all_entities, ds_list_find_index(map.all_entities, thing));
                    thing.Destroy();
                } else {
                    if (thing.batch_addr) {
                        rebatch_these[$ thing.batch_addr] = true;
                    }
                    thing.modification = Modifications.NONE;
                }
            }
        }
        
        // once the batches that need to be recalculated have been worked out, re-batch them
        var rebatch_indices = variable_struct_get_names(rebatch_these);
        for (var i = 0; i < array_length(map.batches); i++) {
            if (rebatch_these[$ map.batches[i]]) batch_again(map.batches[i]);
        }
    }
    
    // you may add/delete/move stuff in bulk and doing this for each
    // entity that was changed would slow the editor down quite a lot
    if (ds_list_size(map.batch_in_the_future) > BATCH_CACHE_SIZE) {
        batch_cache();
    }
}