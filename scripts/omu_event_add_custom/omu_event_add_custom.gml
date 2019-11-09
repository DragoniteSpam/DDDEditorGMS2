/// @param UIThing

var thing = argument0;

if (ds_list_size(Stuff.all_event_custom) > 0) {
    var selection = ui_list_selection(thing.root.el_list_main);
    if (selection >= 0) {
        var custom_guid = Stuff.all_event_custom[| selection].GUID;
        var node = event_create_node(Stuff.event.active, EventNodeTypes.CUSTOM, undefined, undefined, custom_guid);
    }
}

dialog_destroy();