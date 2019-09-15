/// @param UIThing

var thing = argument0;

var node = event_create_node(Stuff.active_event, EventNodeTypes.TRANSFER_PLAYER);
var map_data = node.custom_data[| 0];
map_data[| 0] = Stuff.active_map.GUID;