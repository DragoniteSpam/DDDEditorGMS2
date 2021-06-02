function omu_entity_add_move_route(thing) {
    if (array_length(thing.root.entity.movement_routes) == 0xff) {
        emu_dialog_notice("If you create any more movement routes, the save file will break. Why do you even need so many, anyway?");
    } else {
        var route = instance_create_depth(0, 0, 0, DataMoveRoute);
        route.name = "MoveRoute " + string(ds_list_size(thing.root.entity.movement_routes));
        instance_deactivate_object(route);
        array_push(thing.root.entity.movement_routes, route);
    }
}