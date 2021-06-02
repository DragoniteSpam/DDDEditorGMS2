/// @description void omu_mr_move_upper_right(UIThing);
/// @param UIThing
function omu_mr_move_upper_right(argument0) {

    if (array_length(argument0.root.route.steps)<255) {
        array_push(argument0.root.route.steps, [MoveRouteActions.MOVE_UPPER_RIGHT, 1]);
    }



}
