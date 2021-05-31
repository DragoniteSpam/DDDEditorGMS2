event_inherited();

// serialized

// these are so they can be put in the proper place the next time you load them into the editor
// x                                                                    // serialize: buffer_s32
// y                                                                    // serialize: buffer_s32

type = EventNodeTypes.ENTRYPOINT;                                       // serialize: buffer_u16

data = ds_list_create();
outbound = [undefined];                                                 // serialize: buffer_string (this is an instance ref, but you serialize the unique name of the destination)
ds_list_add(data, "");                                                  // serialize: buffer_string

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

parents = { };

ui_things = ds_list_create();
editor_handle = noone;
editor_handle_index = -1;       // because sometimes the same node might want to spawn multiple editors and want to tell them apart

CreateJSONEventNode = function() {
    var json = self.CreateJSONBase();
    json.type = self.type;
    json.custom_guid = self.custom_guid;
    json.prefab_guid = self.prefab_guid;
    json.x = self.x;
    json.y = self.y;
    json.data = array_create(ds_list_size(self.data));
    for (var i = 0, n = ds_list_size(self.data); i < n; i++) {
        json.data[i] = self.data[| i];
    }
    json.outbound = array_create(array_length(self.outbound));
    for (var i = 0, n = array_length(self.outbound); i < n; i++) {
        json.outbound[i] = self.outbound[i].GUID;
    }
    json.custom_data = array_create(ds_list_size(self.custom_data));
    for (var i = 0, n = ds_list_size(self.custom_data); i < n; i++) {
        var data = self.custom_data[| i];
        json.custom_data[i] = array_create(ds_list_size(data));
        for (var j = 0, n2 = ds_list_size(data); j < n2; j++) {
            json.custom_data[i][j] = data[| j];
        }
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONEventNode();
};