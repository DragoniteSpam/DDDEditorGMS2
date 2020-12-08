/// @param UIThing
function dmu_dialog_event_save_prefab(argument0) {

    var thing = argument0;
    var node = thing.root.node;

    var prefab = instance_create_depth(0, 0, 0, DataEventNode);
    ds_list_add(Stuff.all_event_prefabs, prefab);

#region big fat variable copy
    prefab.name = thing.root.el_name.value;
    prefab.type = node.type;
    ds_list_clear(prefab.data);
    ds_list_copy(prefab.data, node.data);
    ds_list_clear(prefab.outbound);

    prefab.custom_guid = node.custom_guid;
    for (var i = 0; i < ds_list_size(node.custom_data); i++) {
        ds_list_add(prefab.custom_data, ds_list_clone(node.custom_data[| i]));
    }

    node.prefab_guid = prefab.GUID;
#endregion

    thing.root.commit(thing.root);


}
