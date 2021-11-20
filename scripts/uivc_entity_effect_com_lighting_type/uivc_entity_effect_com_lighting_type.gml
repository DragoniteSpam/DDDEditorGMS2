function uivc_entity_effect_com_lighting_type(radio) {
    var base_dialog = radio.root.root;
    var list = Stuff.map.selected_entities;
    // it doesn't actually matter if more than one effect entities are selected or not
    // here because they'll all have the same parameters after you set the type anyway,
    // but i don't want people to forget that they have more than one thing selected
    var single = (ds_list_size(list) == 1);
    var first = list[| 0];
    
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    // reset everything (but if an effect has the same light compoment as the type to be added, keep it)
    for (var i = 0; i < ds_list_size(list); i++) {
        var effect = list[| i];
        if (effect.com_light.type != radio.value) {
            effect.com_light = undefined;
        }
    }
    
    base_dialog.el_color.enabled = false;
    base_dialog.el_dir_x.enabled = false;
    base_dialog.el_dir_y.enabled = false;
    base_dialog.el_dir_z.enabled = false;
    base_dialog.el_script.enabled = false;
    base_dialog.el_point_radius.enabled = false;
    base_dialog.el_spot_x.enabled = false;
    base_dialog.el_spot_y.enabled = false;
    base_dialog.el_spot_z.enabled = false;
    base_dialog.el_spot_radius.enabled = false;
    base_dialog.el_spot_cutoff_outer.enabled = false;
    base_dialog.el_spot_cutoff_inner.enabled = false;
    
    switch (radio.value) {
        case LightTypes.NONE:
            break;
        case LightTypes.DIRECTIONAL:
            base_dialog.el_color.enabled = true;
            base_dialog.el_dir_x.enabled = true;
            base_dialog.el_dir_y.enabled = true;
            base_dialog.el_dir_z.enabled = true;
            base_dialog.el_script.enabled = true;
            
            for (var i = 0; i < ds_list_size(list); i++) {
                var effect = list[| i];
                if (!effect.com_light) {
                    effect.com_light = new ComponentDirectionalLight(effect, undefined);
                }
            }
            
            base_dialog.el_color.value = first.com_light.light_colour;
            ui_input_set_value(base_dialog.el_dir_x, string(single ? first.com_light.light_dx : "-"));
            ui_input_set_value(base_dialog.el_dir_y, string(single ? first.com_light.light_dy : "-"));
            ui_input_set_value(base_dialog.el_dir_z, string(single ? first.com_light.light_dz : "-"));
            break;
        case LightTypes.POINT:
            base_dialog.el_color.enabled = true;
            base_dialog.el_script.enabled = true;
            base_dialog.el_point_radius.enabled = true;
            
            for (var i = 0; i < ds_list_size(list); i++) {
                var effect = list[| i];
                if (!effect.com_light) {
                    effect.com_light = new ComponentPointLight(effect, undefined);
                }
            }
            
            base_dialog.el_color.value = first.com_light.light_colour;
            ui_input_set_value(base_dialog.el_point_radius, string(single ? first.com_light.light_radius : "-"));
            break;
        case LightTypes.SPOT:
            base_dialog.el_color.enabled = true;
            base_dialog.el_script.enabled = true;
            base_dialog.el_spot_x.enabled = true;
            base_dialog.el_spot_y.enabled = true;
            base_dialog.el_spot_z.enabled = true;
            base_dialog.el_spot_radius.enabled = true;
            base_dialog.el_spot_cutoff_outer.enabled = true;
            base_dialog.el_spot_cutoff_inner.enabled = true;
            
            for (var i = 0; i < ds_list_size(list); i++) {
                var effect = list[| i];
                if (!effect.com_light) {
                    effect.com_light = new ComponentSpotLight(effect, undefined);
                }
            }
            
            ui_input_set_value(base_dialog.el_spot_x, string(single ? first.com_light.light_dx : "-"));
            ui_input_set_value(base_dialog.el_spot_y, string(single ? first.com_light.light_dy : "-"));
            ui_input_set_value(base_dialog.el_spot_z, string(single ? first.com_light.light_dz : "-"));
            ui_input_set_value(base_dialog.el_spot_radius, string(single ? first.com_light.light_radius : "-"));
            ui_input_set_value(base_dialog.el_spot_cutoff_outer, string(single ? first.com_light.light_cutoff_outer : "-"));
            ui_input_set_value(base_dialog.el_spot_cutoff_inner, string(single ? first.com_light.light_cutoff_inner : "-"));
            break;
    }
    
    for (var i = 0; i < ds_list_size(list); i++) {
        var effect = list[| i];
        if (array_search(map.lights, effect.REFID) == -1) {
            for (var j = 0; j < MAX_LIGHTS; j++) {
                if (!refid_get(map.lights[j])) {
                    map.lights[@ j] = effect.REFID;
                    break;
                }
            }
        }
    }
}