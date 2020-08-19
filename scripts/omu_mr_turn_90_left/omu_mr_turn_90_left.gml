/// @description void omu_mr_turn_90_left(UIThing);
/// @param UIThing
function omu_mr_turn_90_left(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.TURN_90_LEFT]);
    }



}
