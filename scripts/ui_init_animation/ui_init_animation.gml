/// @param EditorModeMap
function ui_init_animation(argument0) {

    var mode = argument0;

    // this one's not tabbed, it's just a bunch of elements floating in space
    with (instance_create_depth(0, 0, 0, UIThing)) {
        var columns = 5;
        var spacing = 16;
    
        var cw = (room_width - columns * 32) / columns;
        var ew = cw - spacing * 2;
        var eh = 24;
    
        var vx1 = room_width / (columns * 2) - 32;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
    
        var b_width = 128;
        var b_height = 32;
    
        var yy_header = 64;
        var yy = 64 + eh;
        var yy_base = yy;
    
        active_animation = noone;
        active_layer = noone;
    
        /*
         * these are pretty important
         */
    
        var this_column = 0;
        var xx = this_column * cw + spacing;
    
        el_master = create_list(xx, yy_header, "Animations: ", "<no animations>", ew, eh, 26, function(list) {
            if (!array_empty(Game.animations)) {
                var selection = ui_list_selection(list);
                list.root.active_animation = undefined;
                list.root.el_timeline.playing = false;
                list.root.el_timeline.playing_moment = 0;
                if (selection + 1) {
                    list.root.active_animation = Game.animations[selection];
                    ui_list_deselect(list.root.el_layers);
                }
            }
        }, false, id, Game.animations);
        el_master.render = function (list, x, y) {
            var otext = list.text;
            list.text = otext + string(array_length(Game.animations));
            ui_render_list(list, x, y);
            list.text = otext;
        };
        el_master.ondoubleclick = omu_animation_properties;
        el_master.entries_are = ListEntries.INSTANCES;
        ds_list_add(contents, el_master);
    
        yy += ui_get_list_height(el_master);
    
        var element = create_button(xx, yy, "Add Animation", ew, eh, fa_middle, function(button) {
            var n = string(array_length(Game.animations));
            var animation = new DataAnimation("Animation" + n);
            array_push(Game.animations, animation);
            internal_name_set(animation, "Anim" + n);
        }, id);
        ds_list_add(contents, element);
    
        yy += element.height + spacing;
    
        element = create_button(xx, yy, "Delete Animation", ew, eh, fa_middle, function(button) {
            var selection = ui_list_selection(button.root.el_master);
            ui_list_deselect(button.root.el_master);
            if (selection + 1) {
                for (var i = 0; i < array_length(Game.animations); i++) {
                    if (Game.animations[i] == button.root.active_animation) {
                        array_delete(Game.animations, i, 1);
                        ui_list_deselect(button.root.el_master);
                        button.root.active_animation = noone;
                        button.root.active_animation = noone;
                        button.root.active_layer = noone;
                        button.root.el_layers.selected_keyframe = noone;
                        ui_list_deselect(button.root.el_layers);
                        break;
                    }
                }
            }
        }, id);
        ds_list_add(contents, element);
    
        yy += element.height + spacing;
    
        element = create_button(xx, yy, "Edit Animation Properties", ew, eh, fa_middle, omu_animation_properties, id);
        ds_list_add(contents, element);
    
        yy += element.height + spacing;
    
        yy = yy_base;
        this_column = 1;
        xx = this_column * cw + spacing;
    
        #region keyframes
        el_layers = create_list(xx, yy_header, "Layers: ", "<no layers>", ew, eh, 8, uivc_list_animation_layers_editor, false, id, []);
        el_layers.render = function(list, x, y) {
            var otext = list.text;
            if (list.root.active_animation) {
                list.text = otext + string(array_length(list.root.active_animation.layers));
                list.entries = list.root.active_animation.layers;
                ui_render_list(list, x, y);
                list.text = otext;
            } else {
                list.entries = [];
                ui_render_list(list, x, y);
            }
        };
        el_layers.ondoubleclick = uivc_animation_layer_properties;
        el_layers.entries_are = ListEntries.INSTANCES;
        ds_list_add(contents, el_layers);
    
        var tlx = el_layers.x + el_layers.width;
    
        el_timeline = create_timeline(tlx, el_layers.y, 32, eh, el_layers.slots, 30, null, uii_animation_layers, id);
        ds_list_add(contents, el_timeline);
    
        yy += ui_get_list_height(el_layers);
        var yy_beneath_timeline = yy - 16;
    
        element = create_button(xx, yy, "Add Layer", ew, eh, fa_middle, function(button) {
            var animation = button.root.active_animation;
            if (animation) animation.AddLayer();
        }, id);
        ds_list_add(contents, element);
    
        yy += element.height + spacing;
    
        element = create_button(xx, yy, "Delete Layer", ew, eh, fa_middle, function(button) {
            var list = button.root.active_animation.layers;
            var selection = ui_list_selection(button.root.el_layers);
            ui_list_deselect(button.root.el_layers);
            if (!array_empty(list) && selection + 1) {
                array_delete(list, selection, 1);
            }
        }, id);
        ds_list_add(contents, element);
    
        yy += element.height + spacing;
    
        element = create_button(xx, yy, "Edit Layer Properties", ew, eh, fa_middle, uivc_animation_layer_properties, id);
        ds_list_add(contents, element);
    
        yy += element.height + spacing;
        #endregion
    
        el_keyframe = instance_create_depth(xx, yy, 0, UIThing);
        el_keyframe.root = id;
        ds_list_add(contents, el_keyframe);
    
        #region keyframe data panel
        xx = 0;
        yy = 0;
        var imgw = sprite_get_width(spr_timeline_keyframe_tween);
        var imgh = sprite_get_height(spr_timeline_keyframe_tween);
    
        var el_rectangle_inner = create_rectangle(xx - 8, yy - 8, ew + 16, yy + 8, 0xf0f0f0, false);
        ds_list_add(el_keyframe.contents, el_rectangle_inner);
        var el_rectangle = create_rectangle(xx - 8, yy - 8, ew + 16, yy + 8);
        ds_list_add(el_keyframe.contents, el_rectangle);
    
        el_keyframe.relative = create_button(xx, yy, "Relative to: ", ew, eh, fa_center, omu_animation_keyframe_relative, el_keyframe);
        el_keyframe.relative.render = ui_render_animation_keyframe_relative;
        ds_list_add(el_keyframe.contents, el_keyframe.relative);
    
        yy += el_keyframe.relative.height + spacing;
    
        element = create_text(xx, yy, "      Keyframe Translation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.translate_x = create_input(xx, yy, "      x:", ew, eh, uivc_animation_keyframe_translation_x, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_x.render = ui_render_animation_keyframe_translate_x;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_x);
        el_keyframe.tween_translate_x = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_translate_x.parameter = KeyframeParameters.TRANS_X;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_translate_x);
    
        yy += el_keyframe.translate_x.height;
    
        el_keyframe.translate_y = create_input(xx, yy, "      y:", ew, eh, uivc_animation_keyframe_translation_y, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_y.render = ui_render_animation_keyframe_translate_y;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_y);
        el_keyframe.tween_translate_y = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_translate_y.parameter = KeyframeParameters.TRANS_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_translate_y);
    
        yy += el_keyframe.translate_y.height;
    
        el_keyframe.translate_z = create_input(xx, yy, "      z:", ew, eh, uivc_animation_keyframe_translation_z, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_z.render = ui_render_animation_keyframe_translate_z;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_z);
        el_keyframe.tween_translate_z = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_translate_z.parameter = KeyframeParameters.TRANS_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_translate_z);
    
        yy += el_keyframe.translate_z.height;
    
        element = create_text(xx, yy, "      Keyframe Rotation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.rotate_x = create_input(xx, yy, "      x:", ew, eh, uivc_animation_keyframe_rotation_x, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_x.render = ui_render_animation_keyframe_rotate_x;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_x);
        el_keyframe.tween_rotate_x = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_rotate_x.parameter = KeyframeParameters.ROT_X;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_rotate_x);
    
        yy += el_keyframe.rotate_x.height;
    
        el_keyframe.rotate_y = create_input(xx, yy, "      y:", ew, eh, uivc_animation_keyframe_rotation_y, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_y.render = ui_render_animation_keyframe_rotate_y;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_y);
        el_keyframe.tween_rotate_y = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_rotate_y.parameter = KeyframeParameters.ROT_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_rotate_y);
    
        yy += el_keyframe.rotate_y.height;
    
        el_keyframe.rotate_z = create_input(xx, yy, "      z:", ew, eh, uivc_animation_keyframe_rotation_z, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_z.render = ui_render_animation_keyframe_rotate_z;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_z);
        el_keyframe.tween_rotate_z = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_rotate_z.parameter = KeyframeParameters.ROT_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_rotate_z);
    
        yy += el_keyframe.rotate_z.height;
    
        element = create_text(xx, yy, "      Keyframe Scale", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.scale_x = create_input(xx, yy, "      x:", ew, eh, uivc_animation_keyframe_scale_x, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_x.render = ui_render_animation_keyframe_scale_x;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_x);
        el_keyframe.tween_scale_x = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_scale_x.parameter = KeyframeParameters.SCALE_X;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_scale_x);
    
        yy += el_keyframe.scale_x.height;
    
        el_keyframe.scale_y = create_input(xx, yy, "      y:", ew, eh, uivc_animation_keyframe_scale_y, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_y.render = ui_render_animation_keyframe_scale_y;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_y);
        el_keyframe.tween_scale_y = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_scale_y.parameter = KeyframeParameters.SCALE_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_scale_y);
    
        yy += el_keyframe.scale_y.height;
    
        el_keyframe.scale_z = create_input(xx, yy, "      z:", ew, eh, uivc_animation_keyframe_scale_z, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_z.render = ui_render_animation_keyframe_scale_z;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_z);
        el_keyframe.tween_scale_z = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_scale_z.parameter = KeyframeParameters.SCALE_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_scale_z);
    
        yy += el_keyframe.scale_z.height;
    
        element = create_text(xx, yy, "      Other Keyframe Properties", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.color = create_color_picker(xx, yy, "      color:", ew, eh, uivc_animation_keyframe_color, c_white, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.color.render = ui_render_animation_keyframe_color;
        ds_list_add(el_keyframe.contents, el_keyframe.color);
        el_keyframe.tween_color = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_color.parameter = KeyframeParameters.COLOR;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_color);
    
        yy += el_keyframe.color.height;
    
        el_keyframe.alpha = create_input(xx, yy, "      alpha:", ew, eh, uivc_animation_keyframe_alpha, "1", "float", validate_double, 0, 1, 6, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.alpha.render = ui_render_animation_keyframe_alpha;
        ds_list_add(el_keyframe.contents, el_keyframe.alpha);
        el_keyframe.tween_alpha = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, omu_animation_keyframe_tween, el_keyframe);
        el_keyframe.tween_alpha.parameter = KeyframeParameters.ALPHA;
        ds_list_add(el_keyframe.contents, el_keyframe.tween_alpha);
    
        yy += el_keyframe.alpha.height + spacing;
    
        element = create_button(xx, yy, "More Data", ew, eh, fa_center, omu_animation_keyframe_event, el_keyframe);
        element.render = ui_render_animation_keyframe_other;
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_rectangle.y2 = yy + 8;
        el_rectangle_inner.y2 = el_rectangle.y2;
        #endregion
    
        yy = yy_beneath_timeline + spacing;
    
        var sw = sprite_get_width(spr_camera_icons);
        var sh = sprite_get_height(spr_camera_icons);
    
        element = create_image_button(room_width - 32 - sw, yy, "", spr_camera_icons, sw, sh, fa_middle, omu_animation_reset_camera, id);
        element.index = 0;
        ds_list_add(contents, element);
    
        return id;
    }


}
