function DataEvent(source) : SData(source) constructor {
    self.nodes = [];
    self.name_map = { };
    
    if (is_struct(source)) {
        self.nodes = array_create(array_length(source.nodes));
        for (var i = 0, n = array_length(source.nodes); i < n; i++) {
            self.nodes[i] = new DataEventNode(source.nodes[i], self);
            self.name_map[$ self.nodes[i].name] = self.nodes[i];
        }
    }
    
    self.Export = function(buffer) {
        // dont export base; event graphs are only for the editor
        for (var i = 0, n = array_length(self.nodes); i < n; i++) {
            self.nodes[i].Export(buffer);
        }
        return array_length(self.nodes);
    };
    
    static CreateJSONEvent = function() {
        var json = self.CreateJSONBase();
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

function DataEventNode(source, parent, type = EventNodeTypes.ENTRYPOINT, custom = NULL) : SData(source) constructor {
    self.type = type;
    
    self.data = [""];
    self.outbound = [NULL];                                                     // serialize: buffer_string (this is a struct, but you serialize the ID of the destination)
    self.custom_guid = NULL;                                                    // serialize: buffer_datatype
    self.custom_data = [];                                                      // list of lists - contents determined by custom_guid
    
    self.prefab_guid = NULL;
    
    // editor only - set upon creation, or reset upon loading
    self.event = parent;                                                        // not a GUID - this doesnt need to be serialized
    self.valid_destination = true;                                              // can other nodes lead to this? basically here to denote comments
    
    self.dragging = false;
    self.x = 0;
    self.y = 0;
    self.offset_x = -1;
    self.offset_y = -1;
    
    self.ui_things = [];
    
    static Setup = function(type, custom_guid) {
        if (type == undefined) return;
        // built-in node types have their outbound count specified
        if (type != EventNodeTypes.CUSTOM) {
            var base = Game.default_event_nodes[type];
            if (base) self.outbound = array_create(array_length(base.outbound), NULL);
        }
        
        switch (type) {
            case EventNodeTypes.ENTRYPOINT:
                self.name = "+Entrypoint";
                self.data[0] = "";
                break;
            case EventNodeTypes.TEXT:
                self.name = "Text";
                self.data[0] = "The quick brown fox jumped over the lazy dog";
                break;
            case EventNodeTypes.COMMENT:
                self.name = "Comment";
                self.data[0] = "This is a comment";
                self.valid_destination = false;
                break;
            case EventNodeTypes.SHOW_CHOICES:
                self.name = "Choose";
                self.data[0] = "Option 0";
                break;
            case EventNodeTypes.CONDITIONAL:
                self.name = "Branch";
                self.custom_data = [
                    [ConditionBasicTypes.SWITCH],
                    [-1],
                    [Comparisons.EQUAL],
                    [1],
                    [""],
                ];
                
                var radio = create_radio_array(16, 48, "If condition:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, ConditionBasicTypes.SWITCH, self);
                radio.adjust_view = true;
                create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
                array_push(self.ui_things, radio);
                break;
            case EventNodeTypes.CUSTOM:
            default:
                // if you're one of the built-in (non-special) node types, just grab
                // that as your "custom guid"
                if (type != EventNodeTypes.CUSTOM) {
                    custom_guid = Game.default_event_nodes[type].GUID;
                }
                
                var custom = guid_get(custom_guid);
                
                if (custom) {
                    self.custom_guid = custom_guid;
                    self.name = custom.name;
                    // pre-allocate space for the properties of the event
                    for (var i = 0; i < array_length(custom.types); i++) {
                        var property = custom.types[i];
                        // entity references are automatically initialized to REFID_SELF
                        array_push(self.custom_data, array_create(property.max_size, (property.type == DataTypes.ENTITY) ? REFID_SELF : property.default_value));
                    }
                    
                    self.outbound = array_create(array_length(custom.outbound), NULL);
                }
                break;
        }
    };
    
    static GetShortName = function() {
        var event_name = self.event.name;
        var event_length = string_length(event_name);
        var entrypoint_length = string_length(self.name);
        var max_length = 12;
        return string_copy(event_name, 1, min(max_length, event_length)) + ((event_length > max_length) ? "..." : "") + "/" +
            string_copy(self.name, 1, min(max_length, entrypoint_length)) + ((entrypoint_length > max_length) ? "..." : "");
    };
    
    static Rename = function(new_name) {
        // it attempts to, anyway
        if (validate_string_event_name(new_name, undefined)) {
            variable_struct_remove(self.event.name_map, self.name);
            self.event.name_map[$ new_name] = self;
            self.name = new_name;
        }
    };
    
    static Connect = function(destination, index = 0, force_null = false) {
        if (!destination && force_null) {
            self.outbound[index] = NULL;
        }
        
        if (!destination) return;
        if (self == destination) return;
        if (destination && destination.type == EventNodeTypes.ENTRYPOINT) return;
        
        self.outbound[index] = destination.GUID;
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u16, self.type);
        buffer_write(buffer, buffer_datatype, self.custom_guid);
        
        buffer_write(buffer, buffer_u16, array_length(self.data));
        for (var i = 0; i < array_length(self.data); i++) {
            buffer_write(buffer, buffer_string, self.data[i]);
        }
        
        buffer_write(buffer, buffer_u16, array_length(self.outbound));
        for (var i = 0; i < array_length(self.outbound); i++) {
            buffer_write(buffer, buffer_datatype, self.outbound[i]);
        }
        
        switch (self.type) {
            case EventNodeTypes.ENTRYPOINT:
            case EventNodeTypes.TEXT:
            case EventNodeTypes.SHOW_CHOICES:
                break;
            case EventNodeTypes.CONDITIONAL:
                var list_types = self.custom_data[0];
                var list_indices = self.custom_data[1];
                var list_comparisons = self.custom_data[2];
                var list_values = self.custom_data[3];
                var list_code = self.custom_data[4];
                
                buffer_write(buffer, buffer_u8, array_length(list_types));
                for (var i = 0; i < array_length(list_types); i++) {
                    buffer_write(buffer, buffer_u8, list_types[i]);
                    buffer_write(buffer, buffer_s32, list_indices[i]);
                    buffer_write(buffer, buffer_u8, list_comparisons[i]);
                    buffer_write(buffer, buffer_f32, list_values[i]);
                    buffer_write(buffer, buffer_string, list_code[i]);
                }
                break;
            case EventNodeTypes.CUSTOM:
            default:
                // the size of this list should already be known by the custom event node
                var custom = guid_get(self.custom_guid);
                
                for (var i = 0; i < array_length(self.custom_data); i++) {
                    var type = custom.types[i];
                    var n_custom_data = array_length(self.custom_data[i]);
                    var datatype = Stuff.data_type_meta[type.type].buffer_type;
                    buffer_write(buffer, buffer_u8, n_custom_data);
                    for (var j = 0; j < n_custom_data; j++) {
                        buffer_write(buffer, datatype, self.custom_data[i][j]);
                    }
                }
                break;
        }
    };
    
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
        self.DestroyBase();
        if (self.event) {
            // remove references from other objects: things that contain this as an outbound node
            for (var i = 0; i < array_length(self.event.nodes); i++) {
                var node = self.event.nodes[i];
                for (var j = 0; j < array_length(node.outbound); j++) {
                    if (node.outbound[j] == self.GUID) {
                        node.outbound[j] = NULL;
                    }
                }
            }
            
            // remove from event's master list of nodes and registered names
            array_delete(self.event.nodes, array_search(self.event.nodes, self), 1);
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
    
    self.Setup(type, custom);
    
    if (is_struct(source)) {
        // mainly we need to do this to set up some helper stuff like embedded UI
        self.Setup(source.type, source.custom_guid);
        self.name = source.name;
        self.type = source.type;
        self.custom_guid = source.custom_guid;
        self.prefab_guid = source.prefab_guid;
        self.x = source.x;
        self.y = source.y;
        self.data = source.data;
        self.outbound = source.outbound;
        self.custom_data = source.custom_data;
    }
}

function DataEventNodeCustom(source) : SData(source) constructor {
    self.types = [];
    self.outbound = [NULL];
    
    static CreateJSONEventCustom = function() {
        var json = self.CreateJSONBase();
        json.types = self.types;
        json.outbound = self.outbound;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEventCustom();
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, array_length(self.types));
        for (var i = 0; i < array_length(self.types); i++) {
            buffer_write(buffer, buffer_u32, self.types[i].type);
        }
    };
    
    if (is_struct(source)) {
        self.types = source.types;
        self.outbound = source.outbound;
        
        for (var i = 0; i < array_length(self.types); i++) {
            // these dont get serialized
            self.types[i].data_attainment = null;
            self.types[i].data_output = null;
        }
    }
    
    // other values from data types like min, max and char limit are theoretically useful
    // but i really want to get this out the door so i'm not implementing them here
    
    // for now:
}

function EventNodeProperty(name, type, type_guid = NULL, max_size = 1, all_required = false, default_value = 0, data_attainment = null, data_output = null) constructor {
    self.name = name;
    self.type = type;
    self.type_guid = type_guid;
    self.max_size = max_size;
    self.all_required = all_required;
    self.default_value = default_value;
    self.data_attainment = data_attainment;
    self.data_output = data_output;
    
    self.min_value = -0x80000000;
    self.max_value =  0x7fffffff;
    self.char_limit = 100;
}

function EventNodePeristent(name, data_types, outbound_names = ["default"]) constructor {
    self.name = name;
    self.flags = 0;
    self.summary = "";
    
    self.GUID = NULL;
    guid_set(self, "EV**" + string(Identifiers.event_fixed_id++));
    
    self.types = data_types;
    self.outbound = outbound_names;
}