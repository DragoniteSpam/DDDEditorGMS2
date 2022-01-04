function mesh_create_submesh(mesh, buffer, vbuffer, proto_guid = undefined, name = "Submesh" + string(array_length(mesh.submeshes)), replace_index = -1, path = undefined) {
    var submesh = (replace_index == -1) ? undefined : mesh.submeshes[replace_index];
    
    if (submesh) {
        buffer_delete(submesh.buffer);
        vertex_delete_buffer(submesh.vbuffer);
    } else {
        submesh = mesh.AddSubmesh(new MeshSubmesh(name), proto_guid);
    }
    
    submesh.buffer = buffer;
    submesh.vbuffer = vbuffer;
    
    if (path != undefined) {
        submesh.path = path;
    }
    
    return submesh;
}