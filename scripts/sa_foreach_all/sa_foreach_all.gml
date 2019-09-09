/// @param script
/// @param params[]
// processes each selected thing, but only if they're selected

var script = argument0;
var params = argument1;

for (var i = 0; i < ds_list_size(Stuff.active_map.all_entities); i++) {
    var thing = Stuff.active_map.all_entities[| i];
    if (selected(thing)) {
        script_execute(script, thing, params);
    }
}