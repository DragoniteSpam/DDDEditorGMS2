function mesh_combine_all(meshes_array) {
    debug_timer_start();
    
    for (var i = 0, n = array_length(meshes_array); i < n; i++) {
        var mesh = meshes_array[i];
        if (array_length(mesh.submeshes) == 1) continue;
        
        var unique_textures = { };
        var unique_textures_for_atlasing = [ ];
        for (var j = 0, n2 = array_length(mesh.submeshes); j < n2; j++) {
            var tex = guid_get(mesh.submeshes[j].tex_base);
            if (tex == undefined) continue;
            if (unique_textures[$ tex] == undefined) {
                unique_textures[$ tex] = { };
                array_push(unique_textures_for_atlasing, tex.picture);
            }
        }
        
        var remap_needed = array_length(unique_textures_for_atlasing) > 1;
        var remapped_texture_data = undefined;
        
        if (remap_needed) {
            remapped_texture_data = sprite_atlas_pack_dll(unique_textures_for_atlasing, 2, true);
            for (var j = 0, n2 = array_length(remapped_texture_data.uvs); j < n2; j++) {
                unique_textures[$ remapped_texture_data.uvs[j].sprite] = j;
            }
        }
        
        var old_submesh_list = mesh.submeshes;
        mesh.submeshes = [];
        mesh.proto_guids = { };
        var combine_submesh = new MeshSubmesh(mesh.name + "!Combine");
        
        for (var j = 0, n2 = array_length(old_submesh_list); j < n2; j++) {
            var submesh = old_submesh_list[j];
            var tex = guid_get(submesh.tex_base);
            if (remap_needed && tex != undefined) {
                var texture_data = remapped_texture_data.uvs[unique_textures[$ tex.picture]];
                combine_submesh.AddBufferData(submesh.buffer, texture_data);
            } else {
                combine_submesh.AddBufferData(submesh.buffer);
            }
            old_submesh_list[j].Destroy();
        }
        
        combine_submesh.proto_guid = proto_guid_set(mesh, array_length(mesh.submeshes), undefined);
        combine_submesh.owner = mesh;
        array_push(mesh.submeshes, combine_submesh);
        mesh.first_proto_guid = combine_submesh.proto_guid;
        
        if (remap_needed) {
            var new_diffuse_texture = tileset_create_internal(remapped_texture_data.atlas, $"{mesh.name}!tex_diffuse");
            combine_submesh.tex_base = new_diffuse_texture.GUID;
        } else {
            combine_submesh.tex_base = mesh.submeshes[0].tex_base;
        }
    }
    
    batch_again();
    Stuff.AddStatusMessage("Combining the submesh took " + debug_timer_finish());
}