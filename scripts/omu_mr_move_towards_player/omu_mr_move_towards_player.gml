/// @description void omu_mr_move_towards_player(UIThing);
/// @param UIThing
function omu_mr_move_towards_player(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.MOVE_TOWARDS_PLAYER]);
    }



}
