/// @description  void dc_data_property_set_data(UIThing);
/// @param UIThing

var selection=ui_list_selection(argument0.root.el_list_main);

if (selection>=0){
    // i can't believe i managed to make it this bad
    // (Button.Dialog.Button.Dialog.selected_data)
    var property=argument0.root.root.root.selected_property;
    
    var list_data=ds_list_create();
    
    for (var i=0; i<ds_list_size(Stuff.all_data); i++){
        if (!Stuff.all_data[| i].is_enum){
            ds_list_add(list_data, Stuff.all_data[| i]);
        }
    }
    
    var list_sorted=ds_list_sort_name_sucks(list_data);
    
    // this list is always alphabetized - for now
    //if (Stuff.setting_alphabetize_lists){
    if (true){
        property.type_guid=list_sorted[| selection].GUID;
    } else {
        property.type_guid=list_data[| selection].GUID;
    }
    
    ds_list_destroy(list_data);
    ds_list_destroy(list_sorted);
    
    argument0.root.root.root.el_property_type_guid.text=guid_get(property.type_guid).name;
    argument0.root.root.root.el_property_type_guid.color=c_black;
    
    argument0.root.root.root.changed=true;
}

dialog_destroy();
