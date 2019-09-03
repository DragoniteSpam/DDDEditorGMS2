/// @param UIButton

var button = argument0;
var mesh = button.root.mesh;

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
    buffer_seek(mesh.buffer, buffer_seek_relative, VERTEX_FORMAT_SIZE - 12);
    mesh.xmin = min(mesh.xmin, xx);
    mesh.ymin = min(mesh.ymin, yy);
    mesh.zmin = min(mesh.zmin, zz);
    mesh.xmax = max(mesh.xmax, xx);
    mesh.ymax = max(mesh.ymax, yy);
    mesh.zmax = max(mesh.zmax, zz);
}

buffer_seek(mesh.buffer, buffer_seek_start, 0);

Camera.ui.t_p_mesh_editor.xmin.value = string(mesh.xmin);
Camera.ui.t_p_mesh_editor.ymin.value = string(mesh.ymin);
Camera.ui.t_p_mesh_editor.zmin.value = string(mesh.zmin);
Camera.ui.t_p_mesh_editor.xmax.value = string(mesh.xmax);
Camera.ui.t_p_mesh_editor.ymax.value = string(mesh.ymax);
Camera.ui.t_p_mesh_editor.zmax.value = string(mesh.zmax);