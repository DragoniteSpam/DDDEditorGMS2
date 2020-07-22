/// @param UIButton

var button = argument0;
var mode = Stuff.mesh_ed;

ds_list_add(mode.format_names, "Format" + string(ds_list_size(mode.format_names)));
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
ds_list_add(mode.formats, vertex_format_end());