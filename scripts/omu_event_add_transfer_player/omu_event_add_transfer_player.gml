/// @param UIThing
function omu_event_add_transfer_player(argument0) {

    var thing = argument0;

    var node = event_create_node(Stuff.event.active, EventNodeTypes.TRANSFER_PLAYER);
    var map_data = node.custom_data[| 0];
    map_data[| 0] = Stuff.map.active_map.GUID;


}
