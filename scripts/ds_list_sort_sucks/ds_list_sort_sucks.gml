/// @description  list ds_list_sort_sucks(list);
/// @param list
// this is embarassingly faster than ds_list_sort

var list=ds_list_create();

if (ds_list_empty(argument0)){
    return list;
}

var q=ds_priority_create();

for (var i=0; i<ds_list_size(argument0); i++){
    ds_priority_add(q, argument0[| i], argument0[| i]);
}

while (!ds_priority_empty(q)){
    ds_list_add(list, ds_priority_delete_min(q));
}

ds_priority_destroy(q);

return list;
