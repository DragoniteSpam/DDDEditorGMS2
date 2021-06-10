function export_qma(fn) {
    var buffer = buffer_create(1024, buffer_grow, 1);
    
    var data = {
        version: 1,
    };
    
    buffer_write(buffer, buffer_string, json_stringify(data));
    
    var n_meshes = array_length(Game.meshes);
    var addr_count = buffer_tell(buffer);
    buffer_write(buffer, buffer_u32, 0);
    
    var count = 0;
    
    for (var i = 0; i < n_meshes; i++) {
        var mesh = Game.meshes[i];
        for (var j = 0; j < ds_list_size(mesh.submeshes); j++) {
            var submesh = mesh.submeshes[| j];
            var json = { 
                name: submesh.name,
                size: buffer_get_size(submesh.buffer),
            };
            buffer_write(buffer, buffer_string, json_stringify(json));
            buffer_write_buffer(buffer, submesh.buffer);
            
            count++;
        }
    }
    
    buffer_poke(buffer, addr_count, buffer_u32, count);
    buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
    buffer_delete(buffer);
}