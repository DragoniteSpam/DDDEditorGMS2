function uivc_animation_layer_properties(root) {
    var selection = ui_list_selection(root.root.el_layers);
    
    if (selection + 1) {
        var timeline_layer = root.root.active_animation.layers[selection];
        var dw = 720;
        var dh = 480;
        
        var dg = dialog_create(dw, dh, "Layer Properties", undefined, undefined, root);
        dg.timeline_layer = timeline_layer;
        
        var columns = 2;
        var spacing = 16;
        var ew = dw / columns - spacing * 2;
        var eh = 24;
        
        var vx1 = ew / 3;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var col2_x = dw / 2;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy = 64;
        
        var el_name = create_input(16, yy, "Name:", ew, eh, function(input) {
            input.root.timeline_layer.name = input.value;
        }, timeline_layer.name, "text", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
        yy += el_name.height + spacing;
        var el_actor = create_checkbox(16, yy, "Is Actor?", ew, eh, function(checkbox) {
            checkbox.root.timeline_layer.is_actor = checkbox.value;
            }, timeline_layer.is_actor, dg);
        yy += el_actor.height + spacing;
        
        var yy_base = yy;
        
        var el_def_translation = create_text(16, yy, "Default Translation", ew, eh, fa_left, ew, dg);
        yy += el_def_translation.height + spacing;
        var el_trans_x = create_input(16, yy, "X", ew, eh, function(input) {
            input.root.timeline_layer.x = real(input.value);
        }, timeline_layer.x, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_trans_x.height;
        var el_trans_y = create_input(16, yy, "Y", ew, eh, function(input) {
            input.root.timeline_layer.y = real(input.value);
        }, timeline_layer.y, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_trans_y.height;
        var el_trans_z = create_input(16, yy, "Z", ew, eh, function(input) {
            input.root.timeline_layer.z = real(input.value);
        }, timeline_layer.z, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_trans_z.height + spacing;
        var el_def_rotation = create_text(16, yy, "Default Rotation", ew, eh, fa_left, ew, dg);
        yy += el_def_rotation.height + spacing;
        var el_rot_x = create_input(16, yy, "X", ew, eh, function(input) {
            input.root.timeline_layer.xrot = real(input.value);
        }, timeline_layer.xrot, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_rot_x.height;
        var el_rot_y = create_input(16, yy, "Y", ew, eh, function(input) {
            input.root.timeline_layer.yrot = real(input.value);
        }, timeline_layer.yrot, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_rot_y.height;
        var el_rot_z = create_input(16, yy, "Z", ew, eh, function(input) {
            input.root.timeline_layer.zrot = real(input.value);
        }, timeline_layer.zrot, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_rot_z.height + spacing;
        
        yy = yy_base;
        var el_def_scale = create_text(col2_x + 16, yy, "Default Scale", ew, eh, fa_left, ew, dg);
        yy += el_def_scale.height + spacing;
        var el_scale_x = create_input(col2_x + 16, yy, "X", ew, eh, function(input) {
            input.root.timeline_layer.xscale = real(input.value);
        }, timeline_layer.xscale, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_scale_x.height;
        var el_scale_y = create_input(col2_x + 16, yy, "Y", ew, eh, function(input) {
            input.root.timeline_layer.yscale = real(input.value);
        }, timeline_layer.yscale, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_scale_y.height;
        var el_scale_z = create_input(col2_x + 16, yy, "Z", ew, eh, function(input) {
            input.root.timeline_layer.zscale = real(input.value);
        }, timeline_layer.zscale, "float", validate_double, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
        yy += el_scale_z.height + spacing;
        var el_def_color = create_text(col2_x + 16, yy, "Default Color", ew, eh, fa_left, ew, dg);
        yy += el_def_color.height + spacing;
        var el_color = create_color_picker(col2_x + 16, yy, "Color", ew, eh, function(picker) {
            input.root.timeline_layer.color = picker.value;
        }, timeline_layer.color, vx1, vy1, vx2, vy2, dg);
        yy += el_color.height;
        var el_alpha = create_input(col2_x + 16, yy, "Alpha", ew, eh, function(input) {
            input.root.timeline_layer.alpha = real(input.value);
        }, timeline_layer.alpha, "float", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
        yy += el_alpha.height;
        
        var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
        
        ds_list_add(dg.contents,
            el_name,
            el_actor,
            el_def_translation,
            el_trans_x,
            el_trans_y,
            el_trans_z,
            el_def_rotation,
            el_rot_x,
            el_rot_y,
            el_rot_z,
            el_def_scale,
            el_scale_x,
            el_scale_y,
            el_scale_z,
            el_def_color,
            el_color,
            el_alpha,
            el_confirm
        );
    }
}