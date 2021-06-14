/// @param UIThing
function dc_data_property_set_enum(argument0) {

    var thing = argument0;
    var selection = ui_list_selection(thing.root.el_list_main);

    if (selection >= 0) {
        var property = thing.root.root.root.selected_property;
    
        var list_enum = [];
    
        for (var i = 0; i < array_length(Game.data); i++) {
            if (Game.data[i].type == DataTypes.ENUM) {
                array_push(list_enum, Game.data[i]);
            }
        }
    
        array_sort_name(list_enum);
        property.type_guid = list_enum[selection].GUID;
    
        thing.root.root.root.el_property_type_guid.text = guid_get(property.type_guid).name;
        thing.root.root.root.el_property_type_guid.color = c_black;
    }

    dialog_destroy();


}
