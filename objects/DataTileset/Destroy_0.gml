event_inherited();

// these are initialized to null in the create event but are intended
// to be defined in tileset_create
if (passage) ds_grid_destroy(passage);
if (priority) ds_grid_destroy(priority);
if (flags) ds_grid_destroy(flags);
if (tags) ds_grid_destroy(tags);