if (Stuff.is_quitting) exit;

event_inherited();

// this does not seem to be inheriting from Data properly and i dont know why
guid_remove(GUID);
internal_name_remove(internal_name);