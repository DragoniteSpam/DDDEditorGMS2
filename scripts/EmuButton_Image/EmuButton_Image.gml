// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki
function EmuButtonImage(x, y, w, h, sprite, index, blend, alpha, scale_to_fit, callback) : EmuCallback(x, y, w, h, 0, callback) constructor {
    self.sprite = sprite;
    self.blend = blend;
    self.alpha = alpha;
    self.fill = scale_to_fit;
    self.allow_shrink = false;
    
    self.alignment = fa_center;
    self.valignment = fa_middle;
    self.text = "";
    
    self.image_align = {
        h: fa_center,
        v: fa_middle,
    };
    
    self.color_hover = function() { return EMU_COLOR_HOVER; };
    self.color_back = function() { return EMU_COLOR_BACK; };
    self.color_disabled = function() { return EMU_COLOR_DISABLED; };
    
    self.checker_background = false;
    
    self._surface = noone;
    self._index = index;
    
    static SetDisabledColor = function(f) {
        self.color_disabled = method(self, f);
        return self;
    };
    
    static SetAlignment = function(h, v) {
        self.alignment = h;
        self.valignment = v;
        return self;
    };
    
    static SetImageAlignment = function(h, v) {
        self.image_align.h = h;
        self.image_align.v = v;
        return self;
    };
    
    static SetAllowShrink = function(allow) {
        self.allow_shrink = allow;
        return self;
    };
    
    static SetCheckerboard = function(draw_checkerboard) {
        self.checker_background = draw_checkerboard;
        return self;
    };
    
    Render = function(base_x, base_y) {
        processAdvancement();
        
        var x1 = x + base_x;
        var y1 = y + base_y;
        var x2 = x1 + width;
        var y2 = y1 + height;
        
        #region draw the image to the _surface
        if (surface_exists(_surface) && (surface_get_width(_surface) != width || surface_get_height(_surface) != height)) {
            surface_free(_surface);
        }
        
        if (!surface_exists(_surface)) {
            _surface = surface_create(width, height);
        }
        
        surface_set_target(_surface);
        draw_clear_alpha(c_black, 0);
        draw_sprite_stretched_ext(sprite_nineslice, 1, 0, 0, width, height, self.color_back(), 1);
        if (self.checker_background) drawCheckerbox(0, 0, self.width - 1, self.height - 1);
        if (sprite_exists(sprite)) {
            // to make things easier for ourselves just assume the sprite is to
            // be drawn centered here
            if (self.fill || self.allow_shrink) {
                var scale = min(max(self.width / sprite_get_width(sprite), 1), max(self.height / sprite_get_height(sprite), 1));
                if (self.allow_shrink) {
                    scale = min(self.width / sprite_get_width(sprite), self.height / sprite_get_height(sprite));
                }
                var sprite_x = self.width / 2;
                var sprite_y = self.height / 2;
                if (self.image_align.h == fa_left) {
                    sprite_x = 0;
                }
                if (self.image_align.v == fa_top) {
                    sprite_y = 0;
                }
                draw_sprite_ext(sprite, self._index, sprite_x, sprite_y, scale, scale, 0, blend, alpha);
            } else {
                var sprite_x = 0;
                var sprite_y = 0;
                switch (self.image_align.h) {
                    case fa_left: sprite_x = 0; break;
                    case fa_center: sprite_x = self.width / 2; break;
                    case fa_right: sprite_x = self.width; break;    // why
                }
                switch (self.image_align.v) {
                    case fa_left: sprite_y = 0; break;
                    case fa_center: sprite_y = self.height / 2; break;
                    case fa_right: sprite_y = self.height; break;    // why
                }
                draw_sprite_ext(sprite, self._index, sprite_x, sprite_y, 1, 1, 0, blend, alpha);
            }
        }
        
        scribble(self.text)
            .align(self.alignment, self.valignment)
            .wrap(self.width, self.height)
            .draw(width div 2, height div 2);
        
        surface_reset_target();
        #endregion
        
        if (getMouseHover(x1, y1, x2, y2)) {
            ShowTooltip();
        }
        
        if (getMouseReleased(x1, y1, x2, y2)) {
            Activate();
            callback();
        }
        
        var back_color = getMouseHover(x1, y1, x2, y2) ? self.color_hover() : (self.GetInteractive() ? self.color_back() : self.color_disabled());
        draw_surface_ext(_surface, x1, y1, 1, 1, 0, back_color, 1);
        draw_sprite_stretched_ext(sprite_nineslice, 0, x1, y1, x2 - x1, y2 - y1, self.color(), 1);
    }
    
    Destroy = function() {
        if (surface_exists(_surface)) surface_free(_surface);
        destroyContent();
    }
}