/// @param files[]
/// @param extensions[]

var files = argument0;
var extensions = argument1;

var filtered_list = ds_list_create();

for (var i = 0; i < array_length_1d(files); i++) {
    var fn = files[i];
    for (var j = 0; j < array_length_1d(extensions); j++) {
        if (filename_ext(fn) == extensions[j]) {
            ds_list_add(filtered_list, fn);
        }
    }
}

return filtered_list;