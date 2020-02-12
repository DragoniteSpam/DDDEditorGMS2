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
all_zones = ds_list_create();

all_refids = ds_map_create();                // entities (mapped onto refids)

map_grid = map_create_grid(10, 10, 10);        // this just needs to exist for now, it'll get resized when stuff is loaded

frozen = noone;                                // everything that will be a single batch in the game
frozen_wire = noone;                        // the wireframe for the frozen vertex buffer
frozen_data = buffer_create(1, buffer_grow, 1);                        // the raw data in the frozen vertex buffer
frozen_data_size = 0;
frozen_data_wire = buffer_create(1, buffer_grow, 1);                    // the raw data in the frozen wireframe vertex buffer
frozen_data_wire_size = 0;

mesh_autotiles_top = array_create(AUTOTILE_COUNT, noone);
mesh_autotile_top_raw = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_vertical = array_create(AUTOTILE_COUNT, noone);
mesh_autotile_vertical_raw = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_base = array_create(AUTOTILE_COUNT, noone);
mesh_autotile_base_raw = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_slope = array_create(AUTOTILE_COUNT, noone);
mesh_autotile_slope_raw = array_create(AUTOTILE_COUNT, noone);

population = [0, 0, 0, 0, 0, 0, 0];
population_static = 0;

enum MapCellContents {
    TILE,
    MESHPAWN,
    EFFECT,
    EVENT,
    _COUNT
}