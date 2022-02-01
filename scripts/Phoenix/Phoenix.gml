function Phoenix(width, height, def_color = c_white) constructor {
    self.width = min(width, 0x4000);
    self.height = min(height, 0x4000);
    self.def_color = def_color;
    
    var dd = surface_get_depth_disable();
    surface_depth_disable(true);
    self.surface = surface_create(self.width, self.height);
    surface_depth_disable(dd);
    self.sprite = -1;
    surface_set_target(self.surface);
    draw_clear_alpha(def_color, 1);
    surface_reset_target();
    
    self.brush_index = 7;
    self.brush_sprite = -1;
    self.shader = -1;
    self.blend_enable = true;
    
    static SetBrush = function(sprite, index) {
        self.brush_sprite = sprite;
        self.brush_index = index;
        return self;
    };
    
    static SetShader = function(shader) {
        self.shader = shader;
        return self;
    };
    
    static SetBlendEnable = function(enable) {
        self.blend_enable = enable;
        return self;
    };
    
    static Reset = function(width, height) {
        self.width = min(width, 0x4000);
        self.height = min(height, 0x4000);
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
        if (surface_exists(self.surface)) surface_free(self.surface);
        self.sprite = -1;
        var dd = surface_get_depth_disable();
        surface_depth_disable(true);
        self.surface = surface_create(self.width, self.height);
        surface_depth_disable(dd);
        surface_set_target(self.surface);
        draw_clear_alpha(self.def_color, 1);
        surface_reset_target();
    };
    
    static SaveState = function() {
        if (!surface_exists(self.surface)) return;
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
        self.sprite = sprite_create_from_surface(self.surface, 0, 0, surface_get_width(self.surface), surface_get_height(self.surface), false, false, 0, 0);
    };
    
    static LoadState = function() {
        if (surface_exists(self.surface)) surface_free(self.surface);
        if (sprite_exists(self.sprite)) self.surface = sprite_to_surface(self.sprite, 0);
        if (!surface_exists(self.surface)) self.Reset(self.width, self.height);
    };
    
    static Clear = function(color, alpha = 1) {
        surface_set_target(self.surface);
        draw_clear_alpha(color, alpha);
        surface_reset_target();
    };
    
    static Paint = function(x, y, radius, color, strength) {
        if (!surface_exists(self.surface)) self.LoadState();
        if (!sprite_exists(self.brush_sprite)) return;
        surface_set_target(self.surface);
        if (self.shader != -1) shader_set(self.shader);
        gpu_set_blendenable(self.blend_enable);
        var sw = sprite_get_width(self.brush_sprite);
        var sh = sprite_get_height(self.brush_sprite);
        var sx = radius / sw;
        var sy = radius / sh;
        draw_sprite_ext(
            self.brush_sprite, clamp(self.brush_index, 0, sprite_get_number(self.brush_sprite) - 1),
            x - sw / 2 * sx, y - sh / 2 * sy, sx, sy, 0,
            color, strength
        );
        gpu_set_blendenable(true);
        shader_reset();
        surface_reset_target();
    };
    
    static Validate = function() {
        if (!surface_exists(self.surface)) self.LoadState();
        if (!surface_exists(self.surface)) self.Reset(self.width, self.height);
    };
    
    static Finish = function() {
        self.SaveState();
    };
    
    static GetSprite = function() {
        return sprite_create_from_surface(self.surface, 0, 0, surface_get_width(self.surface), surface_get_height(self.surface), false, false, 0, 0);
    };
}