/// @description void omu_mr_walking_off(UIThing);
/// @param UIThing
function omu_mr_walking_off(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.WALKING_ANIM_OFF]);
    }



}
