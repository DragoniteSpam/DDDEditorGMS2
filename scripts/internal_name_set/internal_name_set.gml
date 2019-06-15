/// @param Data
/// @param [name]
/// @param [force]

var addition = argument[0].internal_name;
if (string_length(addition) > 0) {
    ds_map_delete(Stuff.all_internal_names, addition);
}

var force = false;
switch (argument_count) {
    case 3:
        force = argument[2];
    case 2:
        addition = argument[1];
        break;
}

// almost all data is automatically created with a GUID, so remove it
if (ds_map_exists(Stuff.all_internal_names, addition)) {
    ds_map_delete(Stuff.all_internal_names, addition);
}

// if there's a collision, you ought to be informed (and explode)
if (ds_map_exists(Stuff.all_internal_names, addition)) {
    show_error("internal name conflict [" + argument[0].internal_name + "]: " + argument[0].name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", true);
    ds_map_delete(Stuff.all_internal_names, argument[0].GUID);
}

ds_map_add(Stuff.all_internal_names, addition, argument[0]);
argument[0].internal_name = addition;

return true;