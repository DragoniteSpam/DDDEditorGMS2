/// @param list
// this was implemented some time into the project. there are probably
// a couple destroy events that could use this but don't.

var n = ds_list_size(argument0);;

for (var i = 0; i < n; i++) {
    instance_activate_object(argument0[| i]);
    // this was giving me issues earlier but i wasn't able to reproduce them
    /*if (!instance_exists(argument0[| i])) {
    show_message(argument0[| i])
    } else {*/
    instance_destroy(argument0[| i]);
    /*}*/
}

ds_list_clear(argument0);

return n;
