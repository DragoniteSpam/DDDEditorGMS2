// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki
function EmuInput(x, y, w, h, text, value, help_text, character_limit, input, callback) : EmuCallback(x, y, w, h, value, callback) constructor {
    enum E_InputTypes { STRING, INT, REAL, HEX, LETTERSDIGITS, LETTERSDIGITSANDUNDERSCORES };
    
    self.text = text;
    self.help_text = help_text;
    self.character_limit = clamp(character_limit, 1, 1000);  // keyboard_string maxes out at 1024 characters but I like to cut it off before then to be safe
    
    self.color_text = function() { return EMU_COLOR_TEXT };
    self.color_help_text = function() { return EMU_COLOR_HELP_TEXT; }
    self.color_warn = function() { return EMU_COLOR_INPUT_WARN; }
    self.color_reject = function() { return EMU_COLOR_INPUT_REJECT; }
    self.color_back = function() { return EMU_COLOR_BACK; }
    self.color_disabled = function() { return EMU_COLOR_DISABLED; }
    self.color_selected = function() { return EMU_COLOR_SELECTED; }
    self.input_font = function() { return EMU_FONT_DEFAULT; }
    
    self.sprite_ring = spr_emu_ring;
    self.sprite_enter = spr_emu_enter;
    
    self._value_x1 = self.width / 2;
    self._value_y1 = 0;
    self._value_x2 = self.width;
    self._value_y2 = self.height;
    
    self._override_escape = true;
    self._require_enter = false;
    self._multi_line = false;
    self._value_type = input;
    self._value_lower = -infinity;
    self._value_upper = infinity;
    
    self.strict_input = false;
    
    self._surface = surface_create(self._value_x2 - self._value_x1, self._value_y2 - self._value_y1);
    
    self.SetValidateInput = function(f) {
        self.ValidateInput = method(self, f);
        return self;
    };
    
    self.SetValueType = function(type) {
        self._value_type = type;
        return self;
    };
    
    self.SetCharacterLimit = function(limit) {
        self.character_limit = limit;
        return self;
    };
    
    self.SetColorText = function(f) {
        self.color_text = method(self, f);
        return self;
    };
    
    self.SetStrictInput = function(strict) {
        self.strict_input = strict;
        return self;
    };
    
    SetMultiLine = function(multi_line) {
        self._multi_line = multi_line;
        return self;
    }
    
    SetRequireConfirm = function(require) {
        self._require_enter = require;
        return self;
    }
    
    SetInputBoxPosition = function(vx1 = self._value_x1, vy1 = self._value_y1, vx2 = self._value_x2, vy2 = self._value_y2) {
        self._value_x1 = vx1;
        self._value_y1 = vy1;
        self._value_x2 = vx2;
        self._value_y2 = vy2;
        return self;
    }
    
    SetValue = function(value) {
        self.value = string(value);
        if (isActiveElement()) {
            keyboard_string = self.value;
        }
        return self;
    }
    
    SetRealNumberBounds = function(lower, upper) {
        self._value_lower = min(lower, upper);
        self._value_upper = max(lower, upper);
        return self;
    }
    
    Render = function(base_x, base_y) {
        processAdvancement();
        self.update_script();
        
        var x1 = x + base_x;
        var y1 = y + base_y;
        var x2 = x1 + width;
        var y2 = y1 + height;
        var c = self.color_text();

        var vx1 = x1 + _value_x1;
        var vy1 = y1 + _value_y1;
        var vx2 = x1 + _value_x2;
        var vy2 = y1 + _value_y2;
        var ww = vx2 - vx1;
        var hh = vy2 - vy1;
        
        var tx = getTextX(x1);
        var ty = getTextY(y1);
        
        var _working_value = string(value);
        var sw = string_width(_working_value);
        var sw_end = sw + 4;
        
        #region work out the input color
        scribble(string(self.text))
        	.align(fa_left, fa_middle)
        	.wrap(self.width, self.height)
        	.draw(tx, ty);
        
        if (ValidateInput(_working_value)) {
            var cast_value = CastInput(_working_value);
            if (is_real(cast_value) && clamp(cast_value, _value_lower, _value_upper) != cast_value) {
                c = self.color_warn();
            }
        } else {
            c = self.color_reject();
        }
        #endregion
        
        var vtx = vx1 + 12;
        var vty = floor(mean(vy1, vy2));
        var spacing = 12;
        
        #region input drawing
        if (surface_exists(_surface) && (surface_get_width(_surface) != ww || surface_get_height(_surface) != hh)) {
            surface_free(_surface);
        }

        if (!surface_exists(_surface)) {
            _surface = surface_create(ww, hh);
        }

        surface_set_target(_surface);
        surface_set_target(_surface);
        draw_clear(GetInteractive() ? self.color_back (): self.color_disabled());
        surface_reset_target();
        
        var display_text = _working_value + (isActiveElement() && (floor((current_time * 0.0025) % 2) == 0) ? "|" : "");
        
        if (_multi_line) {
            // i guess you could draw this in a single-line box too, but it would be pretty cramped
            #region the "how many characters remaining" counter
            var remaining = character_limit - string_length(_working_value);
            var f = string_length(_working_value) / character_limit;
            // hard limit on 99 for characters remaining
            if (f > 0.9 && remaining < 100) {
                var remaining_w = string_width(string(remaining));
                var remaining_h = string_height(string(remaining));
                var remaining_x = ww - 4 - remaining_w;
                var remaining_y = hh - remaining_h;
                
                scribble(string(remaining))
                	.draw(remaining_x, remaining_y);
            } else {
                var remaining_x = ww - 16;
                var remaining_y = hh - 16;
                var r = 12;
                var steps = 32;
                draw_sprite(sprite_ring, 0, remaining_x, remaining_y);
                draw_primitive_begin_texture(pr_trianglefan, sprite_get_texture(sprite_ring, 0));
                var csel = self.color_selected();
                draw_vertex_texture_colour(remaining_x, remaining_y, 0.5, 0.5, csel, 1);
                for (var i = 0; i <= steps * f; i++) {
                    var angle = 360 / steps * i - 90;
                    draw_vertex_texture_colour(
                        clamp(remaining_x + r * dcos(angle), remaining_x - r, remaining_x + r),
                        clamp(remaining_y + r * dsin(angle), remaining_y - r, remaining_y + r),
                        clamp(0.5 + 0.5 * dcos(angle), 0, 1),
                        clamp(0.5 + 0.5 * dsin(angle), 0, 1),
                    csel, 1);
                }
                draw_primitive_end();
            }
            #endregion
            
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(self.input_font());
            var sh = string_height_ext(display_text, -1, vx2 - vx1 - (vtx - vx1) * 2);
            vty = vy1 + offset;
            draw_text_ext_colour(vtx - vx1, min(vty - vy1, hh - spacing - sh), display_text, -1, vx2 - vx1 - (vtx - vx1) * 2, c, c, c, c, 1);
        } else {
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_font(self.input_font());
            var sw_begin = min(vtx - vx1, ww - offset - sw);
            draw_text_colour(sw_begin, vty - vy1, display_text, c, c, c, c, 1);
            sw_end = sw_begin + sw + 4;
        }
        
        if (string_length(value) == 0) {
            var tc = self.color_help_text();
            draw_text_colour(vtx - vx1, vty - vy1, string(help_text), tc, tc, tc, tc, 1);
        }

        if (_require_enter) {
            draw_sprite(sprite_enter, 0, vx2 - vx1 - sprite_get_width(sprite_enter) - 4, vty - vy1);
        }
        #endregion
        
        #region interaction
        if (GetInteractive()) {
            if (isActiveElement()) {
                var v0 = _working_value;
                _working_value = keyboard_string;
                
                if (string_length(_working_value) > character_limit) {
                	_working_value = string_copy(_working_value, 1, character_limit);
                	keyboard_string = _working_value;
                }
                
				// press escape to clear input
				if (keyboard_check_pressed(vk_escape)) {
                    keyboard_clear(vk_escape);
                    _working_value = "";
                    keyboard_string = "";
                }
				
				// add newline on pressing enter, if allowed
                if (_multi_line && !_require_enter && keyboard_check_pressed(vk_enter)) {
                    _working_value += "\n";
                    keyboard_string += "\n";
                }
				
                if (ValidateInput(_working_value)) {
                    self.value = _working_value;
                    var execute_value_change = (!_require_enter && v0 != _working_value) || (_require_enter && keyboard_check_pressed(vk_enter));
                    if (execute_value_change) {
                        var cast_value = CastInput(_working_value);
                        if (is_real(cast_value)) {
                            execute_value_change &= (clamp(cast_value, _value_lower, _value_upper) == cast_value);
                        }
						
                        if (execute_value_change) {
                            callback();
                        }
                    }
                } else if (_working_value != "") {
                    self.value = _working_value;
                } else {
                    // you can set input boxes to reject invalid inputs entirely
                    if (!self.strict_input) {
                        self.value = _working_value;
                    }
                }
            }
            
            // activation
            if (getMouseHover(vx1, vy1, vx2, vy2)) {
                if (getMouseReleased(vx1, vy1, vx2, vy2)) {
                    keyboard_string = value;
                    Activate();
                }
                ShowTooltip();
            }
        }
        
        surface_reset_target();
        #endregion
        
        draw_surface(_surface, vx1, vy1);
        c = self.color();
        draw_rectangle_colour(vx1, vy1, vx2, vy2, c, c, c, c, true);
    }
    
    static Activate = function() {
    	keyboard_string = self.value;
        _emu_active_element(self);
        return self;
    }
    
    Destroy = function() {
        destroyContent();
        if (surface_exists(_surface)) surface_free(_surface);
    }
    
    ValidateInput = function(text) {
        switch (self._value_type) {
        	case E_InputTypes.STRING:
        		return true;
        	case E_InputTypes.INT:
	            try {
	                real(text);
	            } catch (e) {
	                return false;
	            }
	            return int64(text) == real(text);
        	case E_InputTypes.REAL:
	            try {
	                real(text);
	            } catch (e) {
	                return false;
	            }
	            return true;
            case E_InputTypes.HEX:
	            try {
	                emu_hex(text);
	            } catch (e) {
	                return false;
	            }
	            return true;
            case E_InputTypes.LETTERSDIGITS:
	            return string_lettersdigits(text) == text;
            case E_InputTypes.LETTERSDIGITSANDUNDERSCORES:
	            return string_length(string_lettersdigits(text)) + string_count("_", text) == string_length(text);
        }
        return true;
    }
    
    CastInput = function(text) {
        switch (self._value_type) {
            case E_InputTypes.STRING: return text;
            case E_InputTypes.LETTERSDIGITS: return text;
            case E_InputTypes.LETTERSDIGITSANDUNDERSCORES: return text;
            case E_InputTypes.INT: return real(text);
            case E_InputTypes.REAL: return real(text);
            case E_InputTypes.HEX: return emu_hex(text);
        }
    }
}

/// @param value
/// @param padding
function emu_string_hex() {
    var _value = argument[0];
    var _padding = (argument_count > 1) ? argument[1] : 0;
    var _output = "";
    var _s = sign(_value);
    
    if (_value != 0) {
        _output = string(ptr(abs(_value)));
    
        while (string_char_at(_output, 1) == "0") {
            _output = string_copy(_output, 2, string_length(_output) - 1);
        }
    }
    
    while (string_length(_output) < _padding) {
        _output = "0" + _output;
    }
    
    return ((_s < 0) ? "-" : "") + _output;
}

function emu_hex(str) {
    var result = 0;
    
    try {
        result = int64(ptr(str));
    } catch (e) {
        throw new EmuException("Bad input for emu_hex()", "Could not parse " + string(str) + " as a hex value");
    }
    
    return result;
}