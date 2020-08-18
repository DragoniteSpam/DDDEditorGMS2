/// @description void omu_mr_direction_fix_off(UIThing);
/// @param UIThing
function omu_mr_direction_fix_off(argument0) {

	if (ds_list_size(argument0.root.route.steps)<255) {
	    ds_list_add(argument0.root.route.steps, [MoveRouteActions.DIRECTION_FIX_OFF]);
	}



}
