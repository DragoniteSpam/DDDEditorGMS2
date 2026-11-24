enum EditorGizmos {
    NONE,
    X,
    Y,
    Z,
    XY,
    YZ,
    ZX
}

enum EditorGizmoModes {
    TRANSLATE,
    ROTATE,
    SCALE
}

function GizmoSystem() constructor {
    self.selected_gizmo = EditorGizmos.NONE;
    self.selected_gizmo_position = undefined;
    self.selected_gizmo_raw_x = undefined;
    self.gizmo_type = EditorGizmoModes.TRANSLATE;
    
    self.snapping_translate = 4;
    self.snapping_rotate = 10;
    self.snapping_scale = 0.25;
    
    // generally when you scale objects you want to scale them down a bit
    self.scale_scale = 1 / 32;
    
    self.position = new Vector3(0, 0, 0);
    
    static color_x = #ff3333;
    static color_y = #33ff33;
    static color_z = #3333ff;
    static color_xy = #ffff33;
    static color_yz = #33ffff;
    static color_zx = #ff33ff;
    static color_selected = #ffff99;
    
    static gizmos = undefined;
    static format_gizmos = undefined;
    
    if (format_gizmos == undefined) {
        vertex_format_begin();
        vertex_format_add_position_3d();
        format_gizmos = vertex_format_end();
        gizmos = penguin_load("data/graphics/gizmos.derg", format_gizmos);
    }
    
    static GetSelectionPlaneMouseLocation = function(mouse_pos, mouse_dir) {
        var ray = new ColRay(mouse_pos, mouse_dir);
        
        static test_plane_plus = new ColObject(undefined, undefined);
        static test_plane_minu = new ColObject(undefined, undefined);
        
        static plane_x_plus = new ColPlane(new Vector3( 1, 0, 0), 0);
        static plane_x_minu = new ColPlane(new Vector3(-1, 0, 0), 0);
        static plane_y_plus = new ColPlane(new Vector3(0,  1, 0), 0);
        static plane_y_minu = new ColPlane(new Vector3(0, -1, 0), 0);
        static plane_z_plus = new ColPlane(new Vector3(0, 0,  1), 0);
        static plane_z_minu = new ColPlane(new Vector3(0, 0, -1), 0);
        static ray_hit_info = new RaycastHitInformation();
        ray_hit_info.Clear();
        
        var axis_found = false;
        
        switch (self.gizmo_type) {
            // when you translate, you can use any plane that isn't the axis
            // of translation
            case EditorGizmoModes.TRANSLATE:
            case EditorGizmoModes.SCALE: {
                switch (self.selected_gizmo) {
                    // when you translate on the XY axis, use the XY plane
                    case EditorGizmos.X:
                    case EditorGizmos.Y: {
                        plane_z_plus.distance = self.position.z;
                        plane_z_minu.distance = self.position.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                        axis_found = true;
                    } break;
                    case EditorGizmos.Z: {
                        plane_y_plus.distance = self.position.y;
                        plane_y_minu.distance = self.position.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                        axis_found = true;
                    } break;
                    case EditorGizmos.XY: {
                        plane_z_plus.distance = self.position.z;
                        plane_z_minu.distance = self.position.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                        axis_found = true;
                    } break;
                    case EditorGizmos.YZ: {
                        plane_x_plus.distance = self.position.x;
                        plane_x_minu.distance = self.position.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                        axis_found = true;
                    } break;
                    case EditorGizmos.ZX: {
                        plane_y_plus.distance = self.position.y;
                        plane_y_minu.distance = self.position.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                        axis_found = true;
                    } break;
                }
            } break;
            case EditorGizmoModes.ROTATE: {
                switch (self.selected_gizmo) {
                    case EditorGizmos.X: {
                        plane_x_plus.distance = self.position.x;
                        plane_x_minu.distance = self.position.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                        axis_found = true;
                    } break;
                    case EditorGizmos.Y: {
                        plane_y_plus.distance = self.position.y;
                        plane_y_minu.distance = self.position.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                        axis_found = true;
                    } break;
                    case EditorGizmos.Z: {
                        plane_z_plus.distance = self.position.z;
                        plane_z_minu.distance = self.position.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                        axis_found = true;
                    } break;
                }
            } break;
        }
        
        if (axis_found) {
            if (test_plane_plus.CheckRay(ray, ray_hit_info)) {
                return ray_hit_info.point;
            }
            
            if (test_plane_minu.CheckRay(ray, ray_hit_info)) {
                return ray_hit_info.point;
            }
        }
        
        return new Vector3(0, 0, 0);
    };
    
    static Update = function(mx, my, mouse_pos, mouse_dir, surf_w, surf_h, callback_translate, callback_rotate, callback_scale) {
        var ray = new ColRay(mouse_pos, mouse_dir);
        
        if (!mouse_check_button(mb_left)) {
            self.selected_gizmo = EditorGizmos.NONE;
            self.selected_gizmo_position = undefined;
            self.selected_gizmo_raw_x = undefined;
        }
        
        static view_mat = matrix_build_identity();
        static proj_mat = matrix_build_identity();
        matrix_get(matrix_view, view_mat);
        matrix_get(matrix_projection, proj_mat);
        
        static editor_gizmo_translate = function(selected, delta, delta_threshold, callback_translate, scale = 1) {
            var rounded_delta = (delta_threshold > 0)
                ? delta.Div(delta_threshold / scale).Floor().Mul(delta_threshold / scale)
                : delta;
            
            var abs_delta = delta.Abs();
            
            switch (self.selected_gizmo) {
                case EditorGizmos.X: {
                    if (abs_delta.x >= delta_threshold) {
                        callback_translate(rounded_delta.x * scale, 0, 0);
                        self.selected_gizmo_position.x += rounded_delta.x;
                    }
                } break;
                case EditorGizmos.Y: {
                    if (abs_delta.y >= delta_threshold) {
                        callback_translate(0, rounded_delta.y * scale, 0);
                        self.selected_gizmo_position.y += rounded_delta.y;
                    }
                } break;
                case EditorGizmos.Z: {
                    if (abs_delta.z >= delta_threshold) {
                        callback_translate(0, 0, rounded_delta.z * scale);
                        self.selected_gizmo_position.z += rounded_delta.z;
                    }
                } break;
                // when you use the planes, look at the two axes separately,
                // otherwise you'll get a lot of drift
                case EditorGizmos.XY: {
                    if (abs_delta.x >= delta_threshold) {
                        callback_translate(rounded_delta.x * scale, 0, 0);
                        self.selected_gizmo_position.x += rounded_delta.x;
                    }
                    if (abs_delta.y >= delta_threshold) {
                        callback_translate(0, rounded_delta.y * scale, 0);
                        self.selected_gizmo_position.y += rounded_delta.y;
                    }
                } break;
                case EditorGizmos.YZ: {
                    if (abs_delta.y >= delta_threshold) {
                        callback_translate(0, rounded_delta.y * scale, 0);
                        self.selected_gizmo_position.y += rounded_delta.y;
                    }
                    if (abs_delta.z >= delta_threshold) {
                        callback_translate(0, 0, rounded_delta.z * scale);
                        self.selected_gizmo_position.z += rounded_delta.z;
                    }
                } break;
                case EditorGizmos.ZX: {
                    if (abs_delta.z >= delta_threshold) {
                        callback_translate(0, 0, rounded_delta.z * scale);
                        self.selected_gizmo_position.z += rounded_delta.z;
                    }
                    if (abs_delta.x >= delta_threshold) {
                        callback_translate(rounded_delta.x * scale, 0, 0);
                        self.selected_gizmo_position.x += rounded_delta.x;
                    }
                } break;
            }
        };
        
        static editor_gizmo_rotate = function(selected, delta, delta_threshold, callback_rotate, current_position) {
            if (abs(delta) < delta_threshold) {
                return;
            }
            
            if (delta_threshold > 0) {
                delta = floor(delta / delta_threshold) * delta_threshold;
            }
            
            switch (self.selected_gizmo) {
                case EditorGizmos.X: {
                    callback_rotate(delta, 0, 0);
                } break;
                case EditorGizmos.Y: {
                    callback_rotate(0, delta, 0);
                } break;
                case EditorGizmos.Z: {
                    callback_rotate(0, 0, delta);
                } break;
            }
            
            self.selected_gizmo_raw_x = current_position;
        }
        
        if (mouse_check_button_pressed(mb_left)) {
            static mouse_surf = -1;
            mouse_surf = surface_validate(mouse_surf, surf_w, surf_h);
            
            // figure out what you clicked on
            surface_set_target(mouse_surf);
            
                matrix_set(matrix_view, view_mat);
                matrix_set(matrix_projection, proj_mat);
                draw_clear(c_black);
                
                self.DrawGizmos();
            
            surface_reset_target();
            
            // yes this is slow
            switch (surface_getpixel(mouse_surf, mx, my)) {
                case color_x: self.selected_gizmo = EditorGizmos.X; break;
                case color_y: self.selected_gizmo = EditorGizmos.Y; break;
                case color_z: self.selected_gizmo = EditorGizmos.Z; break;
                case color_xy: self.selected_gizmo = EditorGizmos.XY; break;
                case color_yz: self.selected_gizmo = EditorGizmos.YZ; break;
                case color_zx: self.selected_gizmo = EditorGizmos.ZX; break;
            }
            
            // code that happens when you first select a gizmo thingy
            if (self.selected_gizmo != EditorGizmos.NONE) {
                self.selected_gizmo_position = self.GetSelectionPlaneMouseLocation(mouse_pos, mouse_dir);
                self.selected_gizmo_raw_x = window_mouse_get_x();
            }
        }
        
        if (mouse_check_button(mb_left)) {
            if (self.selected_gizmo != EditorGizmos.NONE) {
                // 3D mouse delta
                var current_gizmo_mouse_position = self.GetSelectionPlaneMouseLocation(mouse_pos, mouse_dir);
                var delta = current_gizmo_mouse_position.Sub(self.selected_gizmo_position);
                
                // 1D mouse delta
                var current_gizmo_mouse_raw_x = window_mouse_get_x();
                var delta_raw_x = current_gizmo_mouse_raw_x - self.selected_gizmo_raw_x;
                
                switch (self.gizmo_type) {
                    case EditorGizmoModes.TRANSLATE: {
                        editor_gizmo_translate(selected, delta, self.snapping_translate, callback_translate);
                    } break;
                    case EditorGizmoModes.ROTATE: {
                        editor_gizmo_rotate(selected, delta_raw_x, self.snapping_rotate, callback_rotate, current_gizmo_mouse_raw_x);
                    } break;
                    // scale uses the same logic as translate
                    case EditorGizmoModes.SCALE: {
                        editor_gizmo_translate(selected, delta, self.snapping_scale, callback_scale, self.scale_scale);
                    } break;
                }
            }
        }
    };
    
    static Render = function() {
        self.DrawGizmos();
    };
    
    static DrawGizmos = function() {
        static previous_matrix = matrix_build_identity();
        matrix_get(matrix_world, previous_matrix);
        
        var shader = shader_current();
        shader_set(shd_gizmos);
        
        matrix_set(matrix_world, matrix_build(self.position.x, self.position.y, self.position.z, 0, 0, 0, 25, 25, 25));
        
        gpu_push_state();
        
        gpu_set_ztestenable(true);
        gpu_set_zwriteenable(true);
        
        switch (self.gizmo_type) {
            case EditorGizmoModes.TRANSLATE: {
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.X ? color_selected : color_x);
                gizmos.translate_x.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.Y ? color_selected : color_y);
                gizmos.translate_y.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.Z ? color_selected : color_z);
                gizmos.translate_z.Render();
                
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.XY ? color_selected : color_xy);
                gizmos.translate_xy.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.YZ ? color_selected : color_yz);
                gizmos.translate_yz.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.ZX ? color_selected : color_zx);
                gizmos.translate_zx.Render();
            } break;
            case EditorGizmoModes.ROTATE: {
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.X ? color_selected : color_x);
                gizmos.rotate_x.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.Y ? color_selected : color_y);
                gizmos.rotate_y.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.Z ? color_selected : color_z);
                gizmos.rotate_z.Render();
            } break;
            case EditorGizmoModes.SCALE: {
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.X ? color_selected : color_x);
                gizmos.scale_x.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.Y ? color_selected : color_y);
                gizmos.scale_y.Render();
                self.SetDrawColor(self.selected_gizmo == EditorGizmos.Z ? color_selected : color_z);
                gizmos.scale_z.Render();
            } break;
        }
        
        matrix_set(matrix_world, previous_matrix);
        
        if (shader != -1) {
            shader_set(shader);
        }
        
        gpu_pop_state();
    };
    
    static SetDrawColor = function(color) {
        shader_set_uniform_f(shader_get_uniform(shd_gizmos, "u_color"), color_get_red(color) / 255, color_get_green(color) / 255, color_get_blue(color) / 255);
    };
    
    static SetPosition = function(position) {
        self.position.x = position.x;
        self.position.y = position.y;
        self.position.z = position.z;
    };
    
    static SetSnapping = function(translate = self.snapping_translate, rotate = self.snapping_rotate, scale = self.snapping_scale) {
        self.snapping_translate = translate;
        self.snapping_rotate = rotate;
        self.snapping_scale = scale;
    };
}