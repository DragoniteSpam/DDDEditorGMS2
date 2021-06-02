if (Stuff.is_quitting) exit;

Stuff.map.active_map.contents.population[ETypes.ENTITY]--;

if (is_static) {
    Stuff.map.active_map.contents.population_static--;
}

ds_list_destroy_instances(movement_routes);

refid_remove(id);

if (cobject) {
    // it turns out removing these things is REALLY SLOW, so instead we'll pool
    // them to be removed in an orderly manner (and nullify their masks so they
    // don't accidentally trigger interactions if you click on them)
    c_object_set_mask(cobject, 0, 0);
    c_object_set_userid(cobject, 0);
    ds_queue_enqueue(Stuff.c_object_cache, cobject);
}