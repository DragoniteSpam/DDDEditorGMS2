/// @param shader
function graphics_set_lighting_terrain(argument0) {

    var shader = argument0;
    var lights = Stuff.terrain.lights;

    shader_set(shader);
    var light_data = array_create(MAX_LIGHTS * 12);
    array_clear(light_data, 0);
    var ambient = Stuff.terrain.terrain_light_enabled ? Stuff.terrain.terrain_light_ambient : c_white;

    var n = 0;
    for (var i = 0; i < MAX_LIGHTS; i++) {
        var light = lights[i];
        if (!light) break;
    
        var index = n++ * 12;
        // common value
        light_data[index + 0] = light.x;
        light_data[index + 1] = light.y;
        light_data[index + 2] = light.z;
        light_data[index + 3] = light.type;
        light_data[index + 8] = (light.color & 0x0000ff) / 0xff;
        light_data[index + 9] = ((light.color & 0x00ff00) >> 8) / 0xff;
        light_data[index + 10] = ((light.color & 0xff0000) >> 16) / 0xff;
        // specific to each type
        switch (light.type) {
            case LightTypes.DIRECTIONAL: break;
            case LightTypes.POINT: light_data[index + 7] = light.radius; break;
            case LightTypes.SPOT: break;
        }
    }

    shader_set_uniform_f(shader_get_uniform(shader, "lightAmbientColor"), (ambient & 0x0000ff) / 0xff, ((ambient & 0x00ff00) >> 8) / 0xff, ((ambient & 0xff0000) >> 16) / 0xff);
    shader_set_uniform_f_array(shader_get_uniform(shader, "lightData"), light_data);

    shader_set_uniform_f(shader_get_uniform(shader, "fogStrength"), Stuff.terrain.terrain_fog_enabled ? 1 : 0);
    shader_set_uniform_f(shader_get_uniform(shader, "fogStart"), Stuff.terrain.terrain_fog_start);
    shader_set_uniform_f(shader_get_uniform(shader, "fogEnd"), Stuff.terrain.terrain_fog_end);
    shader_set_uniform_f(shader_get_uniform(shader, "fogColor"), (Stuff.terrain.terrain_fog_color & 0x0000ff) / 0xff, ((Stuff.terrain.terrain_fog_color & 0x00ff00) >> 8) / 0xff, ((Stuff.terrain.terrain_fog_color & 0xff0000) >> 16) / 0xff);


}
