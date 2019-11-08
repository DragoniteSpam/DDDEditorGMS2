// this is O(n). will not scale as well as i'd like. Use with caution.

var list = ds_list_create();

for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
    var thing = Stuff.map.active_map.contents.all_entities[| i];
    if (selected(thing)) {
        ds_list_add(list, thing);
    }
}

return list;