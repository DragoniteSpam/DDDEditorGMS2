function event_rename_node(event, node, new_name) {
    // it attempts to, anyway
    if (validate_string_event_name(new_name)) {
        ds_map_delete(event.name_map, node.name);
        ds_map_add(event.name_map, new_name, node);
        node.name = new_name;
    }
}

/// @param source
/// @param destination
/// @param [index]
/// @param [force-null?]
function event_connect_node() {
    var source = argument[0];
    var destination = argument[1];
    var index = (argument_count > 2) ? argument[2] : 0;
    var force_null = (argument_count > 3) ? argument[3] : false;
    
    // because this would be silly
    if (source != destination && (destination && destination.valid_destination) || force_null) {
        var old_node = source.outbound[| index];
        if (old_node) {
            ds_map_delete(old_node.parents, source);
        }
        
        if (destination) {
            destination.parents[? source] = true;
        }
        
        source.outbound[| index] = destination;
    }
}

function event_create(name) {
    var event = instance_create_depth(0, 0, 0, DataEvent);
    event.name = name;
    instance_deactivate_object(event);
    
    return event;
}

/// @param Event
/// @param EventNodeType
/// @param [x]
/// @param [y]
/// @param [custom-guid]
function event_create_node() {
    var camera = view_get_camera(view_fullscreen);
    var event = argument[0];
    var type = argument[1];
    var xx = (argument_count > 2 && argument[2] != undefined) ? argument[2] : camera_get_view_x(camera) + room_width / 2;
    var yy = (argument_count > 3 && argument[3] != undefined) ? argument[3] : camera_get_view_y(camera) + room_height / 2;
    var custom_guid = (argument_count > 4) ? argument[4] : 0;
    
    var node = instance_create_depth(xx, yy, 0, DataEventNode);
    node.event = event;
    node.type = type;
    
    // built-in node types have their outbound count specified
    if (type != EventNodeTypes.CUSTOM) {
        var base = Stuff.event_prefab[type];
        if (base) {
            repeat (ds_list_size(base.outbound) - 1) {
                ds_list_add(node.outbound, noone);
            }
        }
    }
    
    switch (type) {
        case EventNodeTypes.ENTRYPOINT:
            node.is_root = true;
            node.name = "+Entrypoint";
            node.data[| 0] = "";
            break;
        case EventNodeTypes.TEXT:
            node.name = "Text";
            node.data[| 0] = "The quick brown fox jumped over the lazy dog";
            break;
        case EventNodeTypes.COMMENT:
            node.name = "Comment";
            node.data[| 0] = "This is a comment";
            node.valid_destination = false;
            break;
        case EventNodeTypes.SHOW_CHOICES:
            node.name = "Choose";
            node.data[| 0] = "Option 0";
            break;
        case EventNodeTypes.CONDITIONAL:
            node.name = "Branch";
            var list_branch_types = ds_list_create();
            var list_branch_indices = ds_list_create();
            var list_branch_comparisons = ds_list_create();
            var list_branch_values = ds_list_create();
            var list_branch_code = ds_list_create();
            ds_list_add(list_branch_types, ConditionBasicTypes.SWITCH);
            ds_list_add(list_branch_indices, -1);
            ds_list_add(list_branch_comparisons, Comparisons.EQUAL);
            ds_list_add(list_branch_values, 1);
            ds_list_add(list_branch_code, Stuff.default_lua_event_node_conditional);
            ds_list_add(node.custom_data, list_branch_types);
            ds_list_add(node.custom_data, list_branch_indices);
            ds_list_add(node.custom_data, list_branch_comparisons);
            ds_list_add(node.custom_data, list_branch_values);
            ds_list_add(node.custom_data, list_branch_code);
            
            var radio = create_radio_array(16, 48, "If condition:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, ConditionBasicTypes.SWITCH, node);
            radio.adjust_view = true;
            create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
        
            ds_list_add(node.ui_things, radio);
            break;
        case EventNodeTypes.CUSTOM:
        default:
            if (type != EventNodeTypes.CUSTOM) {
                custom_guid = Stuff.event_prefab[type].GUID;
            }
            var custom = guid_get(custom_guid);
            
            if (custom) {
                node.custom_guid = custom_guid;
                node.name = custom.name;
                
                // pre-allocate space for the properties of the event
                for (var i = 0; i < ds_list_size(custom.types); i++) {
                    var new_list = ds_list_create();
                    var type = custom.types[| i];
                    ds_list_add(node.custom_data, new_list);
                    ds_list_add(new_list, type[5]);
                    
                    // if all values are required, populate them with defaults
                    // (adding and deleting will be disabled)
                    if (type[4]) {
                        repeat (type[3] - 1) {
                            ds_list_add(new_list, value);
                        }
                    }
                }
                
                for (var i = 0; i < ds_list_size(custom.outbound); i++) {
                    node.outbound[| i] = noone;
                }
            }
            break;
    }
    
    if (event) {
        var n = ds_list_size(event.nodes);
        var base_name = node.name;
    
        // if there's a name collision, try the next number
        do {
            // this used to be a # but that was screwing with game maker's newline thing because
            // old game maker still used the stupid version of newlines and now that i'm on the
            // new version i don't feel like changing it
            node.name = base_name + "$" + string(n++);
        } until(!ds_map_exists(event.name_map, node.name));

        ds_list_add(event.nodes, node);
        ds_map_add(event.name_map, node.name, node);
    }
    
    instance_deactivate_object(node);
    
    return node;
}

function event_get_node(event, name) {
    // @todo preferably replace this with a constant-time map lookup later
    for (var i = 0; i < ds_list_size(event.nodes); i++) {
        if (name == event.nodes[| i].name) {
            return event.nodes[| i];
        }
    }
    
    return noone;
}

function event_get_node_global(name) {
    // @todo preferably replace this with a global constant-time map lookup later
    for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
        var event = Stuff.all_events[| i];
        if (event.name_map[? name]) {
            return [event, event.name_map[? name]];
        }
    }
    
    return undefined;
}

function event_seek_node() {
    // Checks to see if there's a node under the mouse position
    for (var i=0; i<ds_list_size(Stuff.event.active.nodes); i++) {
        var node=Stuff.event.active.nodes[| i];
        if (mouse_within_rectangle_adjusted(node.x, node.y, node.x+EVENT_NODE_CONTACT_WIDTH, node.y+EVENT_NODE_CONTACT_HEIGHT)) {
            if (!node.is_root) {
                return node;
            }
        }
    }
    
    return noone;
}

function event_view_node(node) {
    // snap the view to the specified node
    // @todo scale with the window
    var camera = view_get_camera(view_fullscreen);
    camera_set_view_pos(camera, floor(node.x - room_width / 2), floor(node.y - room_height / 3));
    Stuff.event.active = node.event;
    
    var index = ds_list_find_index(Stuff.all_events, node.event);
    var event_list = Stuff.event.ui.t_events.el_event_list;
    ui_list_deselect(event_list);
    ui_list_select(event_list, index);
}