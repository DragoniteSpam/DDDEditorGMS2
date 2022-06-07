function event_create_node(event, type, xx = room_width / 2, yy = room_height / 2, custom_guid = NULL) {
    // to do: adjust the position of new nodes based on where the camera is
    var node = new DataEventNode(undefined, event, type, custom_guid);
    node.x = xx;
    node.y = yy;
    
    if (event) {
        var n = array_length(event.nodes);
        var base_name = node.name;
    
        // if there's a name collision, try the next number
        do {
            node.name = base_name + "$" + string(n++);
        } until (!event.name_map[$ node.name]);

        array_push(event.nodes, node);
        event.name_map[$ node.name] = node;
    }
    
    return node;
}

function event_get_node_global(name) {
    // @todo preferably replace this with a global constant-time map lookup later
    for (var i = 0; i < array_length(Game.events.events); i++) {
        var event = Game.events.events[i];
        if (event.name_map[$ name]) {
            return event.name_map[$ name];
        }
    }
    
    return undefined;
}

function event_view_node(node) {
    // snap the view to the specified node
    // @todo scale with the window
    //var camera = view_get_camera(view_fullscreen);
    //camera_set_view_pos(camera, floor(node.x - room_width / 2), floor(node.y - room_height / 3));
    // @todo grrr
    Stuff.event.active = node.event;
}