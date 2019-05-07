/// @description  void omu_event_add_custom(UIThing);
/// @param UIThing

if (ds_list_size(Stuff.all_event_custom)>0){
    var selection=ui_list_selection(argument0.root.el_list_main);
    if (selection>=0){
        var custom_guid=Stuff.all_event_custom[| selection].GUID;
        var node=event_create_node(Stuff.active_event, EventNodeTypes.CUSTOM, undefined, undefined, custom_guid);
    }
}

dialog_destroy();
