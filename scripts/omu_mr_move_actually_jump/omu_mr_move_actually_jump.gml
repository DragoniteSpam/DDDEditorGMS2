/// @description  void omu_mr_move_actually_jump(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255){
    ds_list_add(argument0.root.route.steps, [MoveRouteActions.MOVE_ACTUALLY_JUMP, 0]);
    move_route_update_buffer(argument0.root.route);
}
