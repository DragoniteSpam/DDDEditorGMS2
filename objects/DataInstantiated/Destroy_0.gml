event_inherited();

for (var i = 0; i < ds_list_size(values); i++) {
    ds_list_destroy(values[| i]);
}

ds_list_destroy(values);