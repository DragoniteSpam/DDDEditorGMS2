event_inherited();

save_script = serialize_save_entity_effect_com_spot_light;
load_script = serialize_load_entity_effect_com_spot_light;
render = render_effect_light_spot;
sprite = spr_light_point;
light_type = LightTypes.SPOT;
label_colour = c_orange;

// specific
light_colour = c_white;
light_radius = 255;
light_cutoff = 45;
light_dx = 0;
light_dy = 0;
light_dz = -1;