event_inherited();

// inherited
save_script = serialize_save_entity_effect_point_light;
load_script = serialize_load_entity_effect_point_light;

name = "Point Light";
etype = ETypes.ENTITY_EFFECT_POINT_LIGHT;
etype_flags = ETypeFlags.ENTITY_EFFECT;
render = render_effect_light_point;
sprite = spr_light_point;
light_type = LightTypes.POINT;

// specific
light_colour = c_white;
light_radius = 255;

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