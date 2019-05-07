/// @description  void entity_destroy();
// because game maker does not seem to be inheriting Destroy
// events for me for some reason

if (cobject!=noone){
    c_world_destroy_object(cobject);
}

ActiveMap.population[ETypes.ENTITY]--;

if (am_solid){
    ActiveMap.population_solid--;
}
if (static){
    ActiveMap.population_static--;
}

ds_list_destroy(object_events);

ds_map_delete(Stuff.all_guids, GUID);

ds_list_destroy_instances(movement_routes);
