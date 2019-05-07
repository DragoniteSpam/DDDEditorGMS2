/// @description  void omu_event_add_event(UIThing);
/// @param UIThing

var catch=argument0;

ds_list_add(Stuff.all_events, event_create("Event$"+string(ds_list_size(Stuff.all_events))));
