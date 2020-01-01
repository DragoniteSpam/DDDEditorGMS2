/// @param Data
/// @param [name]
/// @param [force?]

var data = argument[0];

if (string_length(data.internal_name) > 0) {
    ds_map_delete(Stuff.all_internal_names, data.internal_name);
}

var new_name = (argument_count > 1) ? argument[1] : data.internal_name;
var force = (argument_count > 2) ? argument[2] : false;

if (ds_map_exists(Stuff.all_internal_names, new_name)) {
    return false;
}

// unset the data's existing internal name
if (ds_map_exists(Stuff.all_internal_names, data.internal_name)) {
    ds_map_delete(Stuff.all_internal_names, data.internal_name);
}

ds_map_add(Stuff.all_internal_names, new_name, data);
data.internal_name = new_name;
return true;