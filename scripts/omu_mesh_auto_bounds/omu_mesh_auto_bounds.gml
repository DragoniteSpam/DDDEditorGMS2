/// @param UIButton

var button = argument0;
var mesh = button.root.mesh;

show_message("this still uses the old single submesh method, if you actually need to do this, please update it to use the submeshes");
return 0;

// @todo not hard-coding this?
var grid_size = 32;

mesh.xmin = 0;
mesh.ymin = 0;
mesh.zmin = 0;
mesh.xmax = 0;
mesh.ymax = 0;
mesh.zmax = 0;

buffer_seek(mesh.buffer, buffer_seek_start, 0);

while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
    var xx = round(buffer_read(mesh.buffer, buffer_f32) / grid_size);
    var yy = round(buffer_read(mesh.buffer, buffer_f32) / grid_size);
    var zz = round(buffer_read(mesh.buffer, buffer_f32) / grid_size);
    buffer_seek(mesh.buffer, buffer_seek_relative, Stuff.graphics.format_size - 12);
    mesh.xmin = min(mesh.xmin, xx);
    mesh.ymin = min(mesh.ymin, yy);
    mesh.zmin = min(mesh.zmin, zz);
    mesh.xmax = max(mesh.xmax, xx);
    mesh.ymax = max(mesh.ymax, yy);
    mesh.zmax = max(mesh.zmax, zz);
}

data_mesh_recalculate_bounds(mesh);
buffer_seek(mesh.buffer, buffer_seek_start, 0);

ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.xmin, string(mesh.xmin));
ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.ymin, string(mesh.ymin));
ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.zmin, string(mesh.zmin));
ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.xmax, string(mesh.xmax));
ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.ymax, string(mesh.ymax));
ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.zmax, string(mesh.zmax));