/// @param vertex-buffer
/// @param wireframe-buffer
/// @param EntityMeshTerrain

var buffer = argument0;
var wire = argument1;
var terrain = argument2;

var mapping = Stuff.autotile_map[? terrain.terrain_id];
var raw = Stuff.map.active_map.contents.mesh_autotiles_raw[mapping];

var base_buffer = buffer_create_from_vertex_buffer(buffer, buffer_grow, 1);
vertex_delete_buffer(buffer);
buffer_write_buffer(base_buffer, raw);
buffer = vertex_create_buffer_from_buffer(base_buffer, Stuff.graphics.vertex_format);
buffer_delete(base_buffer);

return buffer;