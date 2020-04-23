/// @param UIButton

var button = argument[0];
var mesh = button.root.mesh;

mesh_set_texture_scale(mesh, 1);
button.root.el_scale_1x.color = c_blue;
button.root.el_scale_05x.color = c_black;