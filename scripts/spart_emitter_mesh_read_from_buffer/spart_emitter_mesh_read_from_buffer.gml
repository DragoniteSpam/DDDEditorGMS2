/// @description spart_emitter_mesh_read_from_buffer(buffer)
/// @param buffer
/*
	Reads a preprocessed emitter mesh from buffer

	Script created by TheSnidr
	www.thesnidr.com
*/
var loadBuff = argument0;
var mesh = array_create(6);

//Make sure header is correct
if (buffer_read(loadBuff, buffer_u32) != sPartEmitterMeshHeader)
{
	return -1;
}

//Read mesh info
mesh[2] = buffer_read(loadBuff, buffer_f32);
mesh[3] = buffer_read(loadBuff, buffer_f32);
mesh[4] = buffer_read(loadBuff, buffer_f32);
mesh[5] = buffer_read(loadBuff, buffer_f32);
mesh[6] = buffer_read(loadBuff, buffer_u32);
mesh[7] = buffer_read(loadBuff, buffer_bool);

//Read mesh buffer
var buffSize = buffer_read(loadBuff, buffer_u64);
mesh[1] = buffer_create(buffSize, buffer_fixed, 1);
buffer_copy(loadBuff, buffer_tell(loadBuff), buffSize, mesh[1], 0);
buffer_seek(loadBuff, buffer_seek_relative, buffSize);

mesh[0] = vertex_create_buffer_from_buffer(mesh[1], sPartMeshFormat);
vertex_freeze(mesh[0]);

return mesh;