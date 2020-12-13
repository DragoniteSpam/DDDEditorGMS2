/// @description some of the more physical stuff in a map
// this does NOT extend Data, since all of the Data properties are
// stored in the DataMapContainer

// internal stuff
batch_data = ds_list_create();              // json

batch_in_the_future = ds_list_create();     // entities
dynamic = ds_list_create();                 // entities

all_entities = ds_list_create();            // entities
all_zones = ds_list_create();

refids = { };                               // entities (mapped onto refids)
refid_current = 0;

map_grid = map_create_grid(10, 10, 10);        // this just needs to exist for now, it'll get resized when stuff is loaded
map_grid_frozen_tags = array_create_3d(10, 10, 10);

frozen = noone;                                // everything that will be a single batch in the game
frozen_wire = noone;                        // the wireframe for the frozen vertex buffer
frozen_data = buffer_create(1, buffer_grow, 1);                        // the raw data in the frozen vertex buffer
frozen_data_size = 0;
frozen_data_wire = buffer_create(1, buffer_grow, 1);                    // the raw data in the frozen wireframe vertex buffer
frozen_data_wire_size = 0;

mesh_autotiles_top = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_top_raw = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_vertical = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_vertical_raw = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_base = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_base_raw = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_slope = array_create(AUTOTILE_COUNT, noone);
mesh_autotiles_slope_raw = array_create(AUTOTILE_COUNT, noone);

population = [0, 0, 0, 0, 0, 0, 0];
population_static = 0;

enum MapCellContents {
    TILE,
    MESH,
    PAWN,
    EFFECT,
    EVENT,
    _COUNT
}

active_lights = ds_list_create();
repeat (MAX_LIGHTS) {
    ds_list_add(active_lights, noone);
}
