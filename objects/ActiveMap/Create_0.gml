/// @description properties of the active map

event_inherited();

deactivateable=false;
deleteable=false;

xx=64;                                  // dimensions
yy=64;
zz=8;

name="Map";                             // visible to the player
internal_name="MAP";                    // just in case you can't have spaces i guess
summary="It's a map, that does map things";

tileset=0;                              // index

audio_bgm="";                           // internal name
audio_ambient=ds_list_create();         // list of internal names
audio_ambient_frequencies=ds_list_create();  // list of bytes

fog_start=256;                          // float
fog_end=1024;                           // float
indoors=false;                          // bool
draw_water=true;                        // bool
fast_travel_to=true;                    // bool
fast_travel_from=true;                  // bool

is_3d=true;

discovery=0;                            // index

// internal stuff
batches=ds_list_create();          // vertex buffers
batches_wire=ds_list_create();

batch_instances=ds_list_create();       // entities
batch_in_the_future=ds_list_create();   // entities
dynamic=ds_list_create();               // entities

all_entities=ds_list_create();          // entities

map_grid=map_create_grid(xx, yy, zz);

frozen=vertex_create_buffer();          // everything that will be a single batch in
                                        // the game

population=[0, 0, 0, 0, 0, 0, 0];
population_static=0;
population_solid=0;

