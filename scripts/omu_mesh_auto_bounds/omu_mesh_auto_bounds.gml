/// @param UIButton
function omu_mesh_auto_bounds(argument0) {

	var button = argument0;
	var mesh = button.root.mesh;

	var xmin = 0;
	var ymin = 0;
	var zmin = 0;
	var xmax = 0;
	var ymax = 0;
	var zmax = 0;

	for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
	    var sub = mesh.submeshes[| i];
	    buffer_seek(sub.buffer, buffer_seek_start, 0);
    
	    while (buffer_tell(sub.buffer) < buffer_get_size(sub.buffer)) {
	        var xx = round(buffer_read(sub.buffer, buffer_f32) / TILE_WIDTH);
	        var yy = round(buffer_read(sub.buffer, buffer_f32) / TILE_HEIGHT);
	        var zz = round(buffer_read(sub.buffer, buffer_f32) / TILE_DEPTH);
	        buffer_seek(sub.buffer, buffer_seek_relative, VERTEX_SIZE - 12);
	        xmin = min(xmin, xx);
	        ymin = min(ymin, yy);
	        zmin = min(zmin, zz);
	        xmax = max(xmax, xx);
	        ymax = max(ymax, yy);
	        zmax = max(zmax, zz);
	    }
    
	    buffer_seek(sub.buffer, buffer_seek_start, 0);
	}

	mesh.xmin = xmin;
	mesh.ymin = ymin;
	mesh.zmin = zmin;
	mesh.xmax = xmax;
	mesh.ymax = ymax;
	mesh.zmax = zmax;

	data_mesh_recalculate_bounds(mesh);

	ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.xmin, string(mesh.xmin));
	ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.ymin, string(mesh.ymin));
	ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.zmin, string(mesh.zmin));
	ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.xmax, string(mesh.xmax));
	ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.ymax, string(mesh.ymax));
	ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.zmax, string(mesh.zmax));


}
