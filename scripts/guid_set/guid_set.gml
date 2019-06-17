/// @param Data
/// @param [value]
/// @param [force]

var addition = is_array(argument[0]) ? 0 : argument[0].GUID;
var force = false;
switch (argument_count) {
    case 3:
        force = argument[2];
    case 2:
        addition = argument[1];
        break;
}

// almost all data is automatically created with a GUID, so remove it
if (ds_map_exists(Stuff.all_guids, addition)) {
    ds_map_delete(Stuff.all_guids, addition);
}

// if there's a collision, you ought to be informed (and explode)
if (ds_map_exists(Stuff.all_guids, addition)) {
    show_error("guid conflict: " + is_array(argument[0]) ? argument[0] : argument[0].name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", true)
    if (!is_array(argument[0])) {
        ds_map_delete(Stuff.all_guids, argument[0].GUID);
    }
}

ds_map_add(Stuff.all_guids, addition, argument[0]);

if (!is_array(argument[0])) {
    argument[0].GUID = addition;
}

return true;