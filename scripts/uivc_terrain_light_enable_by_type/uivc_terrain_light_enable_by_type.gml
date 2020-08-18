/// @param UIList
function uivc_terrain_light_enable_by_type(argument0) {

	var list = argument0;
	var mode = Stuff.terrain;
	var light = mode.lights[| ui_list_selection(list)];

	list.root.el_dir_x.enabled = false;
	list.root.el_dir_y.enabled = false;
	list.root.el_dir_z.enabled = false;
	list.root.el_dir_x_name.enabled = false;
	list.root.el_dir_y_name.enabled = false;
	list.root.el_dir_z_name.enabled = false;
	list.root.el_point_x.enabled = false;
	list.root.el_point_y.enabled = false;
	list.root.el_point_z.enabled = false;
	list.root.el_point_radius.enabled = false;

	switch (light.type) {
	    case LightTypes.DIRECTIONAL:
	        list.root.el_dir_x.enabled = true;
	        list.root.el_dir_y.enabled = true;
	        list.root.el_dir_z.enabled = true;
	        list.root.el_dir_x_name.enabled = true;
	        list.root.el_dir_y_name.enabled = true;
	        list.root.el_dir_z_name.enabled = true;
	        break;
	    case LightTypes.POINT:
	        list.root.el_point_x.enabled = true;
	        list.root.el_point_y.enabled = true;
	        list.root.el_point_z.enabled = true;
	        list.root.el_point_radius.enabled = true;
	        break;
	}


}
