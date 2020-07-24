/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_u32, SerializeThings.MESHES);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_meshes = ds_list_size(Stuff.all_meshes);
buffer_write(buffer, buffer_u32, n_meshes);

for (var i = 0; i < n_meshes; i++) {
    var mesh = Stuff.all_meshes[| i];
    
    serialize_save_generic(buffer, mesh);
    
    buffer_write(buffer, buffer_u8, mesh.type);
    
    var list_proto_guids = ds_map_to_list(mesh.proto_guids);
    var n_submeshes = ds_list_size(mesh.submeshes);
    buffer_write(buffer, buffer_u16, n_submeshes);
    for (var j = 0; j < n_submeshes; j++) {
        var submesh = mesh.submeshes[| j];
        var index = mesh.proto_guids[? list_proto_guids[| j]];
        buffer_write(buffer, buffer_u16, index);
        buffer_write(buffer, buffer_datatype, list_proto_guids[| j]);
        buffer_write(buffer, buffer_u32, buffer_get_size(submesh.buffer));
        buffer_write(buffer, buffer_string, submesh.name);
        buffer_write(buffer, buffer_string, submesh.path);
        buffer_write_buffer(buffer, submesh.buffer);
        // don't bother saving the wireframe buffers - we need to re-create the collision
        // shape as well, so we might as well recreate the wireframe at the same time =/
    }
    ds_list_destroy(list_proto_guids);
    
    buffer_write(buffer, buffer_f32, mesh.xmin);
    buffer_write(buffer, buffer_f32, mesh.ymin);
    buffer_write(buffer, buffer_f32, mesh.zmin);
    buffer_write(buffer, buffer_f32, mesh.xmax);
    buffer_write(buffer, buffer_f32, mesh.ymax);
    buffer_write(buffer, buffer_f32, mesh.zmax);
    
    buffer_write(buffer, buffer_f32, mesh.texture_scale);
    
    var xx = ds_grid_width(mesh.collision_flags);
    var yy = ds_grid_height(mesh.collision_flags);
    var zz = -1;
    buffer_write(buffer, buffer_u16, xx);
    buffer_write(buffer, buffer_u16, yy);
    var addr_zz = buffer_tell(buffer);
    buffer_write(buffer, buffer_u16, 0);
    for (var j = 0; j < xx; j++) {
        for (var k = 0; k < yy; k++) {
            var slice = mesh.collision_flags[# j, k];
            if (zz == -1) {
                zz = array_length_1d(slice);
                buffer_poke(buffer, addr_zz, buffer_u16, zz);
            }
            for (var l = 0; l < zz; l++) {
                buffer_write(buffer, buffer_u32, slice[@ l]);
            }
        }
    }
    
    buffer_write(buffer, buffer_u32, mesh.marker);
    
    buffer_write(buffer, buffer_datatype, mesh.tex_base);
    buffer_write(buffer, buffer_datatype, mesh.tex_ambient);
    buffer_write(buffer, buffer_datatype, mesh.tex_specular_color);
    buffer_write(buffer, buffer_datatype, mesh.tex_specular_highlight);
    buffer_write(buffer, buffer_datatype, mesh.tex_alpha);
    buffer_write(buffer, buffer_datatype, mesh.tex_bump);
    buffer_write(buffer, buffer_datatype, mesh.tex_displacement);
    buffer_write(buffer, buffer_datatype, mesh.tex_stencil);
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);