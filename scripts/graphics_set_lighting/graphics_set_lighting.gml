/// @param shader

var shader = argument0;
// this will need to be modified if / when it gets added to the terrain editor
var map = Stuff.map.active_map;
var map_contents = map.contents;

shader_set(shader);
shader_set_uniform_i(shader_get_uniform(shader, "lightEnabled"), Stuff.setting_view_lighting && map.light_enabled);
var light_data = array_create(MAX_LIGHTS * 12);
var n = 0;
for (var i = 0; i < MAX_LIGHTS; i++) {
    var effect = refid_get(map_contents.active_lights[| i]);
    if (!effect) {
        continue;
    }
    var data = effect.com_light;
    if (!data) {
        continue;
    }
    var index = n++ * 12;
    // common value
    light_data[index + 3] = data.light_type;
    light_data[index + 8] = (data.light_colour & 0x0000ff) / 0xff;
    light_data[index + 9] = ((data.light_colour & 0x00ff00) >> 8) / 0xff;
    light_data[index + 10] = ((data.light_colour & 0xff0000) >> 16) / 0xff;
    // specific to each type
    switch (data.light_type) {
        case LightTypes.DIRECTIONAL:
            light_data[index + 0] = data.light_dx;
            light_data[index + 1] = data.light_dy;
            light_data[index + 2] = data.light_dz;
            break;
        case LightTypes.POINT:
            light_data[index + 0] = (effect.xx + effect.off_xx + 0.5) * TILE_WIDTH;
            light_data[index + 1] = (effect.yy + effect.off_yy + 0.5) * TILE_HEIGHT;
            light_data[index + 2] = (effect.zz + effect.off_zz + 0.5) * TILE_DEPTH;
            light_data[index + 7] = data.light_radius;
            break;
        case LightTypes.SPOT:
            break;
    }
}
shader_set_uniform_i(shader_get_uniform(shader, "lightCount"), n);
shader_set_uniform_f(shader_get_uniform(shader, "lightBuckets"), Stuff.game_lighting_buckets);
shader_set_uniform_f(shader_get_uniform(shader, "lightAmbientColor"), (map.light_ambient_colour & 0x0000ff) / 0xff, ((map.light_ambient_colour & 0x00ff00) >> 8) / 0xff, ((map.light_ambient_colour & 0xff0000) >> 16) / 0xff);
shader_set_uniform_f_array(shader_get_uniform(shader, "lightData"), light_data);

shader_set_uniform_i(shader_get_uniform(shader, "fogEnabled"), map.fog_enabled);
shader_set_uniform_f(shader_get_uniform(shader, "fogStart"), map.fog_start);
shader_set_uniform_f(shader_get_uniform(shader, "fogEnd"), map.fog_end);
shader_set_uniform_f(shader_get_uniform(shader, "fogColor"), (map.fog_colour & 0x0000ff) / 0xff, ((map.fog_colour & 0x00ff00) >> 8) / 0xff, ((map.fog_colour & 0xff0000) >> 16) / 0xff);