/// @param UIThing

var thing = argument0;

var pselection = ui_list_selection(thing.root.root.root.el_list);
var property = thing.root.root.root.event.types[| pselection];
var selection = ui_list_selection(thing.root.el_list_main);

if (selection >= 0) {
    var list_data = ds_list_create();
    
    for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
        if (Stuff.all_data[| i].type == DataTypes.DATA) {
            ds_list_add(list_data, Stuff.all_data[| i]);
        }
    }
    
    var list_sorted = ds_list_sort_name_sucks(list_data);
    
    var data = list_sorted[| selection];
    
    property[@ EventNodeCustomData.TYPE_GUID] = data.GUID;
    thing.root.root.root.event.types[| pselection] = property;
    
    ds_list_destroy(list_data);
    ds_list_destroy(list_sorted);
    
    thing.root.root.root.el_property_type_guid.text = "Select (" + data.name + ")";
    thing.root.root.root.el_property_type_guid.color = c_black;
    
    thing.root.root.root.changed = true;
}

dialog_destroy();