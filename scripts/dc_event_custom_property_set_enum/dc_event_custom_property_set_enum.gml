/// @description  void dc_event_custom_property_set_enum(UIThing);
/// @param UIThing
// i really don't like how much of a clone of the other script
// this is but

var pselection=ui_list_selection(argument0.root.root.root.el_list);
var property=argument0.root.root.root.event.types[| pselection];
var selection=ui_list_selection(argument0.root.el_list_main);

if (selection>=0){
    var list_data=ds_list_create();
    
    for (var i=0; i<ds_list_size(Stuff.all_data); i++){
        if (Stuff.all_data[| i].is_enum){
            ds_list_add(list_data, Stuff.all_data[| i]);
        }
    }
    
    var list_sorted=ds_list_sort_name_sucks(list_data);
    
    // this list is always alphabetized - for now
    //if (Stuff.setting_alphabetize_lists){
    if (true){
        var data=list_sorted[| selection];
    } else {
        var data=list_data[| selection];
    }
    
    property[@ EventNodeCustomData.TYPE_GUID]=data.GUID;
    argument0.root.root.root.event.types[| pselection]=property;
    
    ds_list_destroy(list_data);
    ds_list_destroy(list_sorted);
    
    argument0.root.root.root.el_property_type_guid.text="Select ("+data.name+")";
    argument0.root.root.root.el_property_type_guid.color=c_black;
    
    argument0.root.root.root.changed=true;
}

dialog_destroy();
