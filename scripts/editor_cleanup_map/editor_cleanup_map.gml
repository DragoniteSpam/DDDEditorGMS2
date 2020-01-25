/// @param EditorMode

var mode = argument0;
var base_map = Stuff.map.active_map;
var map = base_map.contents;
var modifications = ds_list_create();

for (var i = 0; i < ds_list_size(mode.changes); i++) {
    var thing = mode.changes[| i];
    switch (thing.modification) {
        case Modifications.CREATE:
            instance_deactivate_object(thing);
            script_execute(thing.on_create, thing);
            thing.modification = Modifications.NONE;
            break;
        // we'd still like to know what the modification status on an entity is for when we re-batch
        // everything
        case Modifications.UPDATE:
            //batch_again(thing.batch_index);
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
    var rebatch_status = ds_list_create();
    
    for (var i = 0; i < ds_list_size(map.batch_instances); i++) {
        ds_list_add(rebatch_status, false);
    }
    
    if (ds_list_size(modifications) < rebatch_all_threshold) {
        if (thing.modification == Modifications.REMOVE) {
            for (var i = 0; i < ds_list_size(modifications); i++) {
                var thing = modifications[| i];
                if (thing.xx < base_map.xx && thing.yy < base_map.yy && thing.zz < base_map.zz) {
                    map_remove_thing(thing, true);
                }
                instance_activate_object(thing);
                instance_destroy(thing);
            }
        } else if (thing.modification == Modifications.UPDATE) {
            thing.modification = Modifications.NONE;
            rebatch_status[| thing.batch_index] = true;
        }
    } else {
        var clone_dynamic = ds_list_clone(map.dynamic);
        var clone_all = ds_list_clone(map.all_entities);
        ds_list_clear(map.dynamic);
        ds_list_clear(map.all_entities);
        
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
                if (thing.batchable && thing.batch_index > -1) {
                    var batch_list = map.batch_instances[| thing.batch_index];
                    rebatch_status[| thing.batch_index] = true;
                    ds_list_delete(batch_list, ds_list_find_index(batch_list, thing));
                }
                
                if (thing.xx < base_map.xx && thing.yy < base_map.yy && thing.zz < base_map.zz) {
                    map_remove_thing(thing, false);
                }
                
                instance_activate_object(thing);
                instance_destroy(thing);
            } else {
                rebatch_status[| thing.batch_index] = true;
                thing.modification = Modifications.NONE;
            }
        }
        
        ds_list_destroy(clone_dynamic);
        ds_list_destroy(clone_all);
    }
    
    for (var i = 0; i < ds_list_size(map.batch_instances); i++) {
        if (rebatch_status[| i]) {
            batch_again(i);
        }
    }
    
    ds_list_destroy(rebatch_status);
}

ds_list_clear(modifications);

// you may add/delete/move stuff in bulk and doing this for each
// entity that was changed would slow the editor down quite a lot
if (ds_list_size(Stuff.map.active_map.contents.batch_in_the_future) > BATCH_CACHE_SIZE) {
    batch_cache();
}