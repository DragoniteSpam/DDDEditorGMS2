event_inherited();

// inherited
save_script = serialize_save_entity_effect_com_directional_light;
load_script = serialize_load_entity_effect_com_directional_light;
render = render_effect_light_direction;
sprite = spr_light_direction;
light_type = LightTypes.DIRECTIONAL;

// specific
light_x = 0;
light_y = 0;
light_z = 0;
light_dx = 0;
light_dy = 0;
light_dz = -1;
light_colour = c_white;
light_radius = 255;