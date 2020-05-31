event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

save_script = serialize_save_zone_flag;
load_script = serialize_load_zone_flag;
zone_edit_script = map_zone_flag;
editor_color = [0, 1, 0, 1];

/* s */ name = "FlagZone " + name;
/* s */ ztype = MapZoneTypes.FLAG;

zone_flags = 0;