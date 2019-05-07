/// @description  void omu_event_custom_add_property(UIThing);
/// @param UIThing

var event=argument0.root.event;

if (ds_list_size(event.types)<255){
    var data=array_compose("Property"+string(ds_list_size(event.types)), DataTypes.INT, 0, 1, false);
    ds_list_add(event.types, data);
} else {
    dialog_create_notice(argument0.root, "Please don't try to create more properties for a custom event type than can fit in an unsigned byte. Bad things will happen. Why do you even want that many?", "Hey!");
}
