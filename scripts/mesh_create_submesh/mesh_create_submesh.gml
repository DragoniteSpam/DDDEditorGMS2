function mesh_create_submesh(mesh, buffer, vbuffer, name = "Submesh" + string(array_length(mesh.submeshes)), path = "") {
    var submesh = new MeshSubmesh(name);
    mesh.AddSubmesh(submesh);
    submesh.buffer = buffer;
    submesh.vbuffer = vbuffer;
    submesh.path = path;
    return submesh;
}