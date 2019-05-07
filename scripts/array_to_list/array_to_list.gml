/// @description  ds_list array_to_list(array);
/// @param array

var list=ds_list_create();
for (var i=0; i<array_length_1d(argument0); i++){
    ds_list_add(list, argument0[@ i]);
}

return list;
