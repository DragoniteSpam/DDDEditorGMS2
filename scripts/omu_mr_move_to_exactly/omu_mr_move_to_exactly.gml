/// @description void omu_mr_move_to_exactly(UIThing);
/// @param UIThing
function omu_mr_move_to_exactly(argument0) {

    if (array_length(argument0.root.route.steps)<255) {
        array_push(argument0.root.route.steps, [MoveRouteActions.MOVE_TO, 0, 0]);
    }



}
