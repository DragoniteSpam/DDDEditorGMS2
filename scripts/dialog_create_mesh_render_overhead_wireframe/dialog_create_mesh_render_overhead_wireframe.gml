function dialog_create_mesh_render_overhead_wireframe(mesh) {
    var dw = 1200;
    var dh = 736;
    
    var c1x = 32;
    var c2x = 416;
    
    var dialog = new EmuDialog(dw, dh, "Render Overhead Wireframe");
    dialog.mesh = mesh;
    dialog.render = undefined;
    
    dialog.create_render = method(dialog, function() {
        var cutoff_low = real(self.GetChild("CUTOFF LOW").value);
        var cutoff_high = real(self.GetChild("CUTOFF HIGH").value);
        var line_width = real(self.GetChild("WIDTH").value);
        var line_width_out_of_bounds = real(self.GetChild("WIDTH OOB").value);
        var line_color = real(self.GetChild("COLOR").value);
        var line_color_out_of_bounds = real(self.GetChild("COLOR OOB").value);
        var mesh = self.mesh;
        var minx = mesh.physical_bounds.x1;
        var miny = mesh.physical_bounds.y1;
        var minz = mesh.physical_bounds.z1;
        var maxx = mesh.physical_bounds.x2;
        var maxy = mesh.physical_bounds.y2;
        var maxz = mesh.physical_bounds.z2;
        
        var sw = maxx - minx;
        var sh = maxy - miny;
        
        var surface = surface_create(sw, sh);
        
        surface_set_target(surface);
        draw_clear_alpha(c_black, 0);
        
        var grid_size_element = self.GetChild("GRID SIZE");
        var step = (grid_size_element.value != "") ? real(grid_size_element.value) : 0;
        
        static draw_grid = function(step, xx, yy, ww, hh, a) {
            if (step > 0) {
                draw_set_alpha(a);
                var cx = xx;
                while (true) {
                    draw_line_colour(cx, 0, cx, self.height, c_white, c_white);
                    cx -= step;
                    if (cx <= 0) break;
                }
                cx = xx;
                while (true) {
                    draw_line_colour(cx, 0, cx, self.height, c_white, c_white);
                    cx += step;
                    if (cx >= ww) break;
                }
            
                var cy = yy;
                while (true) {
                    draw_line_colour(0, cy, self.width, cy, c_white, c_white);
                    cy -= step;
                    if (cy <= 0) break;
                }
                cy = yy;
                while (true) {
                    draw_line_colour(0, cy, self.width, cy, c_white, c_white);
                    cy += step;
                    if (cy >= hh) break;
                }
                draw_set_alpha(1);
                draw_line_width_colour(xx, 0, xx, self.height, 2, c_green, c_green);
                draw_line_width_colour(0, yy, self.width, yy, 2, c_red, c_red);
            }
        }
        
        draw_grid(step, -mesh.physical_bounds.x1, -mesh.physical_bounds.y1, sw, sh, 1);
        
        gpu_set_ztestenable(true);
        
        for (var i = 0, n = array_length(mesh.submeshes); i < n; i++) {
            var buffer = mesh.submeshes[i].buffer;
            for (var j = 0, n2 = buffer_get_size(buffer); j < n2; j += VERTEX_SIZE * 3) {
                var x1 = buffer_peek(buffer, j + 0 * VERTEX_SIZE + 0, buffer_f32) - minx;
                var y1 = buffer_peek(buffer, j + 0 * VERTEX_SIZE + 4, buffer_f32) - miny;
                var z1 = buffer_peek(buffer, j + 0 * VERTEX_SIZE + 8, buffer_f32);
                var x2 = buffer_peek(buffer, j + 1 * VERTEX_SIZE + 0, buffer_f32) - minx;
                var y2 = buffer_peek(buffer, j + 1 * VERTEX_SIZE + 4, buffer_f32) - miny;
                var z2 = buffer_peek(buffer, j + 1 * VERTEX_SIZE + 8, buffer_f32);
                var x3 = buffer_peek(buffer, j + 2 * VERTEX_SIZE + 0, buffer_f32) - minx;
                var y3 = buffer_peek(buffer, j + 2 * VERTEX_SIZE + 4, buffer_f32) - miny;
                var z3 = buffer_peek(buffer, j + 2 * VERTEX_SIZE + 8, buffer_f32);
                
                var inbounds = ((z1 >= cutoff_low && z2 >= cutoff_low && z3 >= cutoff_low) && (z1 <= cutoff_high && z2 <= cutoff_high && z3 <= cutoff_high));
                gpu_set_depth(inbounds ? 16 : -16);
                var cc = inbounds ? line_color : line_color_out_of_bounds;
                var ww = inbounds ? line_width : line_width_out_of_bounds;
                
                draw_line_width_colour(x1, y1, x2, y2, ww, cc, cc);
                draw_line_width_colour(x1, y1, x3, y3, ww, cc, cc);
                draw_line_width_colour(x2, y2, x3, y3, ww, cc, cc);
            }
        }
        
        gpu_set_ztestenable(false);
        gpu_set_depth(0);
        
        draw_grid(step, -mesh.physical_bounds.x1, -mesh.physical_bounds.y1, sw, sh, 0.3);
        
        draw_circle_colour(-minx, -miny, 8, c_white, c_white, false);
        draw_point_colour(-minx, -miny, c_black);
        
        surface_reset_target();
        
        self.render = sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);
        surface_free(surface);
    });
    
    return dialog.AddContent([
        new EmuInput(c1x, 32, 320, 32, "Low cutoff:", "0", "", 6, E_InputTypes.REAL, function() {
            self.root.create_render();
        })
            .SetID("CUTOFF LOW"),
        new EmuInput(c1x, EMU_AUTO, 320, 32, "High cutoff:", "32", "", 6, E_InputTypes.REAL, function() {
            self.root.create_render();
        })
            .SetID("CUTOFF HIGH"),
        new EmuText(c1x, EMU_AUTO, 160, 32, "Line width:"),
        new EmuProgressBar(c1x + 160, EMU_INLINE, 160, 32, 8, 1, 9, true, 4, function() {
            self.root.create_render();
        })
            .SetID("WIDTH"),
        new EmuText(c1x, EMU_AUTO, 160, 32, "    Out of bounds:"),
        new EmuProgressBar(c1x + 160, EMU_INLINE, 160, 32, 8, 1, 9, true, 1, function() {
            self.root.create_render();
        })
            .SetID("WIDTH OOB"),
        new EmuColorPicker(c1x, EMU_AUTO, 320, 32, "Line color:", c_blue, function() {
            self.root.create_render();
        })
            .SetID("COLOR"),
        new EmuColorPicker(c1x, EMU_AUTO, 320, 32, "    Out of bounds:", c_gray, function() {
            self.root.create_render();
        })
            .SetID("COLOR OOB"),
        new EmuInput(c1x, EMU_AUTO, 320, 32, "Grid size:", "16", "", 3, E_InputTypes.INT, emu_null)
            .SetID("GRID SIZE"),
        new EmuButton(c1x, EMU_AUTO, 320, 32, "Save", function() {
            var filename = get_save_filename("PNG files|*.png", self.root.mesh.name + "_wireframe.png");
            if (filename != "") {
                sprite_save(self.root.render, 0, filename);
            }
        }),
        new EmuRenderSurface(c2x, 32, 640, 640, function() {
            if (self.root.render == undefined) {
                self.root.create_render();
            }
            draw_sprite(self.root.render, 0, 0, 0);
        }, emu_null, emu_null, function() {
            if (sprite_exists(self.root.render)) {
                sprite_delete(self.root.render);
            }
        })
    ]).AddDefaultCloseButton();
}