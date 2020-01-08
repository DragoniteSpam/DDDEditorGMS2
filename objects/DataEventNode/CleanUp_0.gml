event_inherited();

// remove references from other objects: things that contain this
// as an outbound node
var parent_nodes = ds_map_to_list(parents);
for (var i = 0; i < ds_list_size(parent_nodes); i++) {
    var parent_index = ds_list_find_index(parent_nodes[| i].outbound, id);
    if (parent_index > -1) {
        var node = parent_nodes[| i];
        node.outbound[| parent_index] = noone;
    }
}
ds_list_destroy(parent_nodes);

// outbound nodes which contain this as a parent
for (var i = 0; i < ds_list_size(outbound); i++) {
    if (outbound[| i]) {
        ds_map_delete(outbound[| i].parents, id);
    }
}

// remove from event's master list of nodes
if (event) {
    var event_index = ds_list_find_index(event.nodes, id);
    if (event_index > -1) {
        ds_list_delete(event.nodes, event_index);
    }
    // remove this node from the registered names for nodes in the event
    ds_map_delete(event.name_map, name);
}

// data structures
ds_list_destroy(outbound);
ds_list_destroy(data);
ds_map_destroy(parents);

// custom data - list of lists
for (var i = 0; i < ds_list_size(custom_data); i++) {
    ds_list_destroy(custom_data[| i]);
}
ds_list_destroy(custom_data);

// some special nodes may desire to have actual UI elements
for (var i = 0; i < ds_list_size(ui_things); i++) {
    instance_activate_object(ui_things[| i]);
    instance_destroy(ui_things[| i]);
}

ds_list_destroy(ui_things);