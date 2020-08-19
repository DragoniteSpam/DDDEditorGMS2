/// @description void omu_mr_move_forward(UIThing);
/// @param UIThing
function omu_mr_move_forward(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.MOVE_FORWARD]);
    }



}
