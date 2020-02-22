if (Stuff.is_quitting) exit;

event_inherited();

ds_map_destroy(selected_entries);
if (own_entries) ds_list_destroy(entries);
ds_list_destroy(entry_colors);
if (surface) surface_free(surface);