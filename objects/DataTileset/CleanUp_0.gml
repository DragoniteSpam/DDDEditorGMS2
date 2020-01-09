if (Stuff.is_quitting) exit;

event_inherited();

// these are initialized to null in the create event but are intended
// to be defined in tileset_create
if (flags) ds_grid_destroy(flags);
if (tags) ds_grid_destroy(tags);

if (master) sprite_delete(master);