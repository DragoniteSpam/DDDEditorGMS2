/// @description void omu_mr_event(UIThing);
/// @param UIThing
function omu_mr_event(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.EVENT, 0, 0]);
    }



}
