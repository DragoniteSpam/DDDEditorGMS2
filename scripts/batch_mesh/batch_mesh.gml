function batch_mesh(vbuff, reflect, mesh) {
    var data = guid_get(mesh.mesh); // lol
    
    // smf meshes won't be batched, please
    if (data && data.type == MeshTypes.SMF) return;
    
    var xx = mesh.xx * TILE_WIDTH;
    var yy = mesh.yy * TILE_HEIGHT;
    var zz = mesh.zz * TILE_DEPTH;
    
    #region upright
    // if no valid mesh is found, use the big ol' ? instead
    var raw = mesh.GetBuffer();
    if (!raw) raw = Stuff.graphics.mesh_missing_data;
    buffer_seek(raw, buffer_seek_start, 0);
    
    var vc = 0;
    
    var tri/*:Triangle*/ = new Triangle();
    while (buffer_tell(raw) < buffer_get_size(raw)) {
        // script arguments are parsed backwards and i don't think there's a way to
        // turn that off, and in any case it's a better idea to just fetch the
        // values first and *then* pass them all to the script. it's quite annoying.
        var npx = buffer_read(raw, buffer_f32);
        var npy = buffer_read(raw, buffer_f32);
        var npz = buffer_read(raw, buffer_f32);
        var transformed = transform_entity_point(mesh, npx, npy, npz);
        var vertex/*:Vertex*/ = tri.vertex[vc];
        vertex.position.x = transformed[0];
        vertex.position.y = transformed[1];
        vertex.position.z = transformed[2];
        vertex.normal.x = buffer_read(raw, buffer_f32);
        vertex.normal.y = buffer_read(raw, buffer_f32);
        vertex.normal.z = buffer_read(raw, buffer_f32);
        vertex.tex.x = buffer_read(raw, buffer_f32);
        vertex.tex.y = buffer_read(raw, buffer_f32);
        vertex.color = buffer_read(raw, buffer_u32);
        
        var alpha = vertex.color >> 24;
        var color = vertex.color & 0xffffff;
        
        if (vbuff) {
            vertex_point_complete(vbuff,
                vertex.position.x, vertex.position.y, vertex.position.z,
                vertex.normal.x, vertex.normal.y, vertex.normal.z,
                vertex.tex.x, vertex.tex.y, color, alpha
            );
        }
        
        vc = ++vc % 3;
    }
    
    buffer_seek(raw, buffer_seek_start, 0);
    #endregion
    
    if (!reflect) return;
    
    #region reflected
    // if no valid mesh is found, use the big ol' ? instead
    raw = mesh.GetReflectBuffer();
    if (!raw) return;
    buffer_seek(raw, buffer_seek_start, 0);
    
    tri = new Triangle();
    
    while (buffer_tell(raw) < buffer_get_size(raw)) {
        // script arguments are parsed backwards and i don't think there's a way to
        // turn that off, and in any case it's a better idea to just fetch the
        // values first and *then* pass them all to the script. it's quite annoying.
        var npx = buffer_read(raw, buffer_f32);
        var npy = buffer_read(raw, buffer_f32);
        var npz = buffer_read(raw, buffer_f32);
        var transformed = transform_entity_point_reflected(mesh, npx, npy, npz);
        var vertex/*:Vertex*/ = tri.vertex[vc];
        vertex.position.x = transformed[0];
        vertex.position.y = transformed[1];
        vertex.position.z = transformed[2];
        vertex.normal.x = buffer_read(raw, buffer_f32);
        vertex.normal.y = buffer_read(raw, buffer_f32);
        vertex.normal.z = buffer_read(raw, buffer_f32);
        vertex.tex.x = buffer_read(raw, buffer_f32);
        vertex.tex.y = buffer_read(raw, buffer_f32);
        vertex.color = buffer_read(raw, buffer_u32);
        
        var alpha = vertex.color >> 24;
        var color = vertex.color & 0xffffff;
        
        if (reflect) {
            vertex_point_complete(reflect,
                vertex.position.x, vertex.position.y, vertex.position.z,
                vertex.normal.x, vertex.normal.y, vertex.normal.z,
                vertex.tex.x, vertex.tex.y, color, alpha
            );
        }
        
        vc = ++vc % 3;
    }
    
    buffer_seek(raw, buffer_seek_start, 0);
    #endregion
}