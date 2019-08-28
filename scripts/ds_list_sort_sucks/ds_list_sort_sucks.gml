/// @param list
// this is embarassingly faster than ds_list_sort

var new_list = ds_list_create();
var list = argument0;

if (ds_list_empty(list)) {
    return list;
}

var q = ds_priority_create();

for (var i = 0; i < ds_list_size(list); i++) {
    ds_priority_add(q, list[| i], list[| i]);
}

while (!ds_priority_empty(q)) {
    ds_list_add(new_list, ds_priority_delete_min(q));
}

ds_priority_destroy(q);

return new_list;