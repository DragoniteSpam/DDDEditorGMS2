/// @param UIThing

var thing = argument0;
var node = thing.root.node;

node.prefab_guid = 0;

script_execute(thing.root.commit, thing.root);