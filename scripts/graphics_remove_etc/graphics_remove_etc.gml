/// @param guid
function graphics_remove_etc(argument0) {

    var data = guid_get(argument0);

    ds_list_delete(Stuff.all_graphic_etc, ds_list_find_index(Stuff.all_graphic_etc, data));
    instance_activate_object(data);
    instance_destroy(data);


}
