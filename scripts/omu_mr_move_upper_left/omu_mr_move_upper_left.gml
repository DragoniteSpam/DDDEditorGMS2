/// @description  void omu_mr_move_upper_left(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255){
    ds_list_add(argument0.root.route.steps, [MoveRouteActions.MOVE_UPPER_LEFT, 1]);
    move_route_update_buffer(argument0.root.route);
}
