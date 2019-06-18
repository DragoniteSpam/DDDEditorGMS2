/// @param list
// this was implemented some time into the project. there are probably
// a couple destroy events that could use this but don't.

var n = ds_list_size(argument0);;

for (var i = 0; i < n; i++) {
    instance_activate_object(argument0[| i]);
    instance_destroy(argument0[| i]);
}

ds_list_clear(argument0);

return n;
