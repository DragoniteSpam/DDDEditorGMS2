/// @param vertex-buffer
/// @param wireframe-buffer
/// @param EntityMeshAutotile

var buffer = argument0;
var wire = argument1;
var terrain = argument2;

var mapping = Stuff.autotile_map[? terrain.terrain_id];
var raw = Stuff.map.active_map.contents.mesh_autotile_raw[mapping];

return [buffer, wire];