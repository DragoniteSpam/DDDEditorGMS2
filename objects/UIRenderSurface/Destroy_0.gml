if (Stuff.is_quitting) exit;

event_inherited();

if (surface_exists(surface)) surface_free(surface);