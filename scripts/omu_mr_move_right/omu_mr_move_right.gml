/// @param UIThing
function omu_mr_move_right(argument0) {

    var thing = argument0;

    if (ds_list_size(thing.root.route.steps) < 255) {
        ds_list_add(thing.root.route.steps, [MoveRouteActions.MOVE_RIGHT, 1]);
        move_route_update_buffer(thing.root.route);
    }


}
