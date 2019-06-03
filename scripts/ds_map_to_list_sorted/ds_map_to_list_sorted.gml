/// @description list ds_map_to_list_sorted(map);
/// @param map
// this is far, far faster than ds_list_sort

var list=ds_list_create();

if (ds_map_empty(argument0)) {
    return list;
}

var q=ds_priority_create();
var thing=ds_map_find_first(argument0);

while (ds_map_find_last(argument0)!=thing) {
    ds_priority_add(q, thing, thing);
    thing=ds_map_find_next(argument0, thing);
}

ds_priority_add(q, thing, thing);

while (!ds_priority_empty(q)) {
    ds_list_add(list, ds_priority_delete_min(q));
}

ds_priority_destroy(q);

return list;
