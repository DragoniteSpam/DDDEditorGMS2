function sprite_dialog_rearrange(sprite) {
    var dw = 1440;
    var dh = 840;
    var dialog = new EmuDialog(dw, dh, "Rearrange Sprite");
    dialog.AddContent([
        new EmuRenderSurface(32, 32, dw - 64, dh - 140, function(mx, my) {
            // render
            self.minicam.Apply();
            
            static selection_surface = -1;
            static selection_buffer = buffer_create(100, buffer_fixed, 1);
            
            var sw = surface_get_width(self.root.surf);
            var sh = surface_get_height(self.root.surf);
            
            draw_sprite_tiled(spr_emu_checker, 0, 0, 0);
            
            draw_set_color(c_black);
            draw_set_alpha(0.5);
            var size = 10_000;
            draw_rectangle(-size, -size, size, -1, false);
            draw_rectangle(-size, sh + 1, size, size, false);
            draw_rectangle(-size, 0, 0, sh, false);
            draw_rectangle(sw, 0, size, sh, false);
            draw_set_color(c_white);
            draw_set_alpha(1);
            
            // draw the main surface
            if (!surface_exists(self.root.surf)) {
                self.root.surf = surface_create(sw, sh);
                buffer_set_surface(self.root.backup, self.root.surf, 0);
            }
            
            draw_surface(self.root.surf, 0, 0);
            
            // draw the selection surface, if there is one
            if (self.selection) {
                if (self.selection.Area() >= 1) {
                    if (!surface_exists(self.root.selection_surface)) {
                        self.root.selection_surface = surface_create(self.selection.W(), self.selection.H())
                        buffer_set_surface(self.root.selection_surface_backup, self.root.selection_surface, 0);
                    }
                    
                    draw_surface(self.root.selection_surface, self.selection.X1(), self.selection.Y1());
                }
            }
            
            // if the values in the input box are invalid, use the last valid ones
            static grid = 32;
            static thickness = 1;
            static grid_w = 0;
            static grid_h = 0;
            
            if (self.GetSibling("WIDTH").value != "") {
                grid_w = real(self.GetSibling("WIDTH").value);
            }
            
            if (self.GetSibling("HEIGHT").value != "") {
                grid_h = real(self.GetSibling("HEIGHT").value);
            }
            
            if (self.GetSibling("SNAP").value != "") {
                grid = real(self.GetSibling("SNAP").value);
            }
            
            if (self.GetSibling("THICKNESS").value != "") {
                thickness = real(self.GetSibling("THICKNESS").value);
            }
            
            if (grid > 0) {
                var mid_x = power(2, ceil(log2(grid_w div 2)));
                var mid_y = power(2, ceil(log2(grid_h div 2)));
                
                for (var xx = 0; xx <= grid_w; xx += grid) {
                    var ww = (xx == 0 || xx > grid_w - grid) ? (thickness + 2) : thickness;
                    var c = #330000;
                    if (xx == mid_x) {
                        c = c_red;
                        ww++;
                    }
                    draw_line_width_color(xx, 0, xx, grid_h - 1, ww, c, c);
                }
                for (var yy = 0; yy <= grid_h; yy += grid) {
                    var ww = (yy == 0 || yy > grid_h - grid) ? (thickness + 2) : thickness;
                    var c = #330000;
                    if (yy == mid_y) {
                        c = c_red;
                        ww++;
                    }
                    draw_line_width_color(0, yy, grid_w - 1, yy, ww, c, c);
                }
            }
            
            var mouse = self.minicam.GetWorldSpace(mx, my);
            if (grid > 0) {
                mouse.x = round(mouse.x / grid) * grid;
                mouse.y = round(mouse.y / grid) * grid;
            }
            
            if (mouse_check_button_pressed(mb_left)) {
                // if you click on the existing selection, start moving it
                if (self.selection) {
                    if (self.selection.Contains(mouse.x, mouse.y)) {
                        self.selection_moving = true;
                        self.selection_snap_mouse_x = mouse.x;
                        self.selection_snap_mouse_y = mouse.y;
                    }
                }
                
                if (!self.selection_moving) {
                    // if there is an existing selection but you don't click on
                    // it, cut a hole and commit the selection
                    if (self.selection) {
                        self.root.CutHole(self.selection.X1(), self.selection.Y1(), self.selection.W(), self.selection.H());
                        self.root.PasteSelection(self.selection.X1(), self.selection.Y1());
                    }
                    
                    // create a new selection
                    self.selection = new Rectangle(mouse.x, mouse.y, mouse.x, mouse.y);
                    self.root.EraseSelection();
                }
            }
            
            if (mouse_check_button(mb_left)) {
                // if you are holding the button and moving a selection, apply
                // the mouse delta to the selection rectangle
                if (self.selection_moving) {
                    var dx = mouse.x - self.selection_snap_mouse_x;
                    var dy = mouse.y - self.selection_snap_mouse_y;
                    var du = dx / sw;
                    var dv = dy / sh;
                    
                    self.selection.x1 += dx;
                    self.selection.y1 += dy;
                    self.selection.x2 += dx;
                    self.selection.y2 += dy;
                    self.selection_snap_mouse_x += dx;
                    self.selection_snap_mouse_y += dy;
                    
                    for (var i = 0, n = array_length(self.root.using); i < n; i++) {
                        var what = self.root.using[i];
                        for (var j = 0, n2 = array_length(what.selected_vertices); j < n2; j++) {
                            var address = what.selected_vertices[j];
                            var u = buffer_peek(what.data, address + 24, buffer_f32);
                            var v = buffer_peek(what.data, address + 28, buffer_f32);
                            buffer_poke(what.data, address + 24, buffer_f32, u + du);
                            buffer_poke(what.data, address + 28, buffer_f32, v + dv);
                        }
                        vertex_update_buffer_from_buffer(what.vbuffer, 0, what.data);
                    };
                // if you are holding the button and creating a selection,
                // resize the selection
                } else if (self.selection) {
                    self.selection.x2 = mouse.x;
                    self.selection.y2 = mouse.y;
                }
            }
            
            if (mouse_check_button_released(mb_left)) {
                // if you release the button and there is a selection, if the
                // selection has zero surface area, unselect
                if (self.selection) {
                    if (self.selection.Area() < 1) {
                        self.selection = undefined;
                    } else {
                        // otherwise, copy the selection region and cut a hole
                        if (!self.selection_moving) {
                            self.root.CutSurface(self.selection.X1(), self.selection.Y1(), self.selection.W(), self.selection.H());
                            self.root.CutHole(self.selection.X1(), self.selection.Y1(), self.selection.W(), self.selection.H());
                            // mark vertices in the selection region
                            var u1 = self.selection.X1() / sw;
                            var v1 = self.selection.Y1() / sh;
                            var u2 = self.selection.X2() / sw;
                            var v2 = self.selection.Y2() / sh;
                            
                            for (var i = 0, n = array_length(self.root.using); i < n; i++) {
                                var what = self.root.using[i];
                                array_resize(what.selected_vertices, 0);
                                for (var j = 0, n2 = buffer_get_size(what.data); j < n2; j += VERTEX_SIZE) {
                                    var u = buffer_peek(what.data, j + 24, buffer_f32);
                                    var v = buffer_peek(what.data, j + 28, buffer_f32);
                                    
                                    if (point_in_rectangle(u, v, u1, v1, u2, v2)) {
                                        array_push(what.selected_vertices, j);
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.selection_moving = false;
            }
            
            if (keyboard_check(vk_escape)) {
                if (self.selection) {
                    self.root.PasteSelection(self.selection.X1(), self.selection.Y1());
                    self.selection = undefined;
                }
            }
            
            if (self.selection) {
                var x1 = self.selection.X1();
                var y1 = self.selection.Y1();
                var x2 = self.selection.X2();
                var y2 = self.selection.Y2();
                
                draw_set_color(#6666ff);
                draw_set_alpha(0.5);
                draw_rectangle(x1, y1, x2, y2, false);
                draw_set_color(c_white);
                draw_set_alpha(1);
            }
            
            shader_set(shd_texture_mapping);
            matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, sw, sh, 1));
            wireframe_enable(1, 10000, c_blue, thickness * 2 / self.minicam.zoom);
            
            var using = self.root.using;
            
            array_foreach(using, function(data) {
                vertex_submit(data.vbuffer, pr_trianglelist, -1);
            });
            
            matrix_set(matrix_world, matrix_build_identity());
            shader_reset();
        }, function(mx, my) {
            // step
            
            self.minicam.Update(mx, my, 0, 0, self.width - 1, self.height - 1);
        }, function() {
            // create
            self.minicam = new DragoMinicam(self.width / 2, self.height / 2, self.width, self.height);
            self.selection = undefined;
            self.selection_moving = false;
            self.selection_snap_mouse_x = 0;
            self.selection_snap_mouse_y = 0;
        }),
        new EmuInput(32, EMU_AUTO, 240, 32, "Grid size:", "32", "in pixels", 2, E_InputTypes.INT, emu_null)
            .SetID("SNAP"),
        new EmuInput(32 + (240 + 32) * 1, EMU_INLINE, 240, 32, "Grid Width:", "1", "in pixels", 1, E_InputTypes.INT, emu_null)
            .SetID("THICKNESS"),
        new EmuInput(32 + (240 + 32) * 2, EMU_INLINE, 240, 32, "Width:", string(sprite_get_width(sprite.picture)), "in pixels", 4, E_InputTypes.INT, emu_null)
            .SetRealNumberBounds(1, sprite_get_width(sprite.picture))
            .SetID("WIDTH")
            .SetNext("HEIGHT")
            .SetPrevious("HEIGHT"),
        new EmuInput(32 + (240 + 32) * 3, EMU_INLINE, 240, 32, "Height:", string(sprite_get_height(sprite.picture)), "in pixels", 4, E_InputTypes.INT, emu_null)
            .SetRealNumberBounds(1, sprite_get_width(sprite.picture))
            .SetID("HEIGHT")
            .SetNext("WIDTH")
            .SetPrevious("WIDTH"),
        new EmuText(32 + (240 + 32) * 4, EMU_INLINE, 240, 32, "")
            .SetTextUpdate(function() {
                var w = self.GetSibling("WIDTH").value;
                var h = self.GetSibling("HEIGHT").value;
                static last_valid_value = "";
                if (w != "" && h != "") {
                    last_valid_value = $"Size: {floor(real(w) * real(h) * 4 / 1024)} kb";
                }
                return last_valid_value;
            })
    ]);
    dialog.AddDefaultConfirmCancelButtons("Confirm", function() {
        // confirm
        var sw = sprite_get_width(self.root.sprite.picture);
        var sh = sprite_get_height(self.root.sprite.picture);
        var grid_w = (self.GetSibling("WIDTH").value != "") ? real(self.GetSibling("WIDTH").value) : sw;
        var grid_h = (self.GetSibling("HEIGHT").value != "") ? real(self.GetSibling("HEIGHT").value) : sh;
        var text = "Would you like to save these changes?";
        
        if (grid_w < sw || grid_h < sh) {
            text += "\nThe original sprite will be cropped."
        }
        
        emu_dialog_confirm(self.root, text, function() {
            emu_dialog_close_auto();
            with (self.root) {
                var sw = sprite_get_width(self.root.sprite.picture);
                var sh = sprite_get_height(self.root.sprite.picture);
                var final_w = (self.GetSibling("WIDTH").value != "") ? real(self.GetSibling("WIDTH").value) : sw;
                var final_h = (self.GetSibling("HEIGHT").value != "") ? real(self.GetSibling("HEIGHT").value) : sh;
                sprite_delete(self.root.sprite.picture);
                self.root.sprite.picture = sprite_create_from_surface(self.root.surf, 0, 0, final_w, final_h, false, false, 0, 0);
                self.root.sprite.width = final_w;
                self.root.sprite.height = final_h;
                
                for (var i = 0, n = array_length(self.root.using); i < n; i++) {
                    var data = self.root.using[i];
                    meshops_transform_uvs(data.data, 0, buffer_get_size(data.data), 0, 0, 1, 1, 0, 0, sw / final_w, sh / final_h);
                    buffer_delete(data.submesh.buffer);
                    data.submesh.buffer = data.data;
                    data.submesh.internalSetVertexBuffer();
                    data.data = undefined;
                };
                emu_dialog_close_auto();
                // rolls eyes
                with (self.root.root) {
                    self.Refresh({ list: self.graphics_list, index: self.GetChild("LIST").GetSelection() });
                }
            }
        });
    }, "Cancel", function() {
        // cancel
        emu_dialog_close_auto();
    });
    
    dialog.SetCallback(function() {
        self.cleanup(self.using);
        self.Close();
    });
    
    dialog.close_button = false;
    dialog.y = 0;
    dialog.sprite = sprite;
    var all_using_submeshes = sprite_get_using_as_texture(sprite);
    dialog.using = array_map(all_using_submeshes, function(submesh) {
        var clone_data = buffer_clone(submesh.buffer);
        return {
            submesh,
            data: clone_data,
            vbuffer: vertex_create_buffer_from_buffer(clone_data, Stuff.graphics.format),
            selected_vertices: []
        };
    });
    
    var sw = sprite_get_width(sprite.picture);
    var sh = sprite_get_height(sprite.picture);
    
    dialog.surf = surface_create(sw, sh);
    surface_set_target(dialog.surf);
    draw_clear_alpha(c_black, 0);
    
        gpu_set_blendmode(bm_add);
        draw_sprite(sprite.picture, 0, 0, 0);
        gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
    dialog.backup = buffer_create(sw * sh * 4, buffer_fixed, 1);
    buffer_get_surface(dialog.backup, dialog.surf, 0);
    
    dialog.selection_surface = -1;
    dialog.selection_surface_backup = buffer_create(100, buffer_fixed, 1);
    
    dialog.CutSurface = method(dialog, function(x, y, w, h) {
        self.selection_surface = surface_validate(self.selection_surface, w, h);
        
        surface_set_target(self.selection_surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_blendmode(bm_add);
        
        draw_surface_part(self.surf, x, y, w, h, 0, 0);
        
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
        
        surface_set_target(self.surf);
        
        surface_reset_target();
        
        buffer_resize(self.selection_surface_backup, w * h * 4);
        buffer_get_surface(self.selection_surface_backup, self.selection_surface, 0);
    });
    
    dialog.CutHole = method(dialog, function(x, y, w, h) {
        surface_set_target(self.surf);
        gpu_set_blendmode(bm_subtract);
        
        draw_set_color(c_white);
        draw_rectangle(x, y, x + w - 1, y + h - 1, false);
        
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
        
        buffer_get_surface(self.backup, self.surf, 0);
    });
    
    dialog.PasteSelection = method(dialog, function(x, y) {
        if (surface_exists(self.selection_surface)) {
            surface_set_target(self.surf);
            gpu_set_blendmode(bm_add);
            
            draw_surface(self.selection_surface, x, y);
            
            gpu_set_blendmode(bm_normal);
            surface_reset_target();
            
            buffer_get_surface(self.backup, self.surf, 0);
        }
    });
    
    dialog.EraseSelection = method(dialog, function() {
        if (surface_exists(self.selection_surface)) {
            surface_set_target(self.selection_surface);
            draw_clear_alpha(c_black, 0);
            surface_reset_target();
            buffer_get_surface(self.selection_surface_backup, self.selection_surface, 0);
        }
    });
    
    dialog.cleanup = method(dialog, function(using) {
        if (surface_exists(self.surf)) {
            surface_free(self.surf);
        }
        if (surface_exists(self.selection_surface)) {
            surface_free(self.selection_surface);
        }
        buffer_delete(self.backup);
        
        array_foreach(using, function(data) {
            // this may have already been deleted if you clicked Confirm
            if (buffer_exists(data.data)) {
                buffer_delete(data.data);
            }
            vertex_delete_buffer(data.vbuffer);
        });
    });
    
    return dialog;
}