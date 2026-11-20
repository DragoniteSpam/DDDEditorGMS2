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
    
    static Update = function() {
        
    };
    
    static Render = function() {
        
    };
    
    static SetPosition = function(position) {
        self.position.x = position.x;
        self.position.y = position.y;
        self.position.z = position.z;
    };
}