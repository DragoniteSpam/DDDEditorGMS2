/// @param UIThing

var thing = argument0;

instance_destroy_later(thing.root.node);
script_execute(thing.root.commit, thing.root);