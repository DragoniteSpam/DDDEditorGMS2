/// @param map

var list = ds_list_create();

if (ds_map_empty(argument0)) {
    return list;
}

var thing = ds_map_find_first(argument0);

while (ds_map_find_last(argument0) != thing) {
    ds_list_add(list, thing);
    thing = ds_map_find_next(argument0, thing);
}

ds_list_add(list, thing);

return list;