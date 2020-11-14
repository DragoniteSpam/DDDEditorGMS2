event_inherited();

// serialized

// these are so they can be put in the proper place the next time you load them into the editor
// x                                                                    // serialize: buffer_s32
// y                                                                    // serialize: buffer_s32

type = EventNodeTypes.ENTRYPOINT;                                       // serialize: buffer_u16

data = ds_list_create();
outbound = ds_list_create();
ds_list_add(data, "");                                                  // serialize: buffer_string
ds_list_add(outbound, noone);                                           // serialize: buffer_string (this is an instance ID, but you serialize the unique name of the destination)

custom_guid = NULL;                                                     // serialize: buffer_datatype
custom_data = ds_list_create();                                         // list of lists - contents determined by custom_guid

prefab_guid = NULL;                                                     // serialize: buffer_datatype

// editor only - set upon creation, or reset upon loading

is_root = false;
event = noone;
valid_destination = true;                                               // can other nodes lead to this? basically here to denote comments
is_code = true;                                                         // for when you need code

dragging = false;
offset_x = -1;
offset_y = -1;

// PLEASE DON'T DELETE THIS. it's not needed for the event itself but it lets you
// keep track of the nodes that refer to it when you delete it, so they can have
// their outbound references set to zero.

parents = ds_map_create();

ui_things = ds_list_create();
editor_handle = noone;
editor_handle_index = -1;       // because sometimes the same node might want to spawn multiple editors and want to tell them apart