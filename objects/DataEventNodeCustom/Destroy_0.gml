if (Stuff.is_quitting) exit;

event_inherited();

ds_list_destroy(types);
ds_list_destroy(outbound);