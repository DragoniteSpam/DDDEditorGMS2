function render_mesh_raw(entity) {
    var mesh = guid_get(entity.mesh);
    
    transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
    transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    
    if (Settings.view.entities) {
        var tex = entity_mesh_get_texture(entity);
        vertex_submit(entity_mesh_get_vbuffer(entity), pr_trianglelist, tex);
    }
    
    if (Settings.view.wireframe) {
        vertex_submit(entity_mesh_get_wbuffer(entity), pr_linelist, -1);
    }
    
    if (Stuff.map.active_map.reflections_enabled) {
        var water = Stuff.map.active_map.water_level;
        
        if (Settings.view.entities) {
            var reflect = entity_mesh_get_reflect_vbuffer(entity);
            if (reflect) {
                var offset = (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH;
                transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
                transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
                transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, offset, 0, 0, 0, 1, 1, 1);
                vertex_submit(reflect, pr_trianglelist, tex);
            }
        }
        
        if (Settings.view.wireframe) {
            var reflect = entity_mesh_get_reflect_wbuffer(entity);
            if (reflect) {
                var offset = (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH;
                transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
                transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
                transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, offset, 0, 0, 0, 1, 1, 1);
                vertex_submit(reflect, pr_trianglelist, tex);
            }
        }
    }
    
    transform_reset();
}