/// @param map

var map = argument0;
var list = ds_list_create();

for (var i = ds_map_find_first(map); i != undefined; i = ds_map_find_next(map, i)) {
    ds_list_add(list, i);
}

return list;