function dialog_create_entity_effect_com_lighting(root) {
    var list = Stuff.map.selected_entities;
    var single = (ds_list_size(list) == 1);
    var first = list[| 0];
    var com_light = first ? first.com_light : noone;
    var com_dir = (com_light && com_light.type == LightTypes.DIRECTIONAL) ? com_light : noone;
    var com_point = (com_light && com_light.type == LightTypes.POINT) ? com_light : noone;
    var com_spot = (com_light && com_light.type == LightTypes.SPOT) ? com_light : noone;
    
    var dw = 400;
    var dh = 576;
    
    var dg = dialog_create(dw, dh, "Effect Component: Lighting", dialog_default, dialog_destroy, root);
    
    var spacing = 16;
    var columns = 1;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = spacing;
    
    var vx1 = dw / (columns * 2) - 32;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2);
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_type = create_radio_array(col1_x, yy, "Type", ew, eh, uivc_entity_effect_com_lighting_type, (single ? (com_light ? com_light.type : 0) : -1), dg);
    create_radio_array_options(el_type, ["None", "Directional", "Point", "Spot (Cone)"]);
    el_type.tooltip = "The lighting data to be attached to this effect.\n - Directional lights are infinite an illuminate everything\n - Point lights illuminate everything within a radius, fading out smoothly\n - Spot lights can be thought of as a combination of point and directional lights, illuminating everything in a certain direction";
    
    yy += el_type.GetHeight() + spacing;
    
    var el_color = create_color_picker(col1_x, yy, "Light color:", ew, eh, function(picker) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_colour = picker.value;
        }
    }, com_light ? com_light.light_colour : c_white, vx1, vy1, vx2, vy2, dg);
    el_color.tooltip = "The color of the light. White is fine, in most cases. Black makes no sense.";
    el_color.enabled = (single && com_light && com_light.type != LightTypes.NONE);
    dg.el_color = el_color;
    
    yy += el_color.height + spacing;
    
    var el_script = create_input(col1_x, yy, "Script call:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.script_call = input.value;
        }
    }, com_light ? com_light.script_call : "", "funciton name", validate_string_internal_name_or_empty, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_script.tooltip = "If you want this light component to run any code, call it here. This should correspond to a set of Lua functions defined by the Common Effect Code suffixed with \"Create\", \"Update\" and \"Destroy\". See the sample code.";
    el_script.enabled = (com_light && com_light.type != LightTypes.NONE);
    dg.el_script = el_script;
    
    yy += el_script.height + spacing;
    
    var yy_options = yy;
    
    #region directional lights
    yy = yy_options;
    
    var el_dir_x = create_input(col1_x, yy, "X:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_dx = real(input.value);
        
            if (point_distance_3d(0, 0, 0, effect.com_light.light_dx, effect.com_light.light_dy, effect.com_light.light_dz) == 0) {
                effect.com_light.light_dz = -1;
            }
        }
    }, com_dir ? string(com_dir.light_dx) : "", "float", validate_double, -1, 1, 4, vx1, vy1, vx2, vy2, dg);
    el_dir_x.tooltip = "The X component of the light direction vector. If the total magnitude of the vector is zero, it will be ser to (0, 0, -1) instead.";
    el_dir_x.enabled = (single && com_light && com_light.type == LightTypes.DIRECTIONAL);
    dg.el_dir_x = el_dir_x;
    
    yy += el_dir_x.height + spacing;
    
    var el_dir_y = create_input(col1_x, yy, "Y:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_dy = real(input.value);
        
            if (point_distance_3d(0, 0, 0, effect.com_light.light_dx, effect.com_light.light_dy, effect.com_light.light_dz) == 0) {
                effect.com_light.light_dz = -1;
            }
        }
    }, com_dir ? string(com_dir.light_dy) : "", "float", validate_double, -1, 1, 4, vx1, vy1, vx2, vy2, dg);
    el_dir_y.tooltip = "The Y component of the light direction vector. If the total magnitude of the vector is zero, it will be ser to (0, 0, -1) instead.";
    el_dir_y.enabled = (single && com_light && com_light.type == LightTypes.DIRECTIONAL);
    dg.el_dir_y = el_dir_y;
    
    yy += el_dir_y.height + spacing;
    
    var el_dir_z = create_input(col1_x, yy, "Z:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_dz = real(input.value);
        
            if (point_distance_3d(0, 0, 0, effect.com_light.light_dx, effect.com_light.light_dy, effect.com_light.light_dz) == 0) {
                effect.com_light.light_dz = -1;
            }
        }
    }, com_dir ? string(com_dir.light_dz) : "", "float", validate_double, -1, 1, 4, vx1, vy1, vx2, vy2, dg);
    el_dir_z.tooltip = "The Z component of the light direction vector. If the total magnitude of the vector is zero, it will be ser to (0, 0, -1) instead.";
    el_dir_z.enabled = (single && com_light && com_light.type == LightTypes.DIRECTIONAL);
    dg.el_dir_z = el_dir_z;
    
    yy += el_dir_z.height + spacing;
    #endregion
    
    #region point lights
    yy = yy_options;
    
    var el_point_radius = create_input(col1_x, yy, "Radius:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_radius = real(input.value);
        }
    }, com_point ? string(com_point.light_radius) : "", "float", validate_double, 0.1, 0xffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_point_radius.tooltip = "The radius of the point light. A value between 100 and 1000 is normally fine. A value that's very small or very large doesn't make much sense, but will still work.";
    el_point_radius.enabled = (single && com_light && com_light.type == LightTypes.POINT);
    dg.el_point_radius = el_point_radius;
    
    yy += el_point_radius.height + spacing;
    #endregion
    
    #region spot lights
    yy = yy_options;
    
    var el_spot_x = create_input(col1_x, yy, "X direction:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_dx = real(input.value);
        }
    }, com_spot ? string(com_spot.light_dx) : "", "float", validate_double, -1, 1, 4, vx1, vy1, vx2, vy2, dg);
    el_spot_x.tooltip = "The X component of the light direction vector. If the total magnitude of the vector is zero, it will be ser to (0, 0, -1) instead.";
    el_spot_x.enabled = (single && com_light && com_light.type == LightTypes.SPOT);
    dg.el_spot_x = el_spot_x;
    
    yy += el_spot_x.height + spacing;
    
    var el_spot_y = create_input(col1_x, yy, "Y direction:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_dy = real(input.value);
        }
    }, com_spot ? string(com_spot.light_dy) : "", "float", validate_double, -1, 1, 4, vx1, vy1, vx2, vy2, dg);
    el_spot_y.tooltip = "The Y component of the light direction vector. If the total magnitude of the vector is zero, it will be ser to (0, 0, -1) instead.";
    el_spot_y.enabled = (single && com_light && com_light.type == LightTypes.SPOT);
    dg.el_spot_y = el_spot_y;
    
    yy += el_spot_y.height + spacing;
    
    var el_spot_z = create_input(col1_x, yy, "Z direction:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_dz = real(input.value);
        }
    }, com_spot ? string(com_spot.light_dz) : "", "float", validate_double, -1, 1, 4, vx1, vy1, vx2, vy2, dg);
    el_spot_z.tooltip = "The Z component of the light direction vector. If the total magnitude of the vector is zero, it will be ser to (0, 0, -1) instead.";
    el_spot_z.enabled = (single && com_light && com_light.type == LightTypes.SPOT);
    dg.el_spot_z = el_spot_z;
    
    yy += el_spot_z.height + spacing;
    
    var el_spot_radius = create_input(col1_x, yy, "Radius:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_radius = real(input.value);
        }
    }, com_spot ? string(com_spot.light_radius) : "", "float", validate_double, 0.1, 0xffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_spot_radius.tooltip = "The radius of the spot light. A value between 100 and 1000 is normally fine. A value that's very small or very large doesn't make much sense, but will still work.";
    el_spot_radius.enabled = (single && com_light && com_light.type == LightTypes.SPOT);
    dg.el_spot_radius = el_spot_radius;
    
    yy += el_spot_radius.height + spacing;
    
    var el_spot_cutoff_outer = create_input(col1_x, yy, "Outer Cone Angle:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_cutoff_outer = real(input.value);
        }
    }, com_spot ? string(com_spot.light_cutoff_outer) : "", "float", validate_double, 0.1, 80, 10, vx1, vy1, vx2, vy2, dg);
    el_spot_cutoff_outer.tooltip = "The outer angle of the cone. Only space inside the cone angle will be lit.";
    el_spot_cutoff_outer.enabled = (single && com_light && com_light.type == LightTypes.SPOT);
    dg.el_spot_cutoff_outer = el_spot_cutoff_outer;
    
    yy += el_spot_cutoff_outer.height + spacing;
    
    var el_spot_cutoff_inner = create_input(col1_x, yy, "Inner Cone Angle:", ew, eh, function(input) {
        var list = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light.light_cutoff_inner = real(input.value);
        }
    }, com_spot ? string(com_spot.light_cutoff_inner) : "", "float", validate_double, 0.1, 80, 10, vx1, vy1, vx2, vy2, dg);
    el_spot_cutoff_inner.tooltip = "The inner angle of the cone. Only space inside the cone angle will be lit.";
    el_spot_cutoff_inner.enabled = (single && com_light && com_light.type == LightTypes.SPOT);
    dg.el_spot_cutoff_inner = el_spot_cutoff_inner;
    
    yy += el_spot_cutoff_inner.height + spacing;
    #endregion
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_type,
        el_color,
        el_script,
        el_dir_x,
        el_dir_y,
        el_dir_z,
        el_point_radius,
        el_spot_x,
        el_spot_y,
        el_spot_z,
        el_spot_radius,
        el_spot_cutoff_outer,
        el_spot_cutoff_inner,
        el_confirm
    );
    
    return dg;
}