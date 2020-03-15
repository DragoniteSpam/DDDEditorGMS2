var map = Stuff.map.active_map;
var map_contents = map.contents;
ds_list_add(map_contents.all_zones, id);

/* s */ name = "Zone " + string(ds_list_size(map_contents.all_zones));
/* s */ ztype = -1;
/* s */ zone_priority = 100;        // u16

/* s */ x1 = 0;                     // f32
/* s */ y1 = 0;                     // f32
/* s */ z1 = 0;                     // f32
/* s */ x2 = 1;                     // f32
/* s */ y2 = 1;                     // f32
/* s */ z2 = 1;                     // f32

// this is updated with z1 just so that it can interface with Selection instances
zz = 0;

zone_edit_script = null;
cobject = noone;
cshape = noone;
editor_color = [1, 1, 1, 1];

// this is the base class, do not instantiate
save_script = null;
load_script = null;