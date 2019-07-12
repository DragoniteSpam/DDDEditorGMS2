event_inherited();

// serialized

// these are so they can be put in the proper place the next time you load them into the editor
// x                                                                    // serialize: buffer_u32
// y                                                                    // serialize: buffer_u32

type = EventNodeTypes.ENTRYPOINT;                                         // serialize: buffer_u16

data = ds_list_create();
outbound = ds_list_create();
ds_list_add(data, "The quick brown fox jumped over the lazy dog");      // serialize: buffer_string
ds_list_add(outbound, noone);                                           // serialize: buffer_string (name of destination)

custom_guid = 0;                                                          // serialize: buffer_u32
custom_data = ds_list_create();                                           // list of lists - contents determined by custom_guid

// editor only - set upon creation, or reset upon loading

is_root = false;
event = noone;

offset_x = -1;
offset_y = -1;

// PLEASE DON'T DELETE THIS. it's not needed for the event itself but it lets you
// keep track of the nodes that refer to it when you delete it, so they can have
// their outbound references set to zero.

parents = ds_map_create();

// could subclass this but i need to get this done in a hurry
enum EventNodeTypes {
    ENTRYPOINT,
    TEXT,
    CUSTOM,     // eveything else is Custom
    COMMENT
}