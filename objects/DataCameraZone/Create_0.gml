event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

/* s */ name = "Camera " + name;
/* s */ ztype = MapZoneTypes.CAMERA;

/* s */ x1 = 0;                                         // f32
/* s */ y1 = 0;                                         // f32
/* s */ z1 = 0;                                         // f32
/* s */ x2 = 1;                                         // f32
/* s */ y2 = 1;                                         // f32
/* s */ z2 = 1;                                         // f32

// this is updated with z1 just so that it can interface with Selection instances
zz = 0;

/* s */ zone_priority = 100;                            // u16
/* s */ camera_distance = 8;                            // u16
/* s */ camera_angle = 45;                              // f32
/* s */ camera_easing_method = AnimationTweens.LINEAR;  // u8
/* s */ camera_easing_time = 1;                         // f32
/* s */ camera_orthographic_size = 1;                   // f32

zone_edit_script = map_zone_camera;
cobject = noone;
cshape = noone;
editor_color = [0, 0, 1, 1];

save_script = serialize_save_zone_camera;
load_script = serialize_load_zone_camera;