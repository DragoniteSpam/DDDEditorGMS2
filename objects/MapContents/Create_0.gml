/// @description some of the more physical stuff in a map
// this does NOT extend Data, since all of the Data properties are
// stored in the DataMapContainer

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