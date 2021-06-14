/// @param UIThing
function dmu_dialog_event_save_prefab(argument0) {

    var thing = argument0;
    var node = thing.root.node;

    var prefab = new DataEventNode(thing.root.el_name.value);
    ds_list_add(Game.events.prefabs, prefab);

    #region big fat variable copy
    prefab.type = node.type;
    prefab.data = array_clone(node.data);
    prefab.outbound = [];

    prefab.custom_guid = node.custom_guid;
    for (var i = 0; i < array_length(node.custom_data); i++) {
        array_push(prefab.custom_data, array_clone(node.custom_data[i]));
    }

    node.prefab_guid = prefab.GUID;
    #endregion

    thing.root.commit(thing.root);


}
