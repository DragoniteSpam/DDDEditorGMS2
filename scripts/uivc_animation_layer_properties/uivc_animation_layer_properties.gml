/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.el_layers);

if (selection >= 0) {
    var timeline_layer = thing.root.active_animation.layers[| selection];
    var dw = 640;
    var dh = 480;

    var dg = dialog_create(dw, dh, "Layer Properties", undefined, undefined, argument0);
    dg.timeline_layer = timeline_layer;
    
    var columns = 2;
    var ew = (dw - 64) / columns;
    var eh = 24;

    var vx1 = ew / 3;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var col2_x = dw / 2;

    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var spacing = 16;
    
    var el_name = create_input(16, yy, "Name:", ew, eh, uivc_animation_layer_name, 0, timeline_layer.name, "text", validate_string, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_name.height + spacing;
    var el_actor = create_checkbox(16, yy, "Is Actor?", ew, eh, uivc_animation_layer_is_actor, 0, timeline_layer.is_actor, dg);
    yy = yy + el_actor.height + spacing;
    
    var yy_base = yy;
    
    var el_def_translation = create_text(16, yy, "Default Translation", ew, eh, fa_left, ew, dg);
    yy = yy + el_def_translation.height + spacing;
    var el_trans_x = create_input(16, yy, "X", ew, eh, uivc_animation_layer_translation_x, 0, timeline_layer.xx, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_trans_x.height;
    var el_trans_y = create_input(16, yy, "Y", ew, eh, uivc_animation_layer_translation_y, 0, timeline_layer.yy, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_trans_y.height;
    var el_trans_z = create_input(16, yy, "Z", ew, eh, uivc_animation_layer_translation_z, 0, timeline_layer.zz, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_trans_z.height + spacing;
    var el_def_rotation = create_text(16, yy, "Default Rotation", ew, eh, fa_left, ew, dg);
    yy = yy + el_def_rotation.height + spacing;
    var el_rot_x = create_input(16, yy, "X", ew, eh, uivc_animation_layer_rotation_x, 0, timeline_layer.xrot, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_rot_x.height;
    var el_rot_y = create_input(16, yy, "Y", ew, eh, uivc_animation_layer_rotation_y, 0, timeline_layer.yrot, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_rot_y.height;
    var el_rot_z = create_input(16, yy, "Z", ew, eh, uivc_animation_layer_rotation_z, 0, timeline_layer.zrot, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_rot_z.height + spacing;
    
    yy = yy_base;
    var el_def_scale = create_text(col2_x + 16, yy, "Default Scale", ew, eh, fa_left, ew, dg);
    yy = yy + el_def_scale.height + spacing;
    var el_scale_x = create_input(col2_x + 16, yy, "X", ew, eh, uivc_animation_layer_scale_x, 0, timeline_layer.xrot, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_scale_x.height;
    var el_scale_y = create_input(col2_x + 16, yy, "Y", ew, eh, uivc_animation_layer_scale_y, 0, timeline_layer.yrot, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_scale_y.height;
    var el_scale_z = create_input(col2_x + 16, yy, "Z", ew, eh, uivc_animation_layer_scale_z, 0, timeline_layer.zrot, "float", validate_double, ui_value_real, -MILLION, MILLION, 8, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_scale_z.height + spacing;
    var el_def_color = create_text(col2_x + 16, yy, "Default Color", ew, eh, fa_left, ew, dg);
    yy = yy + el_def_color.height + spacing;
    var el_color = create_color_picker(col2_x + 16, yy, "Color", ew, eh, uivc_animation_layer_color, 0, timeline_layer.color, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_color.height;
    var el_alpha = create_input(col2_x + 16, yy, "Alpha", ew, eh, uivc_animation_layer_alpha, 0, timeline_layer.alpha, "float", validate_double, ui_value_real, 0, 1, 4, vx1, vy1, vx2, vy2, dg);
    yy = yy + el_alpha.height;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents, el_name, el_actor,
        el_def_translation, el_trans_x, el_trans_y, el_trans_z,
        el_def_rotation, el_rot_x, el_rot_y, el_rot_z,
        el_def_scale, el_scale_x, el_scale_y, el_scale_z,
        el_def_color, el_color, el_alpha,
        el_confirm);

    keyboard_string = "";
}