event_inherited();

// inherited
save_script = serialize_save_entity_effect_com_point_light;
load_script = serialize_load_entity_effect_com_point_light;
render = render_effect_light_point;
sprite = spr_light_point;
light_type = LightTypes.POINT;

// specific
light_x = 0;
light_y = 0;
light_z = 0;
light_colour = c_white;
light_radius = 255;