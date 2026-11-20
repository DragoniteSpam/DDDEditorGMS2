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
    
    static GetSelectionPlaneMouseLocation = function(center, mouse_pos, mouse_dir) {
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
                        plane_z_plus.distance = center.z;
                        plane_z_minu.distance = center.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                    } break;
                    case EditorGizmos.Y: {
                        plane_x_plus.distance = center.x;
                        plane_x_minu.distance = center.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                    } break;
                    case EditorGizmos.Z: {
                        plane_y_plus.distance = center.y;
                        plane_y_minu.distance = center.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                    } break;
                }
            } break;
            case EditorGizmoModes.ROTATE: {
                switch (self.selected_gizmo) {
                    case EditorGizmos.X: {
                        plane_x_plus.distance = center.x;
                        plane_x_minu.distance = center.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                    } break;
                    case EditorGizmos.Y: {
                        plane_y_plus.distance = center.y;
                        plane_y_minu.distance = center.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                    } break;
                    case EditorGizmos.Z: {
                        plane_z_plus.distance = center.z;
                        plane_z_minu.distance = center.z;
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
    
    static Update = function() {
        
    };
    
    static Render = function() {
        var shader = shader_current();
        
        static previous_matrix = matrix_build_identity();
        static transform_matrix = matrix_build_identity();
        matrix_get(matrix_world, previous_matrix);
        matrix_build(self.position.x, self.position.y, self.position.z, 0, 0, 0, 25, 25, 25, transform_matrix);
        matrix_set(matrix_world, transform_matrix);
        
        shader_reset();
        static set_override_color = function() {
            
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