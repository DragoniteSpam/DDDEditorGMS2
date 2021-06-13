function serialize_save_meshes(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.MESHES);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_meshes = array_length(Game.meshes);
    buffer_write(buffer, buffer_u32, n_meshes);
    
    for (var i = 0; i < n_meshes; i++) {
        var mesh = Game.meshes[i];
        
        serialize_save_generic(buffer, mesh);
        
        buffer_write(buffer, buffer_u8, mesh.type);
        
        var all_proto_guids = variable_struct_get_names(mesh.proto_guids);
        var n_submeshes = array_length(mesh.submeshes);
        buffer_write(buffer, buffer_u16, n_submeshes);
        for (var j = 0; j < n_submeshes; j++) {
            var submesh = mesh.submeshes[j];
            var index = mesh.proto_guids[$ all_proto_guids[j]];
            buffer_write(buffer, buffer_u16, index);
            buffer_write(buffer, buffer_datatype, all_proto_guids[j]);
            
            buffer_write(buffer, buffer_string, submesh.name);
            buffer_write(buffer, buffer_string, submesh.path);
            if (submesh.buffer) {
                buffer_write(buffer, buffer_u32, buffer_get_size(submesh.buffer));
                buffer_write_buffer(buffer, submesh.buffer);
            } else {
                buffer_write(buffer, buffer_u32, 0);
            }
            if (submesh.reflect_buffer) {
                buffer_write(buffer, buffer_u32, buffer_get_size(submesh.reflect_buffer));
                buffer_write_buffer(buffer, submesh.reflect_buffer);
            } else {
                buffer_write(buffer, buffer_u32, 0);
            }
            // don't bother saving the wireframe buffers - we need to re-create the collision
            // shape as well, so we might as well recreate the wireframe at the same time =/
        }
        
        buffer_write(buffer, buffer_f32, mesh.xmin);
        buffer_write(buffer, buffer_f32, mesh.ymin);
        buffer_write(buffer, buffer_f32, mesh.zmin);
        buffer_write(buffer, buffer_f32, mesh.xmax);
        buffer_write(buffer, buffer_f32, mesh.ymax);
        buffer_write(buffer, buffer_f32, mesh.zmax);
        
        var xx = mesh.xmax - mesh.xmin;
        var yy = mesh.ymax - mesh.ymin;
        var zz = mesh.zmax - mesh.zmin;
        buffer_write(buffer, buffer_u16, xx);
        buffer_write(buffer, buffer_u16, yy);
        buffer_write(buffer, buffer_u16, zz);
        for (var j = 0; j < xx; j++) {
            for (var k = 0; k < yy; k++) {
                for (var l = 0; l < zz; l++) {
                    buffer_write(buffer, buffer_flag, mesh.asset_flags[j][k][l]);
                }
            }
        }
        
        buffer_write(buffer, buffer_datatype, mesh.tex_base);
        buffer_write(buffer, buffer_datatype, mesh.tex_ambient);
        buffer_write(buffer, buffer_datatype, mesh.tex_specular_color);
        buffer_write(buffer, buffer_datatype, mesh.tex_specular_highlight);
        buffer_write(buffer, buffer_datatype, mesh.tex_alpha);
        buffer_write(buffer, buffer_datatype, mesh.tex_bump);
        buffer_write(buffer, buffer_datatype, mesh.tex_displacement);
        buffer_write(buffer, buffer_datatype, mesh.tex_stencil);
        
        buffer_write(buffer, buffer_f32, mesh.texture_scale);
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}