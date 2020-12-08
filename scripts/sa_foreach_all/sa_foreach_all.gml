/// @param script
/// @param params[]
function sa_foreach_all(argument0, argument1) {
    // processes each selected thing, but only if they're selected

    var script = argument0;
    var params = argument1;

    for (var i = ds_list_size(Stuff.map.active_map.contents.all_entities) - 1; i >= 0; i--) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        if (selected(thing)) {
            script(thing, params);
        }
    }


}
