/// @description DataEvent event_create(name);
/// @param name

var event=instantiate(DataEvent);
event.name=argument0;
instance_deactivate_object(event);

return event;
