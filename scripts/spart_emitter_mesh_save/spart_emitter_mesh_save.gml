/// @description spart_emitter_mesh_save(emitterMesh, fname)
/// @param emitterMesh
/// @param fname
function spart_emitter_mesh_save(argument0, argument1) {
	/*
		Saves a preprocessed emitter mesh to file.
	*/
	var mesh = argument0;
	var fname = argument1;

	var buff = buffer_create(1, buffer_grow, 1);
	spart_emitter_mesh_write_to_buffer(buff, mesh);
	buffer_resize(buff, buffer_tell(buff));
	buffer_save(buff, fname);
	buffer_delete(buff);


}
