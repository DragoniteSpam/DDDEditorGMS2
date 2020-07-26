/// @param UIButton
// this will smooth the normals of all submodels in a mesh

var button = argument[0];
var mesh = button.root.mesh;

show_error("todo - tolerance value for this (see code)", false);
mesh_set_normals_smooth(mesh, 0/* flat */);

batch_again();