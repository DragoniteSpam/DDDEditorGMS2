function render_mesh_smf(entity) {
    var mesh = guid_get(entity.mesh);
    
    transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
    transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    
    if (Settings.view.entities) {
        var vbuffer = entity.GetVertexBuffer();
        if (entity.animated) {
            var animation_index = entity.animation_index;
            var animation_type = entity.animation_type;
            var sample = smf_sample_create(vbuffer, animation_index, animation_type, current_time / 1000);
            smf_model_draw(vbuffer, sample);
        } else {
            smf_model_draw(vbuffer);
        }
    }
    
    if (Stuff.map.active_map.reflections_enabled) {
        var water = Stuff.map.active_map.water_level;
        
        if (Settings.view.entities) {
            var reflect = entity.GetReflectVertexBuffer();
            if (reflect) {
                var offset = (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH;
                transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
                transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
                transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, offset, 0, 0, 0, 1, 1, 1);
                if (entity.animated) {
                    var animation_index = entity.animation_index;
                    var animation_type = entity.animation_type;
                    var sample = smf_sample_create(reflect, animation_index, animation_type, current_time / 1000);
                    smf_model_draw(reflect, sample);
                } else {
                    smf_model_draw(reflect);
                }
            }
        }
    }
    
    shader_set(shd_ddd);
    transform_reset();
}