/// @param list
// sorts by data.name instead of data

var original = argument0;
var list = ds_list_create();

if (ds_list_empty(original)) {
    return list;
}

var q = ds_priority_create();

for (var i = 0; i < ds_list_size(original); i++) {
    ds_priority_add(q, original[| i], original[| i].name);
}

while (!ds_priority_empty(q)) {
    ds_list_add(list, ds_priority_delete_min(q));
}

ds_priority_destroy(q);

return list;