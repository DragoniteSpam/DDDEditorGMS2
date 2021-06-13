function DataEvent(source) : SData(source) {
    self.nodes = ds_list_create();
    self.name_map = { };
    event_create_node(self, EventNodeTypes.ENTRYPOINT, 64, 64);
    
    static CreateJSONEvent = function() {
        var json = self.CreateJSONBase();
        json.name_map = json_stringify(self.name_map);
        json.nodes = array_create(ds_list_size(self.nodes));
        for (var i = 0, n = ds_list_size(self.nodes); i < n; i++) {
            json.nodes[i] = self.nodes[| i].CreateJSON();
        }
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEvent();
    };
    
    static Destroy = function() {
        ds_list_destroy_instances(self.nodes);
    }
}

function DataEventNode(source) : SData(source) {
    self.type = EventNodeTypes.ENTRYPOINT;                                       // serialize: buffer_u16
    
    self.data = ds_list_create();
    ds_list_add(self.data, "");
    self.outbound = [undefined];                                                 // serialize: buffer_string (this is a struct, but you serialize the ID of the destination)
    
    self.custom_guid = NULL;                                                     // serialize: buffer_datatype
    self.custom_data = [];                                                       // list of lists - contents determined by custom_guid
    
    self.prefab_guid = NULL;                                                     // serialize: buffer_datatype
    
    // editor only - set upon creation, or reset upon loading
    self.is_root = false;
    self.event = undefined;
    self.valid_destination = true;                                               // can other nodes lead to this? basically here to denote comments
    self.is_code = true;                                                         // for when you need code
    
    self.dragging = false;
    self.offset_x = -1;
    self.offset_y = -1;
    
    // PLEASE DON'T DELETE THIS. it's not needed for the event itself but it lets you
    // keep track of the nodes that refer to it when you delete it, so they can have
    // their outbound references set to zero.
    
    self.parents = { };
    
    self.ui_things = [];
    self.editor_handle = noone;
    self.editor_handle_index = -1;       // because sometimes the same node might want to spawn multiple editors and want to tell them apart
    
    static CreateJSONEventNode = function() {
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
            if (self.outbound[i]) json.outbound[i] = self.outbound[i].GUID;
        }
        json.custom_data = self.custom_data;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEventNode();
    };
    
    static Destroy = function() {
        // remove references from other objects: things that contain this as an outbound node
        var parent_nodes = variable_struct_get_names(self.parents);
        for (var i = 0; i < array_length(parent_nodes); i++) {
            var parent = self.parents[$ parent_nodes[i]];
            for (var j = 0; j < array_length(parent.outbound); j++) {
                if (parent.outbound[j] == self) {
                    parent.outbound[j] = undefined;
                }
            }
        }
        
        // outbound nodes which contain this as a parent
        for (var i = 0; i < array_length(self.outbound); i++) {
            if (self.outbound[i]) {
                variable_struct_remove(self.outbound[i].parents, self);
            }
        }
        
        // remove from event's master list of nodes
        if (self.event) {
            var event_index = ds_list_find_index(self.event.nodes, self);
            if (event_index + 1) {
                ds_list_delete(self.event.nodes, event_index);
            }
            // remove this node from the registered names for nodes in the event
            variable_struct_remove(self.event.name_map, self.name);
        }
        
        // data structures
        ds_list_destroy(self.data);
        
        // some special nodes may desire to have actual UI elements
        for (var i = 0; i < array_length(self.ui_things); i++) {
            if (is_numeric(self.ui_things[i])) {
                instance_activate_object(self.ui_things[i]);
                instance_destroy(self.ui_things[i]);
            }
        }
    }
}