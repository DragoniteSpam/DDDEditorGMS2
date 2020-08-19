/// @param UIThing
function dmu_dialog_event_break_prefab(argument0) {

    var thing = argument0;
    var node = thing.root.node;

    node.prefab_guid = NULL;

    script_execute(thing.root.commit, thing.root);


}
