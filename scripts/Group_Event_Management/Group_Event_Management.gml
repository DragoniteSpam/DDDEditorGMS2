function event_rename_node(event, node, new_name) {
    // it attempts to, anyway
    if (validate_string_event_name(new_name, undefined)) {
        variable_struct_remove(event.name_map, node.name);
        event.name_map[$ new_name] = node;
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
        var old_node = guid_get(source.outbound[index]);
        if (old_node) {
            variable_struct_remove(old_node.parents, source.GUID);
        }
        
        if (destination) {
            destination.parents[$ source.GUID] = true;
        }
        
        source.outbound[index] = destination.GUID;
    }
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
    var custom_guid = (argument_count > 4) ? argument[4] : NULL;
    
    var node = new DataEventNode(undefined, event, type, custom_guid);
    node.x = xx;
    node.y = yy;
    
    if (event) {
        var n = array_length(event.nodes);
        var base_name = node.name;
    
        // if there's a name collision, try the next number
        do {
            // this used to be a # but that was screwing with game maker's newline thing because
            // old game maker still used the stupid version of newlines and now that i'm on the
            // new version i don't feel like changing it
            node.name = base_name + "$" + string(n++);
        } until (!event.name_map[$ node.name]);

        array_push(event.nodes, node);
        event.name_map[$ node.name] = node;
    }
    
    return node;
}

function event_get_node(event, name) {
    // @todo preferably replace this with a constant-time map lookup later
    for (var i = 0; i < array_length(event.nodes); i++) {
        if (name == event.nodes[i].name) {
            return event.nodes[i];
        }
    }
    
    return noone;
}

function event_get_node_global(name) {
    // @todo preferably replace this with a global constant-time map lookup later
    for (var i = 0; i < array_length(Game.events.events); i++) {
        var event = Game.events.events[i];
        if (event.name_map[$ name]) {
            return [event, event.name_map[$ name]];
        }
    }
    
    return undefined;
}

function event_seek_node() {
    // Checks to see if there's a node under the mouse position
    for (var i=0; i<array_length(Stuff.event.active.nodes); i++) {
        var node=Stuff.event.active.nodes[i];
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
    
    var index = array_search(Game.events.events, node.event);
    var event_list = Stuff.event.ui.t_events.el_event_list;
    ui_list_deselect(event_list);
    ui_list_select(event_list, index);
}