function serialize_load_meshes(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    ds_list_clear_instances(Stuff.all_meshes);
    
    var n_meshes = buffer_read(buffer, buffer_u32);
    
    repeat (n_meshes) {
        var mesh = instance_create_depth(0, 0, 0, DataMesh);
        serialize_load_generic(buffer, mesh, version);
        
        mesh.type = buffer_read(buffer, buffer_u8);
        
        var n_submeshes = buffer_read(buffer, buffer_u16);
        for (var i = 0; i < n_submeshes; i++) {
            var index = buffer_read(buffer, buffer_u16);
            var proto_guid = buffer_read(buffer, buffer_get_datatype(version));
            proto_guid_set(mesh, index, proto_guid);
            
            if (version >= DataVersions.MESH_REFLECTION_DATA) {
                var name = buffer_read(buffer, buffer_string);
                var path = buffer_read(buffer, buffer_string);
                var submesh = new MeshSubmesh(name);
                
                var blength = buffer_read(buffer, buffer_u32); 
                if (blength > 0) {
                    submesh.buffer = buffer_read_buffer(buffer, blength);
                    submesh.internalSetVertexBuffer();
                }
                
                var blength = buffer_read(buffer, buffer_u32);
                if (blength > 0) {
                    submesh.reflect_buffer = buffer_read_buffer(buffer, blength);
                    submesh.internalSetReflectVertexBuffer();
                }
            } else {
                var blength = buffer_read(buffer, buffer_u32);
                var name = buffer_read(buffer, buffer_string);
                if (version >= DataVersions.EVEN_MORE_MESH_METADATA) {
                    var path = buffer_read(buffer, buffer_string);
                } else {
                    path = "";
                }
                
                var submesh = new MeshSubmesh(name);
                submesh.buffer = buffer_read_buffer(buffer, blength);
                submesh.path = path;
            }
            submesh.proto_guid = proto_guid;
            submesh.owner = mesh;
            ds_list_add(mesh.submeshes, submesh);
        }
        
        mesh.xmin = buffer_read(buffer, buffer_f32);
        mesh.ymin = buffer_read(buffer, buffer_f32);
        mesh.zmin = buffer_read(buffer, buffer_f32);
        mesh.xmax = buffer_read(buffer, buffer_f32);
        mesh.ymax = buffer_read(buffer, buffer_f32);
        mesh.zmax = buffer_read(buffer, buffer_f32);
        
        if (version >= DataVersions.EVEN_MORE_MESH_METADATA) {
            if (version >= DataVersions.REMOVE_MESH_TEX_SCALE) {
            } else {
                buffer_read(buffer, buffer_f32);
            }
        }
        
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var zz = buffer_read(buffer, buffer_u16);
        
        var asset_flags = array_create(xx);
        for (var i = 0; i < xx; i++) {
            asset_flags[i] = array_create(yy);
            for (var j = 0; j < yy; j++) {
                asset_flags[i][j] = array_create(zz);
                for (var k = 0; k < zz; k++) {
                    if (version >= DataVersions.UNIFIED_FLAGS) {
                        asset_flags[i][j][k] = buffer_read(buffer, buffer_flag);
                    } else {
                        asset_flags[i][j][k] = buffer_read(buffer, buffer_u32);
                    }
               }
           }
        }
        
        mesh.asset_flags = asset_flags;
        
        if (version >= DataVersions.UNIFIED_FLAGS) {
            
        } else {
            mesh.flags = buffer_read(buffer, buffer_u32);
        }
        
        if (version >= DataVersions.MESH_MATERIALS) {
            mesh.tex_base = buffer_read(buffer, buffer_datatype);
            mesh.tex_ambient = buffer_read(buffer, buffer_datatype);
            mesh.tex_specular_color = buffer_read(buffer, buffer_datatype);
            mesh.tex_specular_highlight = buffer_read(buffer, buffer_datatype);
            mesh.tex_alpha = buffer_read(buffer, buffer_datatype);
            mesh.tex_bump = buffer_read(buffer, buffer_datatype);
            mesh.tex_displacement = buffer_read(buffer, buffer_datatype);
            mesh.tex_stencil = buffer_read(buffer, buffer_datatype);
        }
        
        // flags are saved in save_generic
        
        switch (mesh.type) {
            case MeshTypes.RAW: serialize_load_mesh_raw(mesh); break;
            case MeshTypes.SMF: serialize_load_mesh_smf(mesh); break;
        }
    }
}