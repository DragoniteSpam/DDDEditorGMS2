function sprite_dialog_rearrange(sprite) {
    var dialog = new EmuDialog(960, 840, "Rearrange Sprite");
    dialog.AddContent([
        new EmuRenderSurface(32, 32, 960 - 64, 840 - 140, function(mx, my) {
            // render
            self.minicam.Apply();
            
            draw_sprite_tiled(spr_emu_checker, 0, 0, 0);
            
            draw_sprite(self.root.sprite.picture, 0, 0, 0);
            
            var sw = sprite_get_width(self.root.sprite.picture);
            var sh = sprite_get_height(self.root.sprite.picture);
            
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
            var selection_moving = false;
            
            if (mouse_check_button_pressed(mb_left)) {
                if (self.selection) {
                    if (point_in_rectangle(mouse.x, mouse.y, self.selection.x1, self.selection.y1, self.selection.x2, self.selection.y2)) {
                        selection_moving = true;
                    }
                }
                
                if (!selection_moving) {
                    self.selection = {
                        x1: mouse.x,
                        y1: mouse.y,
                        x2: mouse.x,
                        y2: mouse.y
                    }
                }
            }
            
            if (mouse_check_button(mb_left)) {
                if (selection_moving) {
                    // do the "moving selection" logic here
                    // and remember to update the selection coordinates by the mouse delta
                } else if (self.selection) {
                    self.selection.x2 = mouse.x;
                    self.selection.y2 = mouse.y;
                }
            }
            
            if (mouse_check_button_released(mb_left)) {
                if (self.selection) {
                    if (abs(self.selection.x1 - self.selection.x2) < 0.5 || abs(self.selection.y1 - self.selection.y2) < 0.5) {
                        self.selection = undefined;
                    }
                }
            }
            
            if (self.selection) {
                var x1 = min(self.selection.x1, self.selection.x2);
                var y1 = min(self.selection.y1, self.selection.y2);
                var x2 = max(self.selection.x1, self.selection.x2);
                var y2 = max(self.selection.y1, self.selection.y2);
                
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
        }),
        new EmuInput(32, EMU_AUTO, 256, 32, "Grid size:", "32", "in pixels", 1, E_InputTypes.INT, emu_null)
            .SetID("SNAP"),
        new EmuInput(32 + 256 + 32, EMU_INLINE, 256, 32, "Grid thickness:", "1", "in pixels", 1, E_InputTypes.INT, emu_null)
            .SetID("THICKNESS")
    ]);
    dialog.AddDefaultConfirmCancelButtons("Confirm", function() {
        // confirm
    }, "Cancel", function() {
        // cancel
    });
    dialog.y = 0;
    return dialog;
}