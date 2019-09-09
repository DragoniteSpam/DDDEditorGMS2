/// @param script
/// @param params[]
// processes each selected thing, regardless of whether or not they're
// selected

var script = argument0;
var params = argument1;

for (var i = 0; i < ds_list_size(Stuff.active_map.all_entities); i++) {
    script_execute(script, Stuff.active_map.all_entities[| i], params);
}