/// @param EditorMode

var mode = argument0;
var base_map = Stuff.map.active_map;
var map = base_map.contents;
var deletions = ds_list_create();

for (var i = 0; i < ds_list_size(mode.changes); i++) {
    var thing = mode.changes[| i];
    switch (thing.modification) {
        case Modifications.CREATE:
            instance_deactivate_object(thing);
            script_execute(thing.on_create, thing);
            thing.modification = Modifications.NONE;
            break;
        case Modifications.UPDATE:
            batch_again(thing.batch_index);
            script_execute(thing.on_update, thing);
            thing.modification = Modifications.NONE;
            break;
        case Modifications.REMOVE:
            ds_list_add(deletions, thing);
            break;
    }
}

ds_list_clear(mode.changes);

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
if (ds_list_size(Stuff.map.active_map.contents.batch_in_the_future) > BATCH_CACHE_SIZE) {
    batch_cache();
}