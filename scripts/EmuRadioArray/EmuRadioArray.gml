// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki
function EmuRadioArray(x, y, w, h, text, value, callback) : EmuCallback(x, y, w, h, value, callback) constructor {
    self.text = text;
    
    AddOptions = function(elements) {
        if (!is_array(elements)) {
            elements = [elements];
        }
        
        for (var i = 0; i < array_length(elements); i++) {
            elements[i] = new emu_radio_array_option(0, height * (1 + i), width, height, elements[i], i);
        }
        
        AddContent(elements);
        return self;
    }
    
    SetColumns = function(_column_capacity, _column_width) {
        if (_column_capacity <= 0) _column_capacity = 10000;
        for (var i = 0; i < ds_list_size(_contents); i++) {
            var option = _contents[| i];
            option.x = (i div _column_capacity) * _column_width;
            option.y = height * (1 + (i % _column_capacity));
            option.width = _column_width;
        }
        width = (ds_list_size(_contents) div _column_capacity) * _column_width;
        return self;
    }
    
    GetHeight = function() {
        var maximum_height = height;
        for (var i = 0; i < ds_list_size(_contents); i++) {
            maximum_height = max(_contents[| i].y + height, maximum_height);
        }
        return maximum_height;
    }
    
    Render = function(base_x, base_y) {
        processAdvancement();
        
        var x1 = x + base_x;
        var y1 = y + base_y;
        var x2 = x1 + width;
        var y2 = y1 + height;
        
        var tx = getTextX(x1);
        var ty = getTextY(y1);
        
        if (getMouseHover(x1, y1, x2, y2)) {
            ShowTooltip();
        }
        
        scribble(self.text)
            .wrap(self.width, self.height)
            .align(fa_left, fa_middle)
            .draw(tx, ty);
        
        renderContents(x1, y1);
    }
    
    static emu_radio_array_option = function(x, y, w, h, text, value) : EmuCore(x, y, w, h) constructor {
        self.text = text;
        self.value = value;
        
        self.color_active = function() { return EMU_COLOR_RADIO_ACTIVE; };
        self.color_back = function() { return EMU_COLOR_BACK; };
        
        self.sprite_radio = spr_emu_radio;
        
        Render = function(base_x, base_y) {
            var x1 = x + base_x;
            var y1 = y + base_y;
            var x2 = x1 + width;
            var y2 = y1 + height;
            
            var tx = getTextX(x1);
            var ty = getTextY(y1);
            
            if (getMouseHover(x1, y1, x2, y2)) {
                ShowTooltip();
            }
            
            if (getMouseReleased(x1, y1, x2, y2)) {
                root.Activate();
                // radio array options don't get individual callbacks
                root.value = value;
                root.callback();
            }
            
            draw_sprite_ext(sprite_radio, 2, tx + offset, ty, 1, 1, 0, self.color_back(), 1);
            draw_sprite_ext(sprite_radio, 1, tx + offset, ty, 1, 1, 0, self.color(), 1);
            draw_sprite_ext(sprite_radio, 0, tx + offset, ty, 1, 1, 0, self.color(), 1);
            if (value == root.value) {
                draw_sprite_ext(sprite_radio, 3, tx + offset, ty, 1, 1, 0, self.color_active(), GetInteractive());
            }
            
            scribble(self.text)
                .align(fa_left, fa_center)
                .wrap(self.width, self.height)
                .draw(tx + self.offset + sprite_get_width(self.sprite_radio), ty);
        }
        
        GetInteractive = function() {
            return enabled && interactive && root.interactive && root.isActiveDialog() && (!self.root.root || self.root.root.contents_interactive);
        }
    }
}