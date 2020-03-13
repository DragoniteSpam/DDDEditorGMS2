if (cobject) {
    c_world_remove_object(cobject);
    c_object_destroy(cobject);
    c_shape_destroy(cshape);
}

var map = Stuff.map.active_map;
var map_contents = map.contents;
ds_list_delete(map_contents.all_zones, ds_list_find_index(map_contents.all_zones, id));