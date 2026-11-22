function Terrain(w, h) {
    static patches = [
        terrain_create_patch(TERRAIN_INTERNAL_CHUNK_SIZE, 1),
        terrain_create_patch(TERRAIN_INTERNAL_CHUNK_SIZE, 4),
        terrain_create_patch(TERRAIN_INTERNAL_CHUNK_SIZE, 16)
    ];
    
    self.w = w;
    self.h = h;
    
    static Validate = function() {
        if (surface_exists(self.surface)) {
            var valid_w = surface_get_width(self.surface) != self.w;
            var valid_h = surface_get_height(self.surface) != self.h;
            var valid_format = surface_get_format(self.surface) != surface_r32float;
            if (!valid_w || !valid_h || !valid_format) {
                surface_free(self.surface);
            }
        }
        
        if (!surface_exists(self.surface)) {
            var depth_state = surface_get_depth_disable();
            surface_depth_disable(true);
            self.surface = surface_create(self.w, self.h, surface_r32float);
            surface_depth_disable(depth_state);
        }
    };
    
    static Destroy = function() {
        if (surface_exists(self.surface)) {
            surface_free(self.surface);
        }
    };
}