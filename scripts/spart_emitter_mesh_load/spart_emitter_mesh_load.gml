/// @description spart_emitter_mesh_load(fname)
/// @param fname
/*
	Loads a preprocessed emitter mesh from a file
*/
var fname = argument0;

var buff = buffer_load(fname);
var mesh = spart_emitter_mesh_read_from_buffer(buff);
buffer_delete(buff);

return mesh;