event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

save_script = serialize_save_zone_camera;
load_script = serialize_load_zone_camera;
zone_edit_script = map_zone_camera;
editor_color = [0, 0, 1, 1];

/* s */ name = "CamZone " + name;
/* s */ ztype = MapZoneTypes.CAMERA;

/* s */ camera_distance = 8;                            // u16
/* s */ camera_angle = 45;                              // f32
/* s */ camera_easing_method = AnimationTweens.LINEAR;  // u8
/* s */ camera_easing_time = 1;                         // f32