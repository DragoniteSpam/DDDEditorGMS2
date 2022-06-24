function ui_init_animation(mode) {
    var hud_width = window_get_width();
    var hud_height = window_get_height();
    var col1x = 32;
    var col2x = 288;
    var col3x = 544;
    var col_width = 240;
    var col_height = 32;
    
    var imgw = sprite_get_width(spr_timeline_keyframe_tween);
    var imgh = sprite_get_height(spr_timeline_keyframe_tween);

    var keyframe_set_property = function(input) {
        var keyframe = input.root.root.el_timeline.selected_keyframe;
        if (keyframe) keyframe.Set(input.parameter, real(input.value));
    };
    
    var keyframe_property_render = function(input, x, y) {
        var animation = input.root.root.active_animation;
        var keyframe = undefined;
        var timeline = input.root.root.el_timeline;
        var timeline_layer = ui_list_selection(input.root.root.el_layers);
        
        if (animation && (timeline_layer + 1)) {
            keyframe = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
            var kf_current = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
            var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : undefined;
            input.back_color = rel_current ? c_ui_select : c_white;
            if (!ui_is_active(input)) {
                input.value = string(animation.GetValue(timeline_layer, floor(timeline.playing_moment), input.parameter));
            }
        }
        
        input.interactive = !!keyframe;
        input.root.linked.interactive = input.interactive;
        
        ui_render_input(input, x, y);
    };
    
    var keyframe_property_render_color = function(picker, x, y) {
        var animation = picker.root.root.active_animation;
        var keyframe = undefined;
        var timeline = picker.root.root.el_timeline;
        var timeline_layer = ui_list_selection(picker.root.root.el_layers);
        
        if (animation && (timeline_layer + 1)) {
            keyframe = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
            var kf_current = animation.GetKeyframe(timeline_layer, timeline.playing_moment);
            var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
            picker.back_color = rel_current ? c_ui_select : c_white;
            if (!ui_is_active(picker)) {
                picker.value = animation.GetValue(timeline_layer, floor(timeline.playing_moment), picker.parameter);
            }
        }
        
        picker.interactive = !!keyframe;
        picker.root.linked.interactive = picker.interactive;
        
        ui_render_color_picker(picker, x, y);
    };
    
    var keyframe_set_tween = function(element) {
        var keyframe = element.root.root.el_timeline.selected_keyframe;
        var param = element.parameter;
        
        if (keyframe) {
            var dialog = new EmuDialog(320, 720, "Animation Tweening");
            dialog.keyframe = keyframe;
            dialog.param = param;
            
            return dialog.AddContent([
                new EmuRadioArray(32, EMU_AUTO, dialog.width - 64, 32, "Type:", keyframe.GetParameterTween(param), function() {
                    self.root.keyframe.SetParameterTween(self.root.param, self.value);
                })
                    .AddOptions(global.animation_tween_names)
            ])
                .AddDefaultCloseButton();
        }
    };
    
    var container = new EmuCore(0, 32, hud_width, hud_height);
    container.active_animation = undefined;
    container.active_layer = undefined;
    
    container.AddContent([
        #region animation list
        (new EmuList(col1x, EMU_AUTO, col_width, col_height, "Animations:", col_height, 20, function() {
            if (!self.root) return;
            if (!array_empty(Game.animations)) {
                var selection = self.GetSelection();
                self.root.active_animation = undefined;
                self.GetSibling("TIMELINE").playing = false;
                self.GetSibling("TIMELINE").playing_moment = 0;
                if (selection + 1) {
                    self.root.active_animation = Game.animations[selection];
                    self.GetSibling("LAYERS").Deselect();
                }
            }
        }))
            .SetCallbackDouble(omu_animation_properties)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Game.animations)
            .SetVacantText("No animations")
            .SetID("LIST"),
        (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Add Animation", function() {
            var n = string(array_length(Game.animations));
            var animation = new DataAnimation("Animation" + n);
            array_push(Game.animations, animation);
            internal_name_set(animation, "Anim" + n);
        }))
            .SetID("ADD"),
        (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Delete Animation", function() {
            var selection = self.GetSibling("LIST").GetSelection();
            self.GetSibling("LIST").Deselect();
            if (selection + 1) {
                for (var i = 0; i < array_length(Game.animations); i++) {
                    if (Game.animations[i] == self.root.active_animation) {
                        array_delete(Game.animations, i, 1);
                        self.root.active_animation = undefined;
                        self.root.active_animation = undefined;
                        self.root.active_layer = undefined;
                        self.GetSibling("LAYERS").selected_keyframe = undefined;
                        self.GetSibling("LAYERS").Deselect();
                        break;
                    }
                }
            }
        }))
            .SetID("DELETE"),
        (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Animation Properties", omu_animation_properties))
            .SetID("PROPERTIES"),
        #endregion
        #region layer stuff
        (new EmuList(col2x, EMU_BASE, col_width, col_height, "Layers:", col_height, 4, function() {
            if (!self.root) return;
            self.root.active_layer = undefined;
            if (self.root.active_animation) {
                var selection = self.GetSelection();
                if (selection + 1) {
                    self.root.active_layer = self.root.active_animation.layers[selection];
                }
            }
        }))
            .SetCallbackDouble(uivc_animation_layer_properties)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList([])
            .SetVacantText("No layers")
            .SetID("LAYERS"),
        (new EmuButton(col2x, EMU_AUTO, col_width, col_height, "Add Layer", function() {
            if (self.root.active_animation) self.root.active_animation.AddLayer();
        }))
            .SetID("ADD LAYER"),
        (new EmuButton(col2x, EMU_AUTO, col_width, col_height, "Delete Layer", function() {
            var layer_list = self.root.active_animation.layers;
            var selection = self.GetSibling("LAYERS");
            self.GetSibling("LAYERS").Deselect();
            if (!array_empty(layer_list) && selection + 1) {
                array_delete(layer_list, selection, 1);
            }
        }))
            .SetID("DELETE LAYER"),
        (new EmuButton(col2x, EMU_AUTO, col_width, col_height, "Layer Properties", uivc_animation_layer_properties))
            .SetID("LAYER PROPERTIES"),
        #endregion
        #region keyframe stuff
        (new EmuCore(col2x, EMU_AUTO, col_width, col_height))
            .SetDefaultSpacingY(8)
            .SetID("KEYFRAME STUFF")
            .AddContent([
                // To do: buttons and whatnot need an "update" of some sort that can automatically set their text, like the old "render" overrides:
                // button.text = (keyframe && (keyframe.relative + 1) && (keyframe.relative < array_length(animation.layers))) ? " " + animation.layers[keyframe.relative].name : " (None)";
                // button.interactive = !!keyframe;
                (new EmuButton(0, EMU_AUTO, col_width, col_height, "Relative to:", function() {
                    var keyframe = self.root.root.GetSibling("TIMELINE").selected_keyframe;
                    if (keyframe) {
                        var col_width = 240;
                        var col_height = 32;
                        var dialog = (new EmuDialog(320, 480, "Relative to Other Layer")).AddContent([
                            (new EmuList(32, EMU_AUTO, col_width, col_height, "Layer:", col_height, 6, function() {
                                // you can select your own layer, which doesn't make sense, but i won't bother stopping you
                                self.keyframe.relative = self.GetSelection();
                            }))
                                .Select(keyframe.relative)
                                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                                .SetID("LAYERS")
                        ])
                            .AddDefaultCloseButton();
                        
                        dialog.GetChild("LAYERS").keyframe = keyframe;
                    }
                })),
                new EmuText(0, EMU_AUTO, col_width, col_height, "[c_aqua]Position"),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      x:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME POSITION X"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      y:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME POSITION Y"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      z:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME POSITION Z"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                new EmuText(0, EMU_AUTO, col_width, col_height, "[c_aqua]Rotation"),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      x:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME ROTATION X"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      y:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME ROTATION Y"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      z:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME ROTATION Z"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                new EmuText(0, EMU_AUTO, col_width, col_height, "[c_aqua]Scale"),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      x:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME SCALE X"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      y:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME SCALE Y"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      z:", "0", "number", 5, E_InputTypes.REAL, function() {
                    
                }))
                    .SetID("KEYFRAME SCALE Z"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                new EmuText(0, EMU_AUTO, col_width, col_height, "[c_aqua]Other"),
                (new EmuColorPicker(0, EMU_AUTO, col_width, col_height, "      alpha:", c_white, function() {
                    
                }))
                    .SetID("KEYFRAME COLOR"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
                (new EmuInput(0, EMU_AUTO, col_width, col_height, "      alpha:", "0", "number", 4, E_InputTypes.REAL, function() {
                    
                }))
                    .SetRealNumberBounds(0, 1)
                    .SetID("KEYFRAME ALPHA"),
                (new EmuButtonImage(0, EMU_INLINE, imgw, imgh, spr_timeline_keyframe_tween, 0, c_white, 1, false, function() {
                    
                })),
            ]),
        #endregion
        (new EmuRenderSurface(col3x, EMU_AUTO, col_width, col_height, function(mx, my) {
            draw_clear(c_black);
        }, function(mx, my) {
            
        }))
            .SetID("3D VIEW")
    ]);
    
    return container;
