if (object) {
    // it turns out removing these things is REALLY SLOW, so instead we'll pool
    // them to be removed in an orderly manner (and nullify their masks so they
    // don't accidentally trigger interactions if you click on them)
    c_object_set_mask(object, 0, 0);
    c_object_set_userid(object, 0);
    ds_queue_enqueue(Stuff.c_objects_to_destroy, object);
}