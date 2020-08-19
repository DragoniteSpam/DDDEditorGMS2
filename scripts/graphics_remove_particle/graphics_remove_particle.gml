/// @param guid
function graphics_remove_particle(argument0) {

    var data = guid_get(argument0);

    ds_list_delete(Stuff.all_graphic_particles, ds_list_find_index(Stuff.all_graphic_particles, data));
    instance_activate_object(data);
    instance_destroy(data);


}
