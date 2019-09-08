/// @description map properties

event_inherited();

deactivateable = false;
deleteable = false;

data_buffer = noone;

xx = 64;                                  // dimensions
yy = 64;
zz = 8;

name = "Map";                             // visible to the player
internal_name = "MAP";                    // the name of the file that the map attaches to
summary = "It's a map, that does map things";

tileset = 0;                              // index

fog_start = 256;                          // float
fog_end = 1024;                           // float
indoors = false;                          // bool
draw_water = true;                        // bool
fast_travel_to = true;                    // bool
fast_travel_from = true;                  // bool
base_encounter_rate = 8;                  // steps?
base_encounter_deviation = 4;             // ehh

is_3d = true;

discovery = 0;                            // index

code = Stuff.default_lua_map;

// internal stuff
batches = ds_list_create();          // vertex buffers
batches_wire = ds_list_create();

batch_instances = ds_list_create();       // entities
batch_in_the_future = ds_list_create();   // entities
dynamic = ds_list_create();               // entities

all_entities = ds_list_create();          // entities

map_grid = map_create_grid(xx, yy, zz);

frozen = vertex_create_buffer();          // everything that will be a single batch in the game

mesh_autotiles = array_create(48);
mesh_autotile_raw = array_create(48);
array_clear(mesh_autotiles, noone);
array_clear(mesh_autotile_raw, noone);

population = [0, 0, 0, 0, 0, 0, 0];
population_static = 0;
population_solid = 0;