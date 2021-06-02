/// @param UIThing
function omu_mr_move_right(argument0) {

    var thing = argument0;

    if (array_length(thing.root.route.steps) < 255) {
        array_push(thing.root.route.steps, [MoveRouteActions.MOVE_RIGHT, 1]);
    }


}
