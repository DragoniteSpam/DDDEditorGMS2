/// @param file

// returns the ID of the process, or 0
if (!file_exists(argument0)) return false;
return external_call(global._ds_stuff_open, argument0);