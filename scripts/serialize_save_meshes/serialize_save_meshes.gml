/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.MESHES);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_meshes = ds_list_size(Stuff.all_meshes);
buffer_write(buffer, buffer_u32, n_meshes);

for (var i = 0; i < n_meshes; i++) {
    var mesh = Stuff.all_meshes[| i];
    
    serialize_save_generic(buffer, mesh);
    
    buffer_write(buffer, buffer_u8, mesh.type);
    
    buffer_write(buffer, buffer_u32, buffer_get_size(mesh.buffer));
    buffer_write_buffer(buffer, mesh.buffer);
    // don't bother saving the wireframe buffer - we need to re-create the collision
    // shape as well, so we might as well recreate the wireframe at the same time =/
    
    buffer_write(buffer, buffer_f32, mesh.xmin);
    buffer_write(buffer, buffer_f32, mesh.ymin);
    buffer_write(buffer, buffer_f32, mesh.zmin);
    buffer_write(buffer, buffer_f32, mesh.xmax);
    buffer_write(buffer, buffer_f32, mesh.ymax);
    buffer_write(buffer, buffer_f32, mesh.zmax);
    
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
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);