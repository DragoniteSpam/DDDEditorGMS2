if (Stuff.is_quitting) exit;

entity_destroy();

ds_list_destroy(switches);
ds_list_destroy(variables);

for (var i = 0; i < ds_list_size(object_events); i++) {
    instance_activate_object(object_events[| i]);
    instance_destroy(object_events[| i]);
}

for (var i = 0; i < ds_list_size(movement_routes); i++) {
    instance_activate_object(movement_routes[| i]);
    instance_destroy(movement_routes[| i]);
}

if (cobject) c_object_destroy(cobject);