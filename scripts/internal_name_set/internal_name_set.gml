/// @param Data
/// @param [name]
/// @param [force]

var data = argument[0];
var addition = data.internal_name;
if (string_length(addition) > 0) {
    ds_map_delete(Stuff.all_internal_names, addition);
}

var force = (argument_count > 3) ? argument[3] : false;
var addition = (argument_count > 2) ? argument[2] : addition;

// almost all data is automatically created with an internal name, so remove it
if (ds_map_exists(Stuff.all_internal_names, addition)) {
    ds_map_delete(Stuff.all_internal_names, addition);
}

// if there's a collision, you ought to be informed (and explode)
if (ds_map_exists(Stuff.all_internal_names, addition)) {
    show_error("internal name conflict [" + data.internal_name + "]: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", true);
    ds_map_delete(Stuff.all_internal_names, data.GUID);
}

ds_map_add(Stuff.all_internal_names, addition, data);
data.internal_name = addition;

return true;