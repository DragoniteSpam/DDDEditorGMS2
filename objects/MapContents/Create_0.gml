/// @description some of the more physical stuff in a map
// this does NOT extend Data, since all of the Data properties are
// stored in the DataMapContainer

// internal stuff
batches = [ ];                           // array of structs

batch_in_the_future = ds_list_create();     // entities
dynamic = ds_list_create();                 // entities

all_entities = ds_list_create();            // entities
all_zones = ds_list_create();

refids = { };                               // entities (mapped onto refids)
refid_current = 0;

// these just needs to exist for now, it'll get resized when stuff is loaded
map_grid = array_create_4d(10, 10, 10, MapCellContents._COUNT);
map_grid_tags = array_create_3d(10, 10, 10);

frozen = undefined;                         // everything that will be a single batch in the game
frozen_wire = undefined;                    // the wireframe for the frozen vertex buffer
frozen_data = undefined;                    // the raw data in the frozen vertex buffer
frozen_data_wire = undefined;               // the raw data in the frozen wireframe vertex buffer

reflect_frozen = undefined;
reflect_frozen_wire = undefined;
reflect_frozen_data = undefined;
reflect_frozen_data_wire = undefined;

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

ClearFrozenData = function() {
    if (frozen) vertex_delete_buffer(frozen);
    if (frozen_wire) vertex_delete_buffer(frozen_wire);
    if (reflect_frozen) vertex_delete_buffer(reflect_frozen);
    if (reflect_frozen_wire) vertex_delete_buffer(reflect_frozen_wire);
    if (frozen_data) buffer_delete(frozen_data);
    if (frozen_data_wire) buffer_delete(frozen_data_wire);
    if (reflect_frozen_data) buffer_delete(reflect_frozen_data);
    if (reflect_frozen_data_wire) buffer_delete(reflect_frozen_data_wire);
    frozen = undefined;
    frozen_wire = undefined;
    frozen_data = undefined;
    frozen_data_wire = undefined;
    
    reflect_frozen = undefined;
    reflect_frozen_wire = undefined;
    reflect_frozen_data = undefined;
    reflect_frozen_data_wire = undefined;
};