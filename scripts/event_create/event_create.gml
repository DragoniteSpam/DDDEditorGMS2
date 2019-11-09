/// @param name

var name = argument0;

var event = instance_create_depth(0, 0, 0, DataEvent);
event.name = name;
instance_deactivate_object(event);

return event;