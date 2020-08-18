/// @param UIButton
function dmu_map_add(argument0) {

	var button = argument0;

	// automatically pushed onto the list
	var map = instance_create_depth(0, 0, 0, DataMapContainer);

	map.name = button.root.el_name.value;
	map.xx = real(button.root.el_x.value);
	map.yy = real(button.root.el_y.value);
	map.zz = real(button.root.el_z.value);
	map.on_grid = button.root.el_grid.value;
	map.light_ambient_colour = Stuff.game_lighting_default_ambient;
	map.map_chunk_size = real(button.root.el_chunk_size.value);

	script_execute(button.root.commit, button.root);


}