/*
    // this one's not tabbed, it's just a bunch of elements floating in space
    with (instance_create_depth(0, 0, 0, UIThing)) {
        el_timeline = create_timeline(tlx, el_layers.y, 32, eh, el_layers.slots, 30, null, function(timeline, x, y) {
            var animation = timeline.root.active_animation;
            var x1 = timeline.x + x;
            var y1 = timeline.y + y;
            var x2 = x1 + timeline.moment_width * timeline.moment_slots;
            var y2 = y1 + timeline.height;
            var y3 = y2 + timeline.slots * timeline.height;
            
            var inbounds = mouse_within_rectangle(x1, y2, x2, y3);
            
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
    
        el_keyframe = instance_create_depth(xx, yy, 0, UIThing);
        el_keyframe.root = id;
        ds_list_add(contents, el_keyframe);
    
        #region keyframe data panel
        xx = 0;
        yy = 0;
    
        var el_rectangle_inner = create_rectangle(xx - 8, yy - 8, ew + 16, yy + 8, 0xf0f0f0, false);
        ds_list_add(el_keyframe.contents, el_rectangle_inner);
        var el_rectangle = create_rectangle(xx - 8, yy - 8, ew + 16, yy + 8);
        ds_list_add(el_keyframe.contents, el_rectangle);
    
        element = create_text(xx, yy, "      Keyframe Translation", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
        
        el_keyframe.translate_x = create_input(xx, yy, "      x:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_x.render = keyframe_property_render;
        el_keyframe.translate_x.parameter = KeyframeParameters.TRANS_X;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_x);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.TRANS_X;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.translate_x.height;
    
        el_keyframe.translate_y = create_input(xx, yy, "      y:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_y.render = keyframe_property_render;
        el_keyframe.translate_y.parameter = KeyframeParameters.TRANS_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.translate_y);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.TRANS_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.translate_y.height;
    
        el_keyframe.translate_z = create_input(xx, yy, "      z:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.translate_z.render = keyframe_property_render;
        el_keyframe.translate_z.parameter = KeyframeParameters.TRANS_Z;
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
        el_keyframe.rotate_x.parameter = KeyframeParameters.ROT_X;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_x);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.ROT_X;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.rotate_x.height;
    
        el_keyframe.rotate_y = create_input(xx, yy, "      y:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_y.render = keyframe_property_render;
        el_keyframe.rotate_y.parameter = KeyframeParameters.ROT_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.rotate_y);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.ROT_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.rotate_y.height;
    
        el_keyframe.rotate_z = create_input(xx, yy, "      z:", ew, eh, keyframe_set_property, "0", "float", validate_double, -MILLION, MILLION, 10, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.rotate_z.render = keyframe_property_render;
        el_keyframe.rotate_z.parameter = KeyframeParameters.ROT_Z;
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
        el_keyframe.scale_x.parameter = KeyframeParameters.SCALE_X;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_x);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.SCALE_X;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.scale_x.height;
    
        el_keyframe.scale_y = create_input(xx, yy, "      y:", ew, eh, keyframe_set_property, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_y.render = keyframe_property_render;
        el_keyframe.scale_y.parameter = KeyframeParameters.SCALE_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_y);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.SCALE_Y;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.scale_y.height;
    
        el_keyframe.scale_z = create_input(xx, yy, "      z:", ew, eh, keyframe_set_property, "1", "float", validate_double, -100, 100, 5, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.scale_z.render = keyframe_property_render;
        el_keyframe.scale_z.parameter = KeyframeParameters.SCALE_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.scale_z);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.SCALE_Z;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.scale_z.height;
    
        element = create_text(xx, yy, "      Other Keyframe Properties", ew, eh, fa_left, ew, el_keyframe);
        ds_list_add(el_keyframe.contents, element);
    
        yy += element.height;
    
        el_keyframe.color = create_color_picker(xx, yy, "      color:", ew, eh, keyframe_set_property, c_white, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.color.render = keyframe_property_render_color;
        el_keyframe.color.parameter = KeyframeParameters.COLOR;
        ds_list_add(el_keyframe.contents, el_keyframe.color);
        el_keyframe.linked = create_image_button(xx, yy, "", spr_timeline_keyframe_tween, imgw, imgh, fa_middle, keyframe_set_tween, el_keyframe);
        el_keyframe.linked.parameter = KeyframeParameters.COLOR;
        ds_list_add(el_keyframe.contents, el_keyframe.linked);
    
        yy += el_keyframe.color.height;
    
        el_keyframe.alpha = create_input(xx, yy, "      alpha:", ew, eh, keyframe_set_property, "1", "float", validate_double, 0, 1, 6, vx1, vy1, vx2, vy2, el_keyframe);
        el_keyframe.alpha.render = keyframe_property_render;
        el_keyframe.alpha.parameter = KeyframeParameters.ALPHA;
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
    
        element = create_image_button(room_width - 32 - sw, yy, "", spr_camera_icons, sw, sh, fa_middle, function(button) {
            Stuff.animation.x = 0;
            Stuff.animation.y = 160;
            Stuff.animation.z = 80;
            Stuff.animation.xto = 0;
            Stuff.animation.yto = 0;
            Stuff.animation.zto = 0;
            Stuff.animation.xup = 0;
            Stuff.animation.yup = 0;
            Stuff.animation.zup = 1;
            Stuff.animation.fov = 50;
            Stuff.animation.pitch = 0;
            Stuff.animation.direction = 0;
        }, id);
        element.index = 0;
        ds_list_add(contents, element);
    
        return id;
    }
    */
}
