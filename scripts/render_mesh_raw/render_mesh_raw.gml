function render_mesh_raw(entity) {
    var mesh = guid_get(entity.mesh);
    
    transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
    transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    
    var tex = entity.GetTexture();
    
    if (Settings.view.entities) {
        vertex_submit(entity.GetVertexBuffer(), pr_trianglelist, tex);
    }
    
    if (Settings.view.wireframe) {
        /// @wireframe
    }
    
    if (Stuff.map.active_map.reflections_enabled) {
        var water = Stuff.map.active_map.water_level;
        var offset = (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH;
        transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
        transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
        transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, offset, 0, 0, 0, 1, 1, 1);
        
        if (Settings.view.entities) {
            var reflect = entity.GetReflectVertexBuffer();
            if (reflect) {
                vertex_submit(reflect, pr_trianglelist, tex);
            }
        }
        
        if (Settings.view.wireframe) {
            /// @wireframe
        }
    }
    
    matrix_set(matrix_world, matrix_build_identity());
}