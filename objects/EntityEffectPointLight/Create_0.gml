event_inherited();

// inherited
save_script = serialize_save_entity_effect_point_light;
load_script = serialize_load_entity_effect_point_light;

name = "Point Light";
etype = ETypes.ENTITY_EFFECT_POINT_LIGHT;
etype_flags = ETypeFlags.ENTITY_EFFECT;
render = render_effect_light;

// specific
light_colour = c_white;
light_radius = 255;