/// @param vertex-buffer
/// @param wireframe-buffer
/// @param EntityMesh

var buffer = argument0;
var wire = argument1;
var mesh = argument2;

var data = mesh.mesh_data_raw;

var base_buffer = buffer_create_from_vertex_buffer(buffer, buffer_grow, 1);
vertex_delete_buffer(buffer);
buffer_write_buffer(base_buffer, data);
buffer = vertex_create_buffer_from_buffer(base_buffer, Stuff.graphics.vertex_format);
buffer_delete(base_buffer);

return buffer;