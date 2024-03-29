// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki
function EmuCheckbox(x, y, w, h, text, value, callback) : EmuCallback(x, y, w, h, value, callback) constructor {
    self.text = text;
    
    self.box_size = 20;
    self.sprite_check = spr_emu_checkbox;
    self.sprite_check_border = spr_emu_checkbox_border;
    self.color_active = function() { return EMU_COLOR_RADIO_ACTIVE; };
    self.color_hover = function() { return EMU_COLOR_HOVER; };
    self.color_disabled = function() { return EMU_COLOR_DISABLED; };
    self.color_back = function() { return EMU_COLOR_BACK; };
    
    Render = function(base_x, base_y) {
        processAdvancement();
        
        var x1 = x + base_x;
        var y1 = y + base_y;
        var x2 = x1 + width;
        var y2 = y1 + height;
        
        if (getMouseHover(x1, y1, x2, y2)) {
            ShowTooltip();
        }
        
        if (getMouseReleased(x1, y1, x2, y2)) {
            Activate();
            value = !value;
            callback();
        }
        
        var bx = x1 + offset + box_size / 2;
        var by = mean(y1, y2);
        var bx1 = bx - box_size / 2;
        var by1 = by - box_size / 2;
        var bx2 = bx + box_size / 2;
        var by2 = by + box_size / 2;
        var back_color = getMouseHover(x1, y1, x2, y2) ? self.color_hover() : (self.GetInteractive() ? self.color_back() : self.color_disabled());
        draw_sprite_ext(sprite_check_border, 1, bx, by, 1, 1, 0, back_color, 1);
        draw_sprite_ext(sprite_check, value, bx, by, 1, 1, 0, self.color_active(), 1);
        draw_sprite_ext(sprite_check_border, 0, bx, by, 1, 1, 0, self.color(), 1);
        
        scribble(self.text)
            .align(self.alignment, self.valignment)
            .wrap(self.width, self.height)
            .draw(x1 + box_size + offset * 2, floor(mean(y1, y2)));
    }
}