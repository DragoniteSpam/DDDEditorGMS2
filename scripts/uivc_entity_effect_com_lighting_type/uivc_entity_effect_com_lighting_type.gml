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
        if (effect.com_light && effect.com_light.light_type != radio.value) {
            instance_activate_object(effect.com_light);
            instance_destroy(effect.com_light);
            effect.com_light = noone;
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
    base_dialog.el_spot_cutoff.enabled = false;
    
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
                    effect.com_light = new ComponentDirectionalLight(effect);
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
                    effect.com_light = new ComponentPointLight(effect);
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
            base_dialog.el_spot_cutoff.enabled = true;
            
            for (var i = 0; i < ds_list_size(list); i++) {
                var effect = list[| i];
                if (!effect.com_light) {
                    effect.com_light = new ComponentSpotLight(effect);
                }
            }
            
            ui_input_set_value(base_dialog.el_spot_x, string(single ? first.com_light.light_dx : "-"));
            ui_input_set_value(base_dialog.el_spot_y, string(single ? first.com_light.light_dy : "-"));
            ui_input_set_value(base_dialog.el_spot_z, string(single ? first.com_light.light_dz : "-"));
            ui_input_set_value(base_dialog.el_spot_radius, string(single ? first.com_light.light_radius : "-"));
            ui_input_set_value(base_dialog.el_spot_cutoff, string(single ? first.com_light.light_cutoff : "-"));
            break;
    }
    
    for (var i = 0; i < ds_list_size(list); i++) {
        var effect = list[| i];
        if (array_search(map_contents.active_lights, effect.REFID) == -1) {
            for (var j = 0; j < MAX_LIGHTS; j++) {
                if (!refid_get(map_contents.active_lights[j])) {
                    map_contents.active_lights[@ j] = effect.REFID;
                    break;
                }
            }
        }
    }
}