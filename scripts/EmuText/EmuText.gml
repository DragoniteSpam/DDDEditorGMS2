// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki
function EmuText(x, y, w, h, text) : EmuCore(x, y, w, h) constructor {
    self.text = text;
    self.get_text = function() { return self.text; };
    
    static SetValue = function(value) {
        self.text = value;
        return self;
    };
    
    static SetTextUpdate = function(f) {
        if (f) {
            self.get_text = method(self, f);
        } else {
            self.get_text = undefined;
        }
        return self;
    };
    #endregion
    
    Render = function(base_x, base_y) {
        processAdvancement();
        
        if (self.get_text != undefined) self.text = self.get_text();
        
        var x1 = x + base_x;
        var y1 = y + base_y;
        var x2 = x1 + width;
        var y2 = y1 + height;
        
        var tx = getTextX(x1);
        var ty = getTextY(y1);
        
        if (getMouseHover(x1, y1, x2, y2)) {
            ShowTooltip();
            if (getMouseReleased(x1, y1, x2, y2)) {
                Activate();
            }
        }
        
        scribble(self.text)
            .wrap(self.width, self.height)
            .align(self.alignment, self.valignment)
            .draw(tx, ty);
    }
}