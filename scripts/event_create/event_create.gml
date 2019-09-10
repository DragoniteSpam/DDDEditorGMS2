/// @description DataEvent event_create(name);
/// @param name

var event=instance_create_depth(0, 0, 0, DataEvent);
event.name=argument0;
instance_deactivate_object(event);

return event;
