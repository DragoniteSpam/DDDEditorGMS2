if (Stuff.is_quitting) exit;

event_inherited();

ds_list_destroy(steps);
if (buffer) vertex_delete_buffer(buffer);