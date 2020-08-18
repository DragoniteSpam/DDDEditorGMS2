/// @description void omu_mr_wait(UIThing);
/// @param UIThing
function omu_mr_wait(argument0) {

	if (ds_list_size(argument0.root.route.steps)<255) {
	    ds_list_add(argument0.root.route.steps, [MoveRouteActions.WAIT, 1]);
	}



}
