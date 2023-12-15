function mesh_combine_all(meshes_array) {
    debug_timer_start();
    
    for (var i = 0, n = array_length(meshes_array); i < n; i++) {
        var mesh = meshes_array[i];
        if (array_length(mesh.submeshes) == 1) continue;
        
        var old_submesh_list = mesh.submeshes;
        mesh.submeshes = [];
        mesh.proto_guids = { };
        var combine_submesh = new MeshSubmesh(mesh.name + "!Combine");
        
        for (var j = 0, n2 = array_length(old_submesh_list); j < n2; j++) {
            combine_submesh.AddBufferData(old_submesh_list[j].buffer);
            old_submesh_list[j].Destroy();
        }
        
        combine_submesh.proto_guid = proto_guid_set(mesh, array_length(mesh.submeshes), undefined);
        combine_submesh.owner = mesh;
        array_push(mesh.submeshes, combine_submesh);
        mesh.first_proto_guid = combine_submesh.proto_guid;
    }
    
    batch_again();
    Stuff.AddStatusMessage("Combining the submesh took " + debug_timer_finish());
}