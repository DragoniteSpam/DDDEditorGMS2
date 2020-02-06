name = "Camera Zone";

x1 = 0;
y1 = 0;
z1 = 0;
x2 = 0;
y2 = 0;
z2 = 0;

zone_priority = 100;
camera_distance = 8;
camera_angle = 45;

zone_edit_script = map_zone_camera;
cobject = noone;
cshape = noone;

var map = Stuff.map.active_map;
var map_contents = map.contents;
ds_list_add(map_contents.all_camera_zones, id);