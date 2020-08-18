/// @description void omu_mr_switch_on(UIThing);
/// @param UIThing
function omu_mr_switch_on(argument0) {

	if (ds_list_size(argument0.root.route.steps)<255) {
	    ds_list_add(argument0.root.route.steps, [MoveRouteActions.SWITCH_ON, 0]);
	}



}
