event_inherited();

// inherited
save_script = serialize_save_entity_effect_directional_light;
load_script = serialize_load_entity_effect_directional_light;

name = "Directional Light";
etype = ETypes.ENTITY_EFFECT_DIRECTIONAL_LIGHT;
etype_flags = ETypeFlags.ENTITY_EFFECT;
render = render_effect_light_directional;
sprite = spr_light_direction;
light_type = LightTypes.DIRECTIONAL;
on_add = entity_effect_add_light;
on_delete = entity_effect_delete_light;
exist_in_map = false;

// specific
light_x = 0;
light_y = 0;
light_z = 0;
light_dx = 0;
light_dy = 0;
light_dz = -1;
light_colour = c_white;
// not used for directional lights, but they do affect the clickable area
light_radius = 32;

var map = Stuff.map.active_map;
var map_contents = map.contents;

var found = false;
for (var i = 0; i < MAX_LIGHTS; i++) {
    if (!refid_get(map_contents.active_lights[i])) {
        map_contents.active_lights[i] = REFID;
        found = true;
        break;
    }
}

if (!found && (ds_list_empty(Stuff.dialogs) || (ds_list_top(Stuff.dialogs).dialog_flags & DialogFlags.IS_DUPLICATE_WARNING) == 0)) {
    (dialog_create_notice(noone, string(MAX_LIGHTS) + " are already visible in the current map. If you want to see the effects of this one, you need to enable it in place of an active one.")).dialog_flags = DialogFlags.IS_DUPLICATE_WARNING;
}