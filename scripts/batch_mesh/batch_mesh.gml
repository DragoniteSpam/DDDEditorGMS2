function batch_mesh(vbuff, reflect, mesh, entity) {
    try {
        var data = guid_get(mesh.mesh); // lol
    } catch (e) {
        show_message("entity not found - " + entity);
        throw e;
    }
    
    // smf meshes won't be batched, please
    if (!data || data.type == MeshTypes.SMF) return;
    
    var raw = mesh.GetBuffer();
    if (!raw) return;
    
    var xx = mesh.xx * TILE_WIDTH;
    var yy = mesh.yy * TILE_HEIGHT;
    var zz = mesh.zz * TILE_DEPTH;
    var transform = matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1);
    __batch_mesh_general(raw, vbuff, transform);
    
    raw = mesh.GetReflectBuffer();
    if (!raw || !reflect) return;
    
    __batch_mesh_general(raw, reflect, transform);
}

function batch_mesh_autotile(vbuff, reflect, mesh_autotile) {
    throw "batch_mesh_autotile still uses the old hard-coded vertex size of 36";
    var mapping = get_index_from_autotile_mask(mesh_autotile.terrain_id);
    
    var at = guid_get(mesh_autotile.autotile_id);
    if (!at) return;
    
    var xx = mesh_autotile.xx * TILE_WIDTH;
    var yy = mesh_autotile.yy * TILE_HEIGHT;
    var zz = mesh_autotile.zz * TILE_DEPTH;
    var transform = matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1);
    __batch_mesh_general(at.layers[mesh_autotile.terrain_type].tiles[mapping].buffer, vbuff, transform);
    if (reflect) __batch_mesh_general(at.layers[mesh_autotile.terrain_type].tiles[mapping].buffer, reflect, transform);
}

function __batch_mesh_general(source, destination, matrix) {
    static vertex = new Vertex();
    buffer_seek(source, buffer_seek_start, 0);
    
    while (buffer_tell(source) < buffer_get_size(source)) {
        var npx = buffer_read(source, buffer_f32);
        var npy = buffer_read(source, buffer_f32);
        var npz = buffer_read(source, buffer_f32);
        var transformed = matrix_transform_vertex(matrix, npx, npy, npz);
        vertex.position.x = transformed[0];
        vertex.position.y = transformed[1];
        vertex.position.z = transformed[2];
        vertex.normal.x = buffer_read(source, buffer_f32);
        vertex.normal.y = buffer_read(source, buffer_f32);
        vertex.normal.z = buffer_read(source, buffer_f32);
        vertex.tex.x = buffer_read(source, buffer_f32);
        vertex.tex.y = buffer_read(source, buffer_f32);
        vertex.color = buffer_read(source, buffer_u32);
        
        vertex.tangent.x = buffer_read(source, buffer_f32);
        vertex.tangent.y = buffer_read(source, buffer_f32);
        vertex.tangent.z = buffer_read(source, buffer_f32);
        vertex.normal.x = buffer_read(source, buffer_f32);
        vertex.normal.y = buffer_read(source, buffer_f32);
        vertex.normal.z = buffer_read(source, buffer_f32);
        vertex.barycentric.x = buffer_read(source, buffer_f32);
        vertex.barycentric.y = buffer_read(source, buffer_f32);
        vertex.barycentric.z = buffer_read(source, buffer_f32);
        
        var alpha = vertex.color >> 24;
        var color = vertex.color & 0xffffff;
        
        /// @todo transform tangent and bitangent
        
        vertex_point_complete(destination,
            vertex.position.x, vertex.position.y, vertex.position.z,
            vertex.normal.x, vertex.normal.y, vertex.normal.z,
            vertex.tex.x, vertex.tex.y, color, alpha
        );
    }
}