/// @description map properties

event_inherited();

name = "Map";
summary = "it does map things";

file_location = DataFileLocations.DATA;
data_buffer = buffer_create(1, buffer_grow, 1);
contents = noone;
version = DataVersions._CURRENT;

tiled_map_id = -1;

preview = noone;
wpreview = noone;
cspreview = noone;
cpreview = noone;

on_grid = true;

// all of the map properties have finally been moved over to the map container

xx = 64;                                    // dimensions
yy = 64;
zz = 8;

tileset = 0;                                // index
is_3d = true;                               // bool
fog_start = 256;                            // float
fog_end = 1024;                             // float
fog_enabled = true;                         // bool
fog_colour = c_white;                       // uint
indoors = false;                            // bool
draw_water = true;                          // bool
water_level = 0;                            // float
reflections_enabled = true;                 // bool
fast_travel_to = true;                      // bool
fast_travel_from = true;                    // bool
base_encounter_rate = 8;                    // steps?
base_encounter_deviation = 4;               // ehh
run_init = true;                            // bool

discovery = 0;                              // index

code = Stuff.default_lua_map;               // code

generic_data = ds_list_create();            // similar to that attached to Entities

ds_list_add(Stuff.all_maps, id);