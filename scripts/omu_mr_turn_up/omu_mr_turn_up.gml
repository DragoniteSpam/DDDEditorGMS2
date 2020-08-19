/// @description void omu_mr_turn_up(UIThing);
/// @param UIThing
function omu_mr_turn_up(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.TURN_UP]);
    }



}
