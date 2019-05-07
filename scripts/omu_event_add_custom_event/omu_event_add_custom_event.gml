/// @description  void omu_event_add_custom_event(UIThing);
/// @param UIThing

var custom=instance_create(0, 0, DataEventNodeCustom);
instance_deactivate_object(custom);
custom.name="CustomEventNode"+string(ds_list_size(Stuff.all_event_custom));
ds_list_add(Stuff.all_event_custom, custom);
