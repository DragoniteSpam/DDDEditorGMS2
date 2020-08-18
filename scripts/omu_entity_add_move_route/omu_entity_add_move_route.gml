/// @param UIThing
function omu_entity_add_move_route(argument0) {

	if (ds_list_size(argument0.root.entity.movement_routes) == 255) {
	    dialog_create_notice(argument0.root, "If you create any more movement routes, the save file will break. Why do you even need so many, anyway?");
	} else {
	    var route = instance_create_depth(0, 0, 0, DataMoveRoute);
	    route.name = "MoveRoute " + string(ds_list_size(argument0.root.entity.movement_routes));
	    instance_deactivate_object(route);
	    ds_list_add(argument0.root.entity.movement_routes, route);
	}


}
