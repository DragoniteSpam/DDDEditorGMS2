/// @description void omu_mr_stepping_on(UIThing);
/// @param UIThing
function omu_mr_stepping_on(argument0) {

	if (ds_list_size(argument0.root.route.steps)<255) {
	    ds_list_add(argument0.root.route.steps, [MoveRouteActions.STEPPING_ANIM_ON]);
	}



}
