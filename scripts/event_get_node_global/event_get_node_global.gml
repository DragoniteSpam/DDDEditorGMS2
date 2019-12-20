/// @param name
// @todo preferably replace this with a global constant-time map lookup later

var name = argument0;
for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
    var event = Stuff.all_events[| i];
    if (event.name_map[? name]) {
        return [event, event.name_map[? name]];
    }
}

return undefined;