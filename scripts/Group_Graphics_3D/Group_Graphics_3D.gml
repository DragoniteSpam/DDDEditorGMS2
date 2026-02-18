function graphics_add_gizmo(mesh, matrix, use_gizmo) {
    if (!use_gizmo || Settings.view.gizmos) {
        ds_queue_enqueue(Stuff.unlit_meshes, [mesh, matrix]);
    }
}

function graphics_set_lighting(shader) {
    // this will need to be modified if / when it gets added to the terrain editor
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    var light_enabled = Settings.view.lighting && map.light_enabled;
    
    shader_set(shader);
    var light_data = array_create(MAX_LIGHTS * 12);
    array_clear(light_data, 0);
    var ambient = light_enabled ? map.light_ambient_colour : c_white;
    
    var n = 0;
    for (var i = 0; i < MAX_LIGHTS; i++) {
        var effect = refid_get(map.lights[i]);
        if (!effect) continue;
        var data = effect.com_light;
        if (!data) continue;
        var index = n++ * 12;
        // common value
        light_data[index + 3] = data.type;
        light_data[index + 8] = (data.light_colour & 0x0000ff) / 0xff;
        light_data[index + 9] = ((data.light_colour & 0x00ff00) >> 8) / 0xff;
        light_data[index + 10] = ((data.light_colour & 0xff0000) >> 16) / 0xff;
        // specific to each type
        switch (data.type) {
            case LightTypes.DIRECTIONAL:
                light_data[index + 0] = data.light_dx;
                light_data[index + 1] = data.light_dy;
                light_data[index + 2] = data.light_dz;
                break;
            case LightTypes.POINT:
                light_data[index + 0] = (effect.xx + effect.off_xx) * TILE_WIDTH;
                light_data[index + 1] = (effect.yy + effect.off_yy) * TILE_HEIGHT;
                light_data[index + 2] = (effect.zz + effect.off_zz) * TILE_DEPTH;
                light_data[index + 7] = data.light_radius;
                break;
            case LightTypes.SPOT:
                light_data[index + 0] = (effect.xx + effect.off_xx) * TILE_WIDTH;
                light_data[index + 1] = (effect.yy + effect.off_yy) * TILE_HEIGHT;
                light_data[index + 2] = (effect.zz + effect.off_zz) * TILE_DEPTH;
                // 3 is type
                light_data[index + 4] = data.light_dx;
                light_data[index + 5] = data.light_dy;
                light_data[index + 6] = data.light_dz;
                light_data[index + 7] = data.light_radius;
                // 8 is r
                // 9 is g
                // 10 is b
                light_data[index + 11] = dcos(data.light_cutoff_outer);
                break;
        }
    }
    
    shader_set_uniform_f(shader_get_uniform(shader, "lightAmbientColor"), (ambient & 0x0000ff) / 0xff, ((ambient & 0x00ff00) >> 8) / 0xff, ((ambient & 0xff0000) >> 16) / 0xff);
    shader_set_uniform_f_array(shader_get_uniform(shader, "lightData"), light_data);
    
    shader_set_uniform_f(shader_get_uniform(shader, "fogStrength"), (Settings.view.lighting && map.fog_enabled) ? 1 : 0);
    shader_set_uniform_f(shader_get_uniform(shader, "fogStart"), map.fog_start);
    shader_set_uniform_f(shader_get_uniform(shader, "fogEnd"), map.fog_end);
    shader_set_uniform_f(shader_get_uniform(shader, "fogColor"), (map.fog_colour & 0x0000ff) / 0xff, ((map.fog_colour & 0x00ff00) >> 8) / 0xff, ((map.fog_colour & 0xff0000) >> 16) / 0xff);
}

function graphics_set_material(material_content = undefined) {
    // calling this function with no parameter will reset the material values
    var cr = material_content ? (colour_get_red(material_content.col_diffuse) / 0xff) : 1;
    var cg = material_content ? (colour_get_green(material_content.col_diffuse) / 0xff) : 1;
    var cb = material_content ? (colour_get_blue(material_content.col_diffuse) / 0xff) : 1;
    var ca = material_content ? material_content.alpha : 1;
    
    var shader = shader_current();
    shader_set_uniform_f(shader_get_uniform(shader, "u_MaterialColor"), cr, cg, cb, ca);
}