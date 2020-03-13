event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

save_script = serialize_save_zone_effect;
load_script = serialize_load_zone_effect;
zone_edit_script = map_zone_camera;
editor_color = [1, 1, 0, 1];

/* s */ name = "FXZone " + name;
/* s */ ztype = MapZoneTypes.CAMERA;

/* s */ active_lights = ds_list_create();
repeat (MAX_LIGHTS) {
    ds_list_add(active_lights, noone);
}