/// @description  void dmu_dialog_entity_get_event(UIThing);
/// @param UIThing

var selection_index=ui_list_selection(argument0.root.el_list);

// normally this would go at the bottom but if you spawn a new dialog for
// the entrypoints it'll get despawned immediately since the default dialog
// commit action just pops the top dialog off the stack and deletes it,
// meaning the new dialog will be removed instantly and this dialog will
// just stay here, and wow that was a lot of technobabble in one runon sentence
dmu_dialog_commit(argument0);

if (selection_index>=0){
    var new_event=Stuff.all_events[| selection_index];
    
    // safe
    var index=ui_list_selection(Camera.ui.element_entity_events);
    var list=Camera.selected_entities;
    var entity=list[| 0];
    var page=entity.object_events[| index];
    
    if (new_event.GUID!=page.event_guid){
        page.event_guid=new_event.GUID;
        argument0.root.root.el_event_guid.text="Event: "+new_event.name;
        dialog_create_entity_get_event_entrypoint(argument0.root.root);
    }
}
