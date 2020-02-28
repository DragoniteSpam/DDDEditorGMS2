event_inherited();

// inherited
save_script = serialize_save_entity_effect_directional_light;
load_script = serialize_load_entity_effect_directional_light;

name = "Directional Light";
etype = ETypes.ENTITY_EFFECT_DIRECTIONAL_LIGHT;
etype_flags = ETypeFlags.ENTITY_EFFECT;
render = render_effect_light_directional;
sprite = spr_light_direction;

// specific
light_colour = c_white;