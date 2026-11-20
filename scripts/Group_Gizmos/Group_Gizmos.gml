enum EditorGizmos {
    NONE,
    X,
    Y,
    Z
}

enum EditorGizmoModes {
    TRANSLATE,
    ROTATE,
    SCALE
}

function GizmoSystem() constructor {
    self.selected_gizmo = EditorGizmos.NONE;
    self.selected_gizmo_position = undefined;
    self.gizmo_type = EditorGizmoModes.TRANSLATE;
    
    self.snapping_translate = 4;
    self.snapping_rotate = 10;
    
    self.position = new Vector3(0, 0, 0);
    
    static gizmos = undefined;
    static format_gizmos = undefined;
    if (format_gizmos == undefined) {
        vertex_format_begin();
        vertex_format_add_position_3d()
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        format_gizmos = vertex_format_end();
        gizmos = penguin_load("data/graphics/gizmos.derg", format_gizmos);
    }
    
    static GetSelectionPlaneMouseLocation = function(mouse_pos, mouse_dir) {
        var mx = window_mouse_get_x();
        var my = window_mouse_get_y();
        
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
        
        switch (self.gizmo_type) {
            // when you translate, you can use any plane that isn't the axis
            // of translation
            case EditorGizmoModes.TRANSLATE:
            case EditorGizmoModes.SCALE: {
                switch (self.selected_gizmo) {
                    case EditorGizmos.X: {
                        plane_z_plus.distance = self.position.z;
                        plane_z_minu.distance = self.position.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                    } break;
                    case EditorGizmos.Y: {
                        plane_x_plus.distance = self.position.x;
                        plane_x_minu.distance = self.position.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                    } break;
                    case EditorGizmos.Z: {
                        plane_y_plus.distance = self.position.y;
                        plane_y_minu.distance = self.position.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
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
                    } break;
                    case EditorGizmos.Y: {
                        plane_y_plus.distance = self.position.y;
                        plane_y_minu.distance = self.position.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                    } break;
                    case EditorGizmos.Z: {
                        plane_z_plus.distance = self.position.z;
                        plane_z_minu.distance = self.position.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                    } break;
                }
            } break;
        }
        
        if (test_plane_plus.CheckRay(ray, ray_hit_info)) {
            return ray_hit_info.point;
        }
        
        if (test_plane_minu.CheckRay(ray, ray_hit_info)) {
            return ray_hit_info.point;
        }
        
        return new Vector3(0, 0, 0);
    };
    
    static Update = function(mx, my, mouse_pos, mouse_dir, surf_w, surf_h, callback_translate, callback_rotate, callback_scale) {
        if (keyboard_check(vk_anykey)) {
            _emu_active_element(pointer_null);
        }
        
        if (mouse_check_button(mb_any)) {
            _emu_active_element(pointer_null);
        }
        
        var ray = new ColRay(mouse_pos, mouse_dir);
        
        if (!mouse_check_button(mb_left)) {
            self.selected_gizmo = EditorGizmos.NONE;
            self.selected_gizmo_position = undefined;
        }
        
        static view_mat = matrix_build_identity();
        static proj_mat = matrix_build_identity();
        matrix_get(matrix_view, view_mat);
        matrix_get(matrix_projection, proj_mat);
        
        static editor_gizmo_translate = function(selected, delta, delta_threshold, callback_translate) {
            switch (self.selected_gizmo) {
                case EditorGizmos.X: {
                    if (abs(delta.x) >= self.snapping_translate) {
                        callback_translate(delta.x, 0, 0);
                        return true;
                    }
                    return false;
                } break;
                case EditorGizmos.Y: {
                    if (abs(delta.y) >= self.snapping_translate) {
                        callback_translate(0, delta.y, 0);
                        return true;
                    }
                    return false;
                } break;
                case EditorGizmos.Z: {
                    if (abs(delta.z) >= self.snapping_translate) {
                        callback_translate(0, 0, delta.z);
                        return true;
                    }
                    return false;
                } break;
            }
        };
        
        static editor_gizmo_rotate = function(selected, delta, delta_threshold, callback_rotate) {
            var mouse_delta_x = window_mouse_get_delta_x();
            
            if (abs(mouse_delta_x) < delta_threshold) {
                return false;
            }
            
            switch (self.selected_gizmo) {
                case EditorGizmos.X: {
                    callback_rotate(mouse_delta_x, 0, 0);
                } break;
                case EditorGizmos.Y: {
                    callback_rotate(0, mouse_delta_x, 0);
                } break;
                case EditorGizmos.Z: {
                    callback_rotate(0, 0, mouse_delta_x);
                } break;
            }
            
            return true;
        }
        
        if (mouse_check_button_pressed(mb_left)) {
            static mouse_surf = -1;
            mouse_surf = surface_validate(mouse_surf, surf_w, surf_h);
            
            // figure out what you clicked on
            surface_set_target(mouse_surf);
            
                matrix_set(matrix_view, view_mat);
                matrix_set(matrix_projection, proj_mat);
                draw_clear(c_black);
                
                matrix_set(matrix_world, matrix_build(self.position.x, self.position.y, self.position.z, 0, 0, 0, 25, 25, 25));
                gpu_set_ztestenable(true);
                shader_reset();
            
                switch (self.gizmo_type) {
                    case EditorGizmoModes.TRANSLATE: {
                        gizmos.translate_x.Render();
                        gizmos.translate_y.Render();
                        gizmos.translate_z.Render();
                    } break;
                    case EditorGizmoModes.ROTATE: {
                        gizmos.rotate_x.Render();
                        gizmos.rotate_y.Render();
                        gizmos.rotate_z.Render();
                    } break;
                    case EditorGizmoModes.SCALE: {
                        gizmos.scale_x.Render();
                        gizmos.scale_y.Render();
                        gizmos.scale_z.Render();
                    } break;
                }
                
                matrix_set(matrix_world, matrix_build_identity());
                gpu_set_ztestenable(true);
            
            surface_reset_target();
            
            // yes this is slow
            var mouse_pick_color = surface_getpixel(mouse_surf, mx, my);
            if (mouse_pick_color == #fe3232) {
                self.selected_gizmo = EditorGizmos.X;
            } else if (mouse_pick_color == #32fe32) {
                self.selected_gizmo = EditorGizmos.Y;
            } else if (mouse_pick_color == #3232fe) {
                self.selected_gizmo = EditorGizmos.Z;
            }
            
            // code that happens when you first select a gizmo thingy
            if (self.selected_gizmo != EditorGizmos.NONE) {
                self.selected_gizmo_position = self.GetSelectionPlaneMouseLocation(mouse_pos, mouse_dir);
            }
        }
        
        if (mouse_check_button(mb_left)) {
            if (self.selected_gizmo != EditorGizmos.NONE) {
                var current_gizmo_mouse_position = self.GetSelectionPlaneMouseLocation(mouse_pos, mouse_dir);
                if (current_gizmo_mouse_position != undefined && self.selected_gizmo_position != undefined) {
                    var delta = current_gizmo_mouse_position.Sub(self.selected_gizmo_position);
                    
                    switch (self.gizmo_type) {
                        case EditorGizmoModes.TRANSLATE: {
                            if (editor_gizmo_translate(selected, delta, self.snapping_translate, callback_translate)) {
                                self.selected_gizmo_position = current_gizmo_mouse_position;
                            }
                        } break;
                        case EditorGizmoModes.ROTATE: {
                            if (editor_gizmo_rotate(selected, delta, self.snapping_rotate, callback_rotate)) {
                                self.selected_gizmo_position = current_gizmo_mouse_position;
                            }
                        } break;
                    }
                }
            }
        }
    };
    
    static Render = function() {
        var shader = shader_current();
        shader_set(shd_gizmos);
        
        static previous_matrix = matrix_build_identity();
        static transform_matrix = matrix_build_identity();
        matrix_get(matrix_world, previous_matrix);
        matrix_build(self.position.x, self.position.y, self.position.z, 0, 0, 0, 25, 25, 25, transform_matrix);
        matrix_set(matrix_world, transform_matrix);
        
        static set_override_color = function(enabled) {
            shader_set_uniform_f(shader_get_uniform(shd_gizmos, "u_override_color"), $ff / 255, $ff / 255, $99 / 255, enabled);
        };
        
        switch (self.gizmo_type) {
            case EditorGizmoModes.TRANSLATE: {
                set_override_color(self.selected_gizmo == EditorGizmos.X);
                gizmos.translate_x.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Y);
                gizmos.translate_y.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Z);
                gizmos.translate_z.Render();
            } break;
            case EditorGizmoModes.ROTATE: {
                set_override_color(self.selected_gizmo == EditorGizmos.X);
                gizmos.rotate_x.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Y);
                gizmos.rotate_y.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Z);
                gizmos.rotate_z.Render();
            } break;
            case EditorGizmoModes.SCALE: {
                set_override_color(self.selected_gizmo == EditorGizmos.X);
                gizmos.scale_x.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Y);
                gizmos.scale_y.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Z);
                gizmos.scale_z.Render();
            } break;
        }
        
        matrix_set(matrix_world, previous_matrix);
        
        if (shader != -1) {
            shader_set(shader);
        }
    };
    
    static SetPosition = function(position) {
        self.position.x = position.x;
        self.position.y = position.y;
        self.position.z = position.z;
    };
}