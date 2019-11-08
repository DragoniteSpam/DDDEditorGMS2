/// @param Entity
/// @param [value]
/// @param [force]

var data = argument[0];
var addition = (argument_count > 1) ? argument[1] : data.REFID;
var force = (argument_count > 2) ? argument[2] : false;

// almost all data is automatically created with a REFID, so remove it
if (ds_map_exists(Stuff.map.active_map.contents.all_refids, addition)) {
    ds_map_delete(Stuff.map.active_map.contents.all_refids, addition);
}

// if there's a collision, you ought to be informed (and explode)
if (ds_map_exists(Stuff.map.active_map.contents.all_refids, addition)) {
    show_error("refid conflict: " + argument[0].name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", true)
    ds_map_delete(Stuff.map.active_map.contents.all_refids, argument[0].REFID);
}

ds_map_add(Stuff.map.active_map.contents.all_refids, addition, argument[0]);
argument[0].REFID = addition;

return true;