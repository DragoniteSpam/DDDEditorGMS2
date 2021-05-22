/// @param DataMesh
/// @param buffer
/// @param vbuffer
/// @param wbuffer
/// @param [proto-guid]
/// @param [name]
/// @param [replace-index]
/// @param [path]
function mesh_create_submesh() {
    var mesh = argument[0];
    var buffer = argument[1];
    var vbuffer = argument[2];
    var wbuffer = argument[3];
    var proto_guid = (argument_count > 4) ? argument[4] : undefined;
    var name = (argument_count > 5 && argument[5] != undefined) ? argument[5] : "Submesh" + string(ds_list_size(mesh.submeshes));
    var replace_index = (argument_count > 6 && argument[6] != undefined) ? argument[6] : -1;
    var submesh = mesh.submeshes[| replace_index];
    var path = (argument_count > 7) ? argument[7] : undefined;
    
    if (submesh) {
        buffer_delete(submesh.buffer);
        vertex_delete_buffer(submesh.vbuffer);
        vertex_delete_buffer(submesh.wbuffer);
    } else {
        var submesh = mesh.AddSubmesh(new MeshSubmesh(name), proto_guid);
    }
    
    submesh.buffer = buffer;
    submesh.vbuffer = vbuffer;
    submesh.wbuffer = wbuffer;
    
    if (path != undefined) {
        submesh.path = path;
    }
    
    return submesh;
}