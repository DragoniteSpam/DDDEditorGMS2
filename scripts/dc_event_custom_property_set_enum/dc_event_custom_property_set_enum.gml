/// @param UIThing
function dc_event_custom_property_set_enum(argument0) {
    // i really don't like how much of a clone of the other script this is but

    var thing = argument0;

    var pselection = ui_list_selection(thing.root.root.root.el_list);
    var property = thing.root.root.root.event.types[| pselection];
    var selection = ui_list_selection(thing.root.el_list_main);

    if (selection >= 0) {
        var list_data = ds_list_create();
    
        for (var i = 0; i < array_length(Game.data); i++) {
            if (Game.data[i].type == DataTypes.ENUM) {
                ds_list_add(list_data, Game.data[i]);
            }
        }
    
        ds_list_sort_name(list_data);
        var data = list_data[| selection];
        property[@ EventNodeCustomData.TYPE_GUID] = data.GUID;
        thing.root.root.root.event.types[| pselection] = property;
        ds_list_destroy(list_data);
    
        thing.root.root.root.el_property_type_guid.text = "Select (" + data.name + ")";
        thing.root.root.root.el_property_type_guid.color = c_black;
    
        thing.root.root.root.changed = true;
    }

    dialog_destroy();


}
