event_inherited();

// these are initialized to null in the create event but are intended
// to be defined in tileset_create
ds_grid_destroy(passage);
ds_grid_destroy(priority);
ds_grid_destroy(flags);
ds_grid_destroy(tags);