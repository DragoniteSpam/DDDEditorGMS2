/// @param UIList

var list = argument0;
var entities = Stuff.map.selected_entities;
var mesh_data = guid_get(entities[| 0].mesh);
var submesh = mesh_data.submeshes[| ui_list_selection(list)].proto_guid;

for (var i = 0; i < ds_list_size(entities); i++) {
    entities[| i].mesh_submesh = submesh;
}

batch_again();