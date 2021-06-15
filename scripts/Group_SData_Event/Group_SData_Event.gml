function DataEvent(source) : SData(source) constructor {
    self.nodes = [];
    self.name_map = { };
    
    static CreateJSONEvent = function() {
        var json = self.CreateJSONBase();
        json.name_map = json_stringify(self.name_map);
        json.nodes = array_create(array_length(self.nodes));
        for (var i = 0, n = array_length(self.nodes); i < n; i++) {
            json.nodes[i] = self.nodes[i].CreateJSON();
        }
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEvent();
    };
}

function DataEventNode(source) : SData(source) constructor {
    self.type = EventNodeTypes.ENTRYPOINT;                                       // serialize: buffer_u16
    
    self.data = [""];
    self.outbound = [NULL];                                                     // serialize: buffer_string (this is a struct, but you serialize the ID of the destination)
    
    self.custom_guid = NULL;                                                     // serialize: buffer_datatype
    self.custom_data = [];                                                       // list of lists - contents determined by custom_guid
    
    self.prefab_guid = NULL;                                                     // serialize: buffer_datatype
    
    // editor only - set upon creation, or reset upon loading
    self.is_root = false;
    self.event = undefined;
    self.valid_destination = true;                                               // can other nodes lead to this? basically here to denote comments
    self.is_code = true;                                                         // for when you need code
    
    self.dragging = false;
    self.x = 0;
    self.y = 0;
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
        json.data = self.data;
        json.outbound = self.outbound;
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
            var parent = guid_get(self.parents[$ parent_nodes[i]]);
            for (var j = 0; j < array_length(parent.outbound); j++) {
                if (parent.outbound[j] == self.GUID) {
                    parent.outbound[j] = undefined;
                }
            }
        }
        
        // outbound nodes which contain this as a parent
        for (var i = 0; i < array_length(self.outbound); i++) {
            if (self.outbound[i] != NULL) {
                variable_struct_remove(guid_get(self.outbound[i]).parents, self.GUID);
            }
        }
        
        // remove from event's master list of nodes
        if (self.event) {
            var event_index = array_search(self.event.nodes, self);
            if (event_index + 1) {
                array_delete(self.event.nodes, event_index, 1);
            }
            // remove this node from the registered names for nodes in the event
            variable_struct_remove(self.event.name_map, self.name);
        }
        
        // some special nodes may desire to have actual UI elements
        for (var i = 0; i < array_length(self.ui_things); i++) {
            if (is_numeric(self.ui_things[i])) {
                instance_activate_object(self.ui_things[i]);
                instance_destroy(self.ui_things[i]);
            }
        }
    };
}

function DataEventNodeCustom(source) : SData(source) constructor {
    self.types = [];
    self.outbound = [NULL];
    
    static CreateJSONEventCustom = function() {
        var json = self.CreateJSONBase();
        json.types = array_create(array_length(self.types));
        for (var i = 0, n = array_length(self.types); i < n; i++) {
            var type = self.types[i];
            json.types[@ i] = {
                name: type[0],
                type: type[1],
                guid: type[2],
                max_size: type[3],
                all_required: type[4],
            };
        }
        json.outbound = self.outbound;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEventCustom();
    };
    
    enum EventNodeCustomData {
        NAME,
        TYPE,
        TYPE_GUID,                  // the ID of Item, or Skill, or Class, or whatever
        MAX,
        REQUIRED,
        DEFAULT_VALUE,              // only relevant to primitives
        ATTAINMENT,                 // script for fetching the value in the event editor; null (the script) means the default method will be used
        OUTPUT,                     // script for how to display the text of this value; null (the script) means the default method will be used
    }
    
    // other values from data types like min, max and char limit are theoretically useful
    // but i really want to get this out the door so i'm not implementing them here
    
    // for now:
    // min: -0x80000000
    // max:  0x7fffffff
    // char limit (universal): 100
}

function EventNodePeristent(name, data, outbound_names) constructor {
    if (outbound_names == undefined) outbound_names = [""];
    self.name = name;
    self.flags = 0;
    self.summary = "";
    self.types = [];
    self.outbound = [];
    
    static ev_custom_id = 0;
    
    self.GUID = NULL;
    guid_set(self, "EV**" + string(ev_custom_id++));
    
    for (var i = 0; i < array_length(data); i++) {
        var datum = data[i];
        var len = array_length(datum);
    
        var data_name = datum[0];
        var data_type = datum[1];
        var data_guid = (len > 2) ? datum[2] : NULL;    // only useful for Data types
        var data_max = (len > 3) ? datum[3] : 1;
        var data_required = (len > 4) ? datum[4] : false;
        var data_default = (len > 5) ? datum[5] : 0;
        var data_attainment = (len > 6) ? datum[6] : null;
        var data_output = (len > 7) ? datum[7] : null;
    
        /// @gml update lightweight objects
        array_push(self.types, [data_name, data_type, data_guid, data_max, data_required, data_default, data_attainment, data_output]);
    }

    for (var i = 0; i < array_length(outbound_names); i++) {
        array_push(self.outbound, outbound_names[i]);
    }
}