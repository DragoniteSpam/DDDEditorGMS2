event_inherited();

save_script = serialize_save_entity_effect_com_directional_light;
load_script = serialize_load_entity_effect_com_directional_light;
render = render_effect_light_direction;
sprite = spr_light_direction;
light_type = LightTypes.DIRECTIONAL;

// specific
light_dx = -1;
light_dy = -1;
light_dz = -1;
light_colour = c_white;

instance_deactivate_object(id);