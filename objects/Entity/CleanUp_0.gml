if (Stuff.is_quitting) exit;

Stuff.map.active_map.contents.population[ETypes.ENTITY]--;

if (static) {
    Stuff.map.active_map.contents.population_static--;
}

ds_list_destroy_instances(object_events);
ds_list_destroy_instances(movement_routes);
ds_list_destroy(switches);
ds_list_destroy(variables);

refid_remove(REFID);

if (cobject) c_world_destroy_object(cobject);