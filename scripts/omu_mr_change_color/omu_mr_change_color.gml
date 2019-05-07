/// @description  void omu_mr_change_color(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255){
    ds_list_add(argument0.root.route.steps, array_compose(MoveRouteActions.CHANGE_TINT, c_white));
}
