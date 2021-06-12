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
                        button.root.active_animation = undefined;
                        button.root.active_animation = undefined;
                        button.root.active_layer = undefined;
                        button.root.el_layers.selected_keyframe = undefined;
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
        el_layers = create_list(xx, yy_header, "Layers: ", "<no layers>", ew, eh, 8, function(list) {
            list.root.active_layer = undefined;
            if (list.root.active_animation) {
                var selection = ui_list_selection(list);
                if (selection + 1) {
                    list.root.active_layer = list.root.active_animation.layers[selection];
                }
            }
        }, false, id, []);
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
    
        el_timeline = create_timeline(tlx, el_layers.y, 32, eh, el_layers.slots, 30, null, function(timeline, x, y) {
            var animation = timeline.root.active_animation;
            var x1 = timeline.x + xx;
            var y1 = timeline.y + yy;
            var x2 = x1 + timeline.moment_width * timeline.moment_slots;
            var y2 = y1 + timeline.height;
            var y3 = y2 + timeline.slots * timeline.height;
            
            var inbounds = mouse_within_rectangle_determine(x1, y2, x2, y3, timeline.adjust_view);
            
            if (keyboard_check_pressed(vk_delete)) {
                var timeline_layer = animation.GetLayer(timeline.selected_layer);
                if (timeline_layer) {
                    var keyframe = timeline_layer.keyframes[timeline.selected_moment];
                    timeline_layer.keyframes[timeline.selected_moment] = undefined;
                    if (timeline.selected_keyframe == keyframe) {
                        animation_timeline_set_active_keyframe(timeline, undefined);
                    }
                }
            }
            
            // anything that should only be handled if the cursor is in bounds
            if (inbounds) {
                if (Controller.double_left) {
                    var timeline_layer = animation.GetLayer(timeline.selected_layer);
                    if (timeline_layer) {
                        var keyframe = animation.GetKeyframe(timeline.selected_layer, timeline.selected_moment);
                        if (!keyframe) {
                            keyframe = animation.AddKeyframe(timeline.selected_layer, timeline.selected_moment);
                            animation_timeline_set_active_keyframe(timeline, keyframe);
                        }
                    }
                } else if (Controller.press_left) {
                    if (!keyboard_check(vk_control)) {
                        animation_timeline_set_active_keyframe(timeline, animation.GetKeyframe(timeline.selected_layer, timeline.selected_moment));
                    }
                } else if (Controller.mouse_left) {
                    if (keyboard_check(vk_control)) {
                        if (timeline.selected_keyframe && (timeline.selected_keyframe.timeline_layer == timeline.selected_layer)) {
                            animation.SetKeyframePosition(timeline.selected_layer, timeline.selected_keyframe, timeline.selected_moment);
                        }
                    }
                }
            }
        }, id);
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
    
        el_keyframe.relative = create_button(xx, yy, "Relative to: ", ew, eh, fa_center, function(button) {
            var keyframe = thing.root.root.el_timeline.selected_keyframe;
            
            if (keyframe) {
                var dw = 320;
                var dh = 480;
                
                var dg = dialog_create(dw, dh, "Keyframe Relative To Other Layer", undefined, undefined, argument0);
                
                var columns = 1;
                var spacing = 16;
                var ew = dw / columns - spacing * 2;
                var eh = 24;
                
                var vx1 = ew / 2;
                var vy1 = 0;
                var vx2 = ew;
                var vy2 = eh;
                
                var col2_x = dw / columns;
                
                var b_width = 128;
                var b_height = 32;
                
                var yy = 64;
                var yy_base = yy;
                
                var el_list = create_list(16, yy, "Other Layer", "No Layers", ew, eh, 12, function(list) {
                    // you can select your own layer, which doesn't make sense, but i won't bother stopping you
                    list.keyframe.relative = ui_list_selection(list);
                }, false, dg, list.root.root.active_animation.layers);
                ui_list_select(el_list, keyframe.relative);
                el_list.entries_are = ListEntries.INSTANCES;
                // i should probably be doing this in more places so that i can find stuff easily
                el_list.keyframe = keyframe;
                
                var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
                
                ds_list_add(dg.contents,
                    el_list,
                    el_confirm
                );
            }
        }, el_keyframe);
        el_keyframe.relative.render = function(button, x, y) {
            var animation = button.root.root.active_animation;
            var timeline = button.root.root.el_timeline;
            var timeline_layer = ui_list_selection(button.root.root.el_layers);
            
            var keyframe;
            if (animation && (timeline_layer + 1)) {
                keyframe = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
                button.text = button.text + ((keyframe && (keyframe.relative + 1) && (keyframe.relative < array_length(animation.layers))) ? " " + animation.layers[keyframe.relative].name : " (None)");
            }
            
            button.interactive = !!keyframe;
            ui_render_button(button, xx, yy);
        };
        ds_list_add(el_keyframe.contents, el_keyframe.relative);
    
        yy += el_keyframe.relative.height + spacing;
    
        element = create_text(xx, yy, "      Keyframe Translation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
        
        var keyframe_set_property = function(input) {
            var keyframe = input.root.root.el_timeline.selected_keyframe;
            if (keyframe) keyframe.SetParam(input.parameter, real(input.value));
        };
        
        var keyframe_property_render = function(input, x, y) {
            var animation = input.root.root.active_animation;
            var keyframe = noone;
            var timeline = input.root.root.el_timeline;
            var timeline_layer = ui_list_selection(input.root.root.el_layers);
            
            if (animation && (timeline_layer + 1)) {
                keyframe = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
                var kf_current = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
                var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
                input.back_color = rel_current ? c_ui_select : c_white;
                if (!ui_is_active(input)) {
                    input.value = string(animation.GetValue(timeline_layer, floor(timeline.playing_moment)));
                }
            }
            
            input.interactive = !!keyframe;
            input.root.linked.interactive = input.interactive;
            
            ui_render_input(input, x, y);
        };
        
        var keyframe_set_tween = function(button) {
            var keyframe = element.root.root.el_timeline.selected_keyframe;
            var param = element.parameter;
            
            if (keyframe) {
                var dw = 320;
                var dh = 720;
                
                var dg = dialog_create(dw, dh, "Animation Tweening", undefined, undefined, argument0);
                
                var columns = 1;
                var spacing = 16;
                var ew = dw / columns - spacing * 2;
                var eh = 24;
                
                var b_width = 128;
                var b_height = 32;
                
                var yy = 64;
                
                var el_type = create_radio_array(16, yy, "Type", ew, eh, function(radio) {
                    var keyframe = radio.root.root.root.root.root.el_timeline.selected_keyframe;
                    keyframe.SetParameterTween(radio.root.param, radio.value);
                }, keyframe.GetParameterTween(param), dg);
                create_radio_array_options(el_type, global.animation_tween_names);
                el_type.param = param;
            
                var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
        
                ds_list_add(dg.contents,
                    el_type,
                    el_confirm
                );
            }
        };
        
        el_keyframe.translate_x = create_input(xx, yy, "      x:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_x.render = keyframe_property_render;
        el_keyframe.parameter = KeyframeParameters.TRANS_X;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_x);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.TRANS_X;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.translate_x.height;
    
        el_keyframe.translate_y = create_input(xx, yy, "      y:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_y.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_y);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.TRANS_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.translate_y.height;
    
        el_keyframe.translate_z = create_input(xx, yy, "      z:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_z.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_z);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.TRANS_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.translate_z.height;
    
        element = create_text(xx, yy, "      Keyframe Rotation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.rotate_x = create_input(xx, yy, "      x:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_x.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_x);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.ROT_X;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.rotate_x.height;
    
        el_keyframe.rotate_y = create_input(xx, yy, "      y:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_y.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_y);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.ROT_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.rotate_y.height;
    
        el_keyframe.rotate_z = create_input(xx, yy, "      z:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_z.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_z);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.ROT_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.rotate_z.height;
    
        element = create_text(xx, yy, "      Keyframe Scale", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.scale_x = create_input(xx, yy, "      x:", ew, eh, keyframe_set_property, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_x.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_x);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.SCALE_X;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.scale_x.height;
    
        el_keyframe.scale_y = create_input(xx, yy, "      y:", ew, eh, keyframe_set_property, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_y.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_y);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.SCALE_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.scale_y.height;
    
        el_keyframe.scale_z = create_input(xx, yy, "      z:", ew, eh, keyframe_set_property, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_z.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_z);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.SCALE_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.scale_z.height;
    
        element = create_text(xx, yy, "      Other Keyframe Properties", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.color = create_color_picker(xx, yy, "      color:", ew, eh, keyframe_set_property, c_white, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.color.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.color);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.COLOR;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.color.height;
    
        el_keyframe.alpha = create_input(xx, yy, "      alpha:", ew, eh, keyframe_set_property, "1", "float", validate_double, 0, 1, 6, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.alpha.render = keyframe_property_render;
        ds_list_add(el_keyframe.contents, el_keyframe.alpha);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.ALPHA;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.alpha.height + spacing;
    
        element = create_button(xx, yy, "More Data", ew, eh, fa_center, omu_animation_keyframe_event, el_keyframe);
        element.render = function(button, x, y) {
            var animation = button.root.root.active_animation;
            var timeline_layer = ui_list_selection(button.root.root.el_layers);
            button.interactive = !!(animation && (timeline_layer + 1));
            ui_render_button(button, x, y);
        };
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
