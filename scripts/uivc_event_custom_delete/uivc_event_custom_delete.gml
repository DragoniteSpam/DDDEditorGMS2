/// @param UIButton
function uivc_event_custom_delete(argument0) {

    var button = argument0;
    var custom = button.root.custom;
    var index = ds_list_find_index(Game.events.custom, custom);

    ds_list_delete(Game.events.custom, index);
    ui_list_deselect(button.root.root.root.el_list_custom);

    for (var i = 0; i < ds_list_size(Game.events.events); i++) {
        var event = Game.events.events[| i];
        for (var j = 0; j < array_length(event.nodes); j++) {
            if (event.nodes[j].custom_guid == custom.GUID) {
                event.nodes[j].Destroy();
            }
        }
    }
    
    custom.Destroy();

    dialog_destroy(button);


}
