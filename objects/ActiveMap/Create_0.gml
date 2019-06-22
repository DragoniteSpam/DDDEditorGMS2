/// @description map properties

event_inherited();

deactivateable = false;
deleteable = false;

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

is_3d = true;

discovery = 0;                            // index

code =
@"-- Required; called once per second when the game checks to see if anything
-- should change on the map (weather, effects, audio, etc).
-- @param map the map, which you are allowed to get (and set) the properties of
-- @param t the number of seconds since Game Start
function Update(map, t)
end";

// internal stuff
batches = ds_list_create();          // vertex buffers
batches_wire = ds_list_create();

batch_instances = ds_list_create();       // entities
batch_in_the_future = ds_list_create();   // entities
dynamic = ds_list_create();               // entities

all_entities = ds_list_create();          // entities

map_grid = map_create_grid(xx, yy, zz);

frozen = vertex_create_buffer();          // everything that will be a single batch in
                                        // the game

population = [0, 0, 0, 0, 0, 0, 0];
population_static = 0;
population_solid = 0;