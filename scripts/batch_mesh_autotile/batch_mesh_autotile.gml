function batch_mesh_autotile(buffer, wire, mesh_autotile) {
    var mapping = global.at_map[$ mesh_autotile.terrain_id];
    
    var at = guid_get(mesh_autotile.autotile_id);
    var raw = at ? at.layers[mesh_autotile.terrain_type].tiles[mapping].buffer : Stuff.graphics.missing_autotile_raw;
    if (!raw) raw = Stuff.graphics.missing_autotile_raw;
    
    var xx = mesh_autotile.xx * TILE_WIDTH;
    var yy = mesh_autotile.yy * TILE_HEIGHT;
    var zz = mesh_autotile.zz * TILE_DEPTH;
    buffer_seek(raw, buffer_seek_start, 0);
    
    var vc = 0;
    
    var data/*:Triangle*/ = new Triangle();
    
    while (buffer_tell(raw) < buffer_get_size(raw)) {
        // script arguments are parsed backwards and i don't think there's a way to
        // turn that off, and in any case it's a better idea to just fetch the
        // values first and *then* pass them all to the script. it's quite annoying.
        var npx = buffer_read(raw, buffer_f32);
        var npy = buffer_read(raw, buffer_f32);
        var npz = buffer_read(raw, buffer_f32);
        var transformed = transform_entity_point(mesh_autotile, npx, npy, npz);
        var vertex/*:Vertex*/ = data.vertex[vc];
        vertex.position.x = transformed[vec3.xx];
        vertex.position.y = transformed[vec3.yy];
        vertex.position.z = transformed[vec3.zz];
        vertex.normal.x = buffer_read(raw, buffer_f32);
        vertex.normal.y = buffer_read(raw, buffer_f32);
        vertex.normal.z = buffer_read(raw, buffer_f32);
        vertex.tex.x = buffer_read(raw, buffer_f32);
        vertex.tex.y = buffer_read(raw, buffer_f32);
        vertex.color = buffer_read(raw, buffer_u32);
        vertex.extra = buffer_read(raw, buffer_u32);
        
        var alpha = vertex.color >> 24;
        var color = vertex.color & 0xffffff;
        
        if (buffer) {
            vertex_point_complete(buffer,
                vertex.position.x, vertex.position.y, vertex.position.z,
                vertex.normal.x, vertex.normal.y, vertex.normal.z,
                vertex.tex.x, vertex.tex.y, color, alpha
            );
        }
        
        vc = ++vc % 3;
        
        if (wire) {
            if (vc == 0) {
                var v1 = data.vertex[0];
                var v2 = data.vertex[1];
                var v3 = data.vertex[2];
                vertex_point_line(wire, v1.position.x, v1.position.y, v1.position.z, c_white, 1);
                vertex_point_line(wire, v2.position.x, v2.position.y, v2.position.z, c_white, 1);
                vertex_point_line(wire, v2.position.x, v2.position.y, v2.position.z, c_white, 1);
                vertex_point_line(wire, v3.position.x, v3.position.y, v3.position.z, c_white, 1);
                vertex_point_line(wire, v3.position.x, v3.position.y, v3.position.z, c_white, 1);
                vertex_point_line(wire, v1.position.x, v1.position.y, v1.position.z, c_white, 1);
            }
        }
    }
    
    return [buffer, wire];
}