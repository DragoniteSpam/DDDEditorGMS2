function sprite_dialog_rearrange(sprite) {
    var dialog = new EmuDialog(960, 840, "Rearrange Sprite");
    dialog.AddContent([
        new EmuRenderSurface(32, 32, 960 - 64, 840 - 140, function(mx, my) {
            // render
            self.minicam.Apply();
            
            static selection_surface = -1;
            static selection_buffer = buffer_create(100, buffer_fixed, 1);
            
            var sw = sprite_get_width(self.root.sprite.picture);
            var sh = sprite_get_height(self.root.sprite.picture);
            
            draw_sprite_tiled(spr_emu_checker, 0, 0, 0);
            
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
            
            var grid = self.GetSibling("SNAP").value;
            var thickness = self.GetSibling("THICKNESS").value;
            
            thickness = (thickness != "") ? real(thickness) : 1;
            
            if (grid != "") {
                grid = real(grid);
                for (var xx = 0; xx <= sw; xx += grid) {
                    var ww = (xx == 0 || xx > sw - grid) ? (thickness + 2) : thickness;
                    draw_line_width_color(xx, 0, xx, sh - 1, ww, c_red, c_red);
                }
                for (var yy = 0; yy <= sh; yy += grid) {
                    var ww = (yy == 0 || yy > sh - grid) ? (thickness + 2) : thickness;
                    draw_line_width_color(0, yy, sw - 1, yy, ww, c_red, c_red);
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
                        // we also need to move any and all vertex UVs
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
                    self.selection.x1 += dx;
                    self.selection.y1 += dy;
                    self.selection.x2 += dx;
                    self.selection.y2 += dy;
                    self.selection_snap_mouse_x += dx;
                    self.selection_snap_mouse_y += dy;
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
                        }
                    }
                }
                
                self.selection_moving = false;
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
        new EmuInput(32, EMU_AUTO, 256, 32, "Grid size:", "32", "in pixels", 1, E_InputTypes.INT, emu_null)
            .SetID("SNAP"),
        new EmuInput(32 + 256 + 32, EMU_INLINE, 256, 32, "Grid thickness:", "1", "in pixels", 1, E_InputTypes.INT, emu_null)
            .SetID("THICKNESS")
    ]);
    dialog.AddDefaultConfirmCancelButtons("Confirm", function() {
        // confirm
        emu_dialog_confirm(self.root, "Would you like to save these changes?", function() {
            emu_dialog_close_auto();
            with (self.root) {
                sprite_delete(self.root.sprite.picture);
                self.root.sprite.picture = sprite_create_from_surface(self.root.surf, 0, 0, surface_get_width(self.root.surf), surface_get_height(self.root.surf), false, false, 0, 0);
                emu_dialog_close_auto();
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
    
    dialog.y = 0;
    dialog.sprite = sprite;
    var all_using_submeshes = sprite_get_using_as_texture(sprite);
    dialog.using = array_map(all_using_submeshes, function(submesh) {
        var clone_data = buffer_clone(submesh.buffer);
        return {
            submesh,
            data: clone_data,
            vbuffer: vertex_create_buffer_from_buffer(clone_data, Stuff.graphics.format)
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
            buffer_delete(data.data);
            vertex_delete_buffer(data.vbuffer);
        });
    });
    
    return dialog;
}