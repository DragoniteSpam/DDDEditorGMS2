if (cobject) c_object_destroy(cobject);

var map = Stuff.map.active_map;
var map_contents = map.contents;
ds_list_delete(map_contents.all_camera_zones, ds_list_find_index(map_contents.all_camera_zones, id));