event_inherited();

ds_list_destroy_instances(properties);

// if you want to save the instances for later (usually when editing the
// data types) you would signify that you still need it, because pass by
// reference
if (instances!=noone&&!is_cached) {
    for (var i=0; i<ds_list_size(instances); i++) {
        instance_activate_object(instances[| i]);
        instance_destroy(instances[| i]);
    }
    ds_list_destroy(instances);
}

