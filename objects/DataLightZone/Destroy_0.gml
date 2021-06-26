if (cobject) {
    c_world_remove_object(cobject);
    c_object_destroy(cobject);
    c_shape_destroy(cshape);
}

var map = Stuff.map.active_map;
var map_contents = map.contents;
array_delete(map_contents.all_zones, array_search(map_contents.all_zones, self.id), 1);