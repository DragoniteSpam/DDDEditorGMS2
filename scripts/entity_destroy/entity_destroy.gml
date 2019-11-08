// because game maker does not seem to be inheriting Destroy
// events for me for some reason

if (cobject) {
    c_world_destroy_object(cobject);
}

Stuff.map.active_map.contents.population[ETypes.ENTITY]--;

if (am_solid) {
    Stuff.map.active_map.contents.population_solid--;
}
if (static) {
    Stuff.map.active_map.contents.population_static--;
}

ds_list_destroy(object_events);
ds_list_destroy(switches);
ds_list_destroy(variables);

refid_remove(REFID);

ds_list_destroy_instances(movement_routes);