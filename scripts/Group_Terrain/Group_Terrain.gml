function Terrain(w, h) constructor {
    static patches = [
        terrain_create_patch(TERRAIN_INTERNAL_CHUNK_SIZE, 1),
        terrain_create_patch(TERRAIN_INTERNAL_CHUNK_SIZE, 4),
        terrain_create_patch(TERRAIN_INTERNAL_CHUNK_SIZE, 16)
    ];
    
    self.w = w;
    self.h = h;
    
    self.surface = -1;
    
    self.Validate();
    
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
    
    static Render = function() {
        var old_shader = shader_current();
        gpu_push_state();
        
        static u_world_offset = shader_get_uniform(shd_terrain, "u_WorldOffset");
        static u_terrain_size = shader_get_uniform(shd_terrain, "u_TerrainSize");
        static samp_height = shader_get_sampler_index(shd_terrain, "samp_height");
        
        shader_set(shd_terrain);
        
        shader_set_uniform_f(u_terrain_size, self.w, self.h);
        texture_set_stage(samp_height, surface_get_texture(self.surface));
        
        for (var i = 0; i < self.w; i += TERRAIN_INTERNAL_CHUNK_SIZE) {
            for (var j = 0; j < self.h; j += TERRAIN_INTERNAL_CHUNK_SIZE) {
                shader_set_uniform_f(u_world_offset, i, j);
                vertex_submit(patches[0], pr_trianglelist, -1);
            }
        }
        
        gpu_pop_state();
        if (old_shader == -1) {
            shader_reset();
        } else {
            shader_set(old_shader);
        }
    };
    
    static Destroy = function() {
        if (surface_exists(self.surface)) {
            surface_free(self.surface);
        }
    };
}