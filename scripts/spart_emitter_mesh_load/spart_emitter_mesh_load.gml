/// @description spart_emitter_mesh_load(fname)
/// @param fname
function spart_emitter_mesh_load(argument0) {
    /*
        Loads a preprocessed emitter mesh from a file
    */
    var fname = argument0;

    var buff = buffer_load(fname);
    var mesh = spart_emitter_mesh_read_from_buffer(buff);
    buffer_delete(buff);

    return mesh;


}
