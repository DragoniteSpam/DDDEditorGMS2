if (Stuff.is_quitting) exit;

event_inherited();

// remove references from other objects: things that contain this as an outbound node
var parent_nodes = variable_struct_get_names(self.parents);
for (var i = 0; i < array_length(parent_nodes); i++) {
    var parent = self.parents[$ parent_nodes[i]];
    for (var j = 0; j < array_length(parent.outbound); j++) {
        if (parent.outbound[j] == self.id) {
            parent.outbound[j] = undefined;
        }
    }
}

// outbound nodes which contain this as a parent
for (var i = 0; i < array_length(self.outbound); i++) {
    if (self.outbound[i]) {
        variable_struct_remove(self.outbound[i].parents, self.id);
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
ds_list_destroy(data);

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