/// @description  void omu_mr_transparent_off(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255){
    ds_list_add(argument0.root.route.steps, array_compose(MoveRouteActions.TRANSPARENT_OFF));
}
