// this one's not tabbed, it's just a bunch of elements floating in space
with (instantiate(UIThing)) {
    var columns = 5;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var vx1 = room_width / (columns * 2) - 32;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    var element;
    
    active_animation = noone;
    active_layer = noone;
    
    /*
     * these are pretty important
     */
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    el_master = create_list(xx, yy_header, "Animations: ", "<no animations>", ew, eh, 25, uivc_list_animation_editor, false, id);
    el_master.render = ui_render_list_animations;
    el_master.entries_are = ListEntries.INSTANCES;
    ds_list_add(contents, el_master);
    
    yy = yy + ui_get_list_height(el_master);
    
    var element = create_button(xx, yy, "Add Animation", ew, eh, fa_middle, omu_animation_add, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_button(xx, yy, "Remove Animation", ew, eh, fa_middle, omu_animation_remove, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    el_name = create_input(xx, yy, "Name:", ew, eh, uivc_animation_set_name, "", "", "Instance name", validate_string, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, id);
    ds_list_add(contents, el_name);
    
    yy = yy + el_name.height + spacing;
        
    el_internal_name = create_input(xx, yy, "Internal Name:", ew, eh, uivc_animation_set_internal_name, "", "", "Internal name", validate_string_internal_name, ui_value_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, id);
    el_internal_name.render = ui_render_text_animation_internal_name;
    ds_list_add(contents, el_internal_name);
    
    yy = yy + el_internal_name.height + spacing;
    
    yy = yy_base;
    this_column = 1;
    xx = this_column * cw + spacing;
    
    el_layers = create_list(xx, yy_header, "Layers: ", "<no layers>", ew, eh, 10, uivc_list_animation_layers_editor, false, id);
    el_layers.render = ui_render_list_animation_layers;
    el_layers.ondoubleclick = uidc_list_animation_layers_editor;
    el_layers.entries_are = ListEntries.INSTANCES;
    ds_list_add(contents, el_layers);
    
    var tlx = el_layers.x + el_layers.width;
    
    el_timeline = create_timeline(tlx, el_layers.y, 32, eh, el_layers.slots, 30, null, uii_animation_layers, id);
    ds_list_add(contents, el_timeline);
    
    yy = yy + ui_get_list_height(el_layers);
    
    var element = create_button(xx, yy, "Add Layer", ew, eh, fa_middle, omu_animation_layer_add, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_button(xx, yy, "Remove Layer", ew, eh, fa_middle, omu_animation_layer_remove, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    el_keyframe = instance_create_depth(xx, yy, 0, UIThing);
    el_keyframe.root = id;
    ds_list_add(contents, el_keyframe);
    
    {   // keyframes inner panel
        var xx = 0;
        var yy = 0;
        var imgw = sprite_get_width(spr_timeline_keyframe_tween);
        var imgh = sprite_get_height(spr_timeline_keyframe_tween);
        
        var element = create_text(xx, yy, "      Keyframe Translation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + element.height;
    
        el_keyframe.translate_x = create_input(xx, yy, "      x:", ew, eh, uivc_animation_keyframe_translation_x, 0, "0", "float", validate_double, ui_value_real, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_x.render = ui_render_animation_keyframe_translate_x;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_x);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.translate_x.height;
    
        el_keyframe.translate_y = create_input(xx, yy, "      y:", ew, eh, uivc_animation_keyframe_translation_y, 0, "0", "float", validate_double, ui_value_real, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_y.render = ui_render_animation_keyframe_translate_y;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_y);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.translate_y.height;
    
        el_keyframe.translate_z = create_input(xx, yy, "      z:", ew, eh, uivc_animation_keyframe_translation_z, 0, "0", "float", validate_double, ui_value_real, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_z.render = ui_render_animation_keyframe_translate_z;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_z);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.translate_z.height;
    
        var element = create_text(xx, yy, "      Keyframe Rotation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + element.height;
    
        el_keyframe.rotate_x = create_input(xx, yy, "      x:", ew, eh, uivc_animation_keyframe_rotation_x, 0, "0", "float", validate_double, ui_value_real, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_x.render = ui_render_animation_keyframe_rotate_x;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_x);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.rotate_x.height;
    
        el_keyframe.rotate_y = create_input(xx, yy, "      y:", ew, eh, uivc_animation_keyframe_rotation_y, 0, "0", "float", validate_double, ui_value_real, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_y.render = ui_render_animation_keyframe_rotate_y;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_y);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.rotate_y.height;
    
        el_keyframe.rotate_z = create_input(xx, yy, "      z:", ew, eh, uivc_animation_keyframe_rotation_z, 0, "0", "float", validate_double, ui_value_real, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_z.render = ui_render_animation_keyframe_rotate_z;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_z);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.rotate_z.height;
    
        var element = create_text(xx, yy, "      Keyframe Scale", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + element.height;
    
        el_keyframe.scale_x = create_input(xx, yy, "      x:", ew, eh, uivc_animation_keyframe_scale_x, 0, "1", "float", validate_double, ui_value_real, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_x.render = ui_render_animation_keyframe_scale_x;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_x);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.scale_x.height;
    
        el_keyframe.scale_y = create_input(xx, yy, "      y:", ew, eh, uivc_animation_keyframe_scale_y, 0, "1", "float", validate_double, ui_value_real, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_y.render = ui_render_animation_keyframe_scale_y;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_y);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.scale_y.height;
    
        el_keyframe.scale_z = create_input(xx, yy, "      z:", ew, eh, uivc_animation_keyframe_scale_z, 0, "1", "float", validate_double, ui_value_real, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_z.render = ui_render_animation_keyframe_scale_z;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_z);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.scale_z.height + spacing;
        
        var element = create_text(xx, yy, "      Other Keyframe Properties", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + element.height + spacing;
    
        el_keyframe.color = create_color_picker(xx, yy, "      color:", ew, eh, uivc_animation_keyframe_color, 0, c_white, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.color.render = ui_render_animation_keyframe_color;
        ds_list_add(el_keyframe.contents, el_keyframe.color);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.color.height;
    
        el_keyframe.alpha = create_input(xx, yy, "      alpha:", ew, eh, uivc_animation_keyframe_alpha, 0, "1", "float", validate_double, ui_value_real, 0, 1, 6, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.alpha.render = ui_render_animation_keyframe_alpha;
        ds_list_add(el_keyframe.contents, el_keyframe.alpha);
        var element = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + el_keyframe.alpha.height + spacing;
    
        var element = create_button(xx, yy, "Event", ew, eh, fa_center, null, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
        
        yy = yy + element.height;
    
    }
    
    yy = yy_base;
    
    /*
     * more important stuff that needs to be done?
     */
    
    instance_deactivate_object(id);
    
    return id;
}