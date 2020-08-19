/// @description spart_emitter_mesh_write_to_buffer(buffer, mesh)
/// @param buffer
/// @param mesh
function spart_emitter_mesh_write_to_buffer(argument0, argument1) {
    /*
        Writes the given preprocessed mesh to the given buffer.

        Script created by TheSnidr
        www.thesnidr.com
    */
    var saveBuff = argument0;
    var mesh = argument1;

    //Write header
    buffer_write(saveBuff, buffer_u32, sPartEmitterMeshHeader);

    //Write mesh info
    buffer_write(saveBuff, buffer_f32, mesh[2]);
    buffer_write(saveBuff, buffer_f32, mesh[3]);
    buffer_write(saveBuff, buffer_f32, mesh[4]);
    buffer_write(saveBuff, buffer_f32, mesh[5]);
    buffer_write(saveBuff, buffer_u32, mesh[6]);
    buffer_write(saveBuff, buffer_bool, mesh[7]);

    //Write mesh buffer
    var buffSize = buffer_get_size(mesh[1]);
    buffer_write(saveBuff, buffer_u64, buffSize);
    buffer_copy(mesh[1], 0, buffSize, saveBuff, buffer_tell(saveBuff));
    buffer_seek(saveBuff, buffer_seek_relative, buffSize);


}
