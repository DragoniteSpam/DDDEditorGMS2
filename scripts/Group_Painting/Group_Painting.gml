function Painter(width, height) constructor {
    self.width = min(width, 0x4000);
    self.height = min(height, 0x4000);
    
    self.surface = surface_create(self.width, self.height);
    self.sprite = -1;
    surface_set_target(self.surface);
    draw_clear_alpha(c_white, 1);
    surface_reset_target();
    
    self.brush_index = 7;
    self.brush_sprite = -1;
    self.shader = -1;
    
    static SetBrush = function(sprite, index) {
        self.brush_sprite = sprite;
        self.brush_index = index;
        return self;
    };
    
    static SetShader = function(shader) {
        self.shader = shader;
        return self;
    };
    
    static Reset = function(width, height) {
        self.width = min(width, 0x4000);
        self.height = min(height, 0x4000);
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
        if (surface_exists(self.surface)) surface_free(self.surface);
        self.sprite = -1;
        self.surface = surface_create(self.width, self.height);
        surface_set_target(self.surface);
        draw_clear_alpha(c_white, 1);
        surface_reset_target();
    };
    
    static SaveState = function() {
        if (!surface_exists(self.surface)) return;
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
        self.sprite = sprite_create_from_surface(self.surface, 0, 0, surface_get_width(self.surface), surface_get_height(self.surface), false, false, 0, 0);
    };
    
    static LoadState = function() {
        if (!sprite_exists(self.sprite)) return;
        if (surface_exists(self.surface)) surface_free(self.surface);
        self.surface = sprite_to_surface(self.sprite, 0);
    };
    
    static Clear = function(color) {
        surface_set_target(self.surface);
        draw_clear_alpha(color, 1);
        surface_reset_target();
    };
    
    static Paint = function(x, y, radius, color, strength) {
        if (!surface_exists(self.surface)) self.LoadState();
        if (!sprite_exists(self.brush_sprite)) return;
        surface_set_target(self.surface);
        if (self.shader != -1) shader_set(self.shader);
        draw_sprite_ext(self.brush_sprite, clamp(self.brush_index, 0, sprite_get_number(self.brush_sprite) - 1), x, y, radius / 32, radius / 32, 0, color, strength);
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