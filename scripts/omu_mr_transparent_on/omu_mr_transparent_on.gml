/// @description  void omu_mr_transparent_on(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255){
    ds_list_add(argument0.root.route.steps, [MoveRouteActions.TRANSPARENT_ON]);
}
