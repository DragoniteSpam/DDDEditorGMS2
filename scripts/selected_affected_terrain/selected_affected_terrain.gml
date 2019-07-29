// this is O(n). will not scale as well as i'd like. Use with caution.

var list = ds_list_create();

for (var i = 0; i < ds_list_size(ActiveMap.all_entities); i++) {
    var thing = ActiveMap.all_entities[| i];
    if (instanceof(thing, EntityMeshTerrain) && selected_border(thing)) {
        ds_list_add(list, thing);
    }
}

return list;