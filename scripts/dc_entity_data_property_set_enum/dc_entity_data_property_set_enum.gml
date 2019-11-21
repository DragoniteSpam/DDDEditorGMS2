/// @param UIThing

var thing = argument0;
var selection_index = ui_list_selection(thing.root.el_list_main);
var data_index = ui_list_selection(thing.root.root.root.el_list);

if (selection_index + 1) {
    var data = thing.root.root.root.entity.generic_data[| data_index];
    
    var list_enum = ds_list_create();
    
    for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
        if (Stuff.all_data[| i].type == DataTypes.ENUM) {
            ds_list_add(list_enum, Stuff.all_data[| i]);
        }
    }
    
    var list_sorted = ds_list_sort_name_sucks(list_enum);
    
    var type = list_sorted[| selection_index];
    data.value_type_guid = type.GUID;
    
    ds_list_destroy(list_enum);
    ds_list_destroy(list_sorted);
    
    thing.root.root.root.el_data_type_guid.text = type.name + "(Select)";
    thing.root.root.root.el_data_type_guid.color = c_black;
}

dialog_destroy();