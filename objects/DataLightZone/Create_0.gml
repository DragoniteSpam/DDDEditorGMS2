event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

save_script = serialize_save_zone_light;
load_script = serialize_load_zone_light;
zone_edit_script = map_zone_light;
editor_color = [1, 1, 0, 1];

/* s */ name = "LightZone " + name;
/* s */ ztype = MapZoneTypes.LIGHT;

/* s */ active_lights = ds_list_create();       // refIDs
repeat (MAX_LIGHTS) {
    ds_list_add(active_lights, noone);
}