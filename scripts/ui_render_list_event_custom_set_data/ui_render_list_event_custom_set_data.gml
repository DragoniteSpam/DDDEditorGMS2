/// @param UIList
/// @param x
/// @param y

var oldentries = argument0.entries;
argument0.entries = Stuff.all_event_custom;

//var type = guid_get(argument0.node.custom_guid).types[| argument0.index];
//var datadata = guid_get(type[EventNodeCustomData.TYPE_GUID]);

// I'm not ACTUALLY sure why this whole thing didn't crash every time when it was
// using the above two lines instead of this next one. It probalby had something to
// do with getting the right values for the wrong reason. If anything else blows
// up see if there are lines similar to the commented two anywhere that I didn't
// remove.
if (argument0.type.is_enum) {
    argument0.entries = argument0.type.properties;
} else {
    argument0.entries = argument0.type.instances;
}

// todo alphabetize lists?

ui_render_list(argument0, argument1, argument2);

// no memory leak, although the list isn't used
argument0.entries = oldentries;