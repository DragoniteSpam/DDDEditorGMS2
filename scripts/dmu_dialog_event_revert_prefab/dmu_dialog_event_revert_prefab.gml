/// @param UIThing

var thing = argument0;
var node = thing.root.node;
var prefab = guid_get(node.prefab_guid);

// not all of the variables can change so we don't have TOO mcuh work to do
// (for the most part the only things you care about are the data and custom data lists)
ds_list_copy(node.data, prefab.data);

for (var i = 0; i < ds_list_size(node.custom_data); i++) {
	ds_list_copy(node.custom_data[| i], prefab.custom_data[| i]);
}

script_execute(thing.root.commit, thing.root);