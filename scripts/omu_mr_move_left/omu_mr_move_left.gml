/// @description void omu_mr_move_left(UIThing);
/// @param UIThing
function omu_mr_move_left(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.MOVE_LEFT, 1]);
        move_route_update_buffer(argument0.root.route);
    }



}
