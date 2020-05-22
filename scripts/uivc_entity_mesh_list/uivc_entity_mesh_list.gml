/// @param UIList

var list = argument0;
var mesh = ui_list_selection(list);

// this assumes that every selected entity is already an instance of Mesh
var entities = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(entities); i++) {
    entities[| i].mesh = mesh.GUID;
}

batch_again();