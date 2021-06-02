/// @description void omu_mr_move_lower_left(UIThing);
/// @param UIThing
function omu_mr_move_lower_left(argument0) {

    if (array_length(argument0.root.route.steps)<255) {
        array_push(argument0.root.route.steps, [MoveRouteActions.MOVE_LOWER_LEFT, 1]);
    }



}
