function uivc_terrain_light_select(list) {
    var mode = Stuff.terrain;
    var tab = mode.ui.t_lighting;
    
    var light = mode.lights[ui_list_selection(list)];
    tab.el_light_type.value = light.type;
    tab.el_light_color.value = light.color;
    
    switch (light.type) {
        case LightTypes.DIRECTIONAL:
            tab.el_dir_x.value = normalize(light.x, 0, 1, -0.5, 0.5);
            tab.el_dir_y.value = normalize(light.y, 0, 1, -0.5, 0.5);
            tab.el_dir_z.value = normalize(light.z, 0, 1, -0.5, 0.5);
            break;
        case LightTypes.POINT:
            ui_input_set_value(tab.el_point_x, light.x);
            ui_input_set_value(tab.el_point_y, light.y);
            ui_input_set_value(tab.el_point_z, light.z);
            ui_input_set_value(tab.el_point_radius, light.radius);
            break;
    }
    
    uivc_terrain_light_enable_by_type(list);
}