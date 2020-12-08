/// @param script
/// @param params[]
function sa_foreach_global(argument0, argument1) {
    // processes each selected thing, regardless of whether or not they're
    // selected

    var script = argument0;
    var params = argument1;

    for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
        script(Stuff.map.active_map.contents.all_entities[| i], params);
    }


}
