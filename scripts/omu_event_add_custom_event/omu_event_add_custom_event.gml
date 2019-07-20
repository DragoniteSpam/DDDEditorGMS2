/// @param UIThing

var thing = argument0;

var custom = instantiate(DataEventNodeCustom);
instance_deactivate_object(custom);
custom.name = "CustomNode" + string(ds_list_size(Stuff.all_event_custom));
ds_list_add(Stuff.all_event_custom, custom);