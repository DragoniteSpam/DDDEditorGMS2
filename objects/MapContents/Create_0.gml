/// @description map properties
// this does NOT extend Data, since all of the Data properties are
// stored in the DataMapContainer

data_buffer = noone;

summary = "It's a map, that does map things";

fog_start = 256;                          // float
fog_end = 1024;                           // float
indoors = false;                          // bool
draw_water = true;                        // bool
fast_travel_to = true;                    // bool
fast_travel_from = true;                  // bool
base_encounter_rate = 8;                  // steps?
base_encounter_deviation = 4;             // ehh

discovery = 0;                            // index

code = Stuff.default_lua_map;

// internal stuff
batches = ds_list_create();          // vertex buffers
batches_wire = ds_list_create();

batch_instances = ds_list_create();       // entities
batch_in_the_future = ds_list_create();   // entities
dynamic = ds_list_create();               // entities

all_entities = ds_list_create();          // entities

map_grid = map_create_grid(10, 10, 10);		// this just needs to exist for now, it'll get resized when stuff is loaded

frozen = vertex_create_buffer();          // everything that will be a single batch in the game

mesh_autotiles = array_create(48);
mesh_autotile_raw = array_create(48);
array_clear(mesh_autotiles, noone);
array_clear(mesh_autotile_raw, noone);

population = [0, 0, 0, 0, 0, 0, 0];
population_static = 0;
population_solid = 0;