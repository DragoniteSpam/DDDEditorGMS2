// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki
function EmuCore(x, y, w, h) constructor {
    self.x = x;
    self.y = y;
    self.width = w;
    self.height = h;
    self.root = undefined;
    self.flags = 0;
    
    /// @ignore
    self.identifier = "";
    /// @ignore
    self.child_ids = { };
    
    self.enabled = true;
    self.interactive = true;
    self.outline = true;             // not used in all element types
    self.tooltip = "";               // not used by all element types
    self.color = EMU_COLOR_DEFAULT;
    
    self.active_element = noone;
    
    self.text = "core";
    self.offset = 12;
    
    self.alignment = fa_left;
    self.valignment = fa_middle;
    self.sprite_nineslice = spr_emu_nineslice;
    self.sprite_checkers = spr_emu_checker;
    
    self._contents = ds_list_create();
    
    self._override_escape = false;
    self._override_tab = false;
    self._override_root_check = false;
    
    self._next = noone;
    self._previous = noone;
    self._element_spacing_y = 16;
    self._element_spacing_x = 32;
    self._ref_name = "";
    
    static SetID = function(identifier) {
        identifier = string(identifier);
        if (self.root) {
            if (self.root.child_ids[$ self.identifier] == self) {
                variable_struct_remove(self.root.child_ids, self.identifier);
            }
            if (identifier != "") {
                self.root.child_ids[$ identifier] = self;
            }
        }
        self.identifier = identifier;
        return self;
    };
    
    static SetAlignment = function(h, v) {
        self.alignment = h;
        self.valignment = v;
        return self;
    };
    
    static GetChild = function(identifier) {
        identifier = string(identifier);
        return self.child_ids[$ identifier];
    };
    
    static GetSibling = function(identifier) {
        if (!self.root) return undefined;
        return self.root.GetChild(identifier);
    };
    
    static SetRootVariableName = function(name) {
        self._ref_name = "el_" + name;
        if (self.root) {
            self.root[$ self._ref_name] = self;
        }
        return self;
    };
    
    static AddContent = function(elements) {
        if (!is_array(elements)) {
            elements = [elements];
        }
        for (var i = 0; i < array_length(elements); i++) {
            var thing = elements[i];
            if (thing.y == EMU_AUTO) {
                var top = self.GetTop();
                if (top) {
                    thing.y = top.y + top.GetHeight() + self._element_spacing_y;
                } else {
                    thing.y = self._element_spacing_y;
                }
            } else if (thing.y == EMU_INLINE) {
                var top = self.GetTop();
                if (top) {
                    thing.y = top.y;
                } else {
                    thing.y = self._element_spacing_x;
                }
            } else if (thing.y == EMU_BASE) {
                thing.y = self._element_spacing_y;
            }
            ds_list_add(self._contents, thing);
            thing.root = self;
            if (thing._ref_name != "") {
                self[$ thing._ref_name] = thing;
            }
            if (thing.identifier != "") {
                self.child_ids[$ thing.identifier] = thing;
            }
        }
        return self;
    };
    
    self.tooltip = "";
    
    static SetTooltip = function(text) {
    	self.tooltip = text;
    	return self;
    };
    
    static getTextX = function(_x) {
        switch (self.alignment) {
            case fa_left: return _x + self.offset;
            case fa_center: return _x + self.width / 2;
            case fa_right: return _x + self.width - self.offset;
        }
    }
    
    static getTextY = function(_y) {
        switch (self.valignment) {
            case fa_top: return _y + self.offset;
            case fa_middle: return _y + self.height / 2;
            case fa_bottom: return _y + self.height - self.offset;
        }
    }
    
    static SetInteractive = function(_interactive) {
        self.interactive = _interactive;
        return self;
    }
    
    static SetNext = function(_element) {
        self._next = _element;
        if (self._next) self._next._previous = self;
        return self;
    }
    
    static SetPrevious = function(_element) {
        self._previous = _element;
        if (self._previous) self._previous._next = self;
        return self;
    }
    
    static RemoveContent = function(elements) {
        if (!is_array(elements)) {
            elements = [elements];
        }
        for (var i = 0; i < array_length(elements); i++) {
            var thing = elements[i];
            ds_list_delete(self._contents, ds_list_find_index(self._contents, thing));
            if (self.child_ids[$ thing.identifier] == thing) {
                variable_struct_remove(self.child_ids, thing.identifier);
            }
        }
        return self;
    }
    
    static GetHeight = function() {
        return self.height;
    }
    
    static Render = function(base_x = 0, base_y = 0) {
        self.processAdvancement();
        self.renderContents(self.x + base_x, self.y + base_y);
        return self;
    }
    
    static renderContents = function(at_x, at_y) {
        for (var i = 0; i < ds_list_size(self._contents); i++) {
            if (self._contents[| i]) self._contents[| i].Render(at_x, at_y);
        }
    }
    
    static processAdvancement = function() {
        if (!self.isActiveElement()) return false;
        if (!self._override_tab && keyboard_check_pressed(vk_tab)) {
            if (keyboard_check(vk_shift) && self._previous) {
                self._previous.Activate();
                keyboard_clear(vk_tab);
                return true;
            }
            if (self._next) {
                self._next.Activate();
                keyboard_clear(vk_tab);
                return true;
            }
        }
    }
    
    static Destroy = function() {
        self.destroyContent();
    }
    
    static destroyContent = function() {
        if (self.isActiveElement()) _emu_active_element(undefined);
        for (var i = 0; i < ds_list_size(self._contents); i++) {
            self._contents[| i].Destroy();
        }
        ds_list_destroy(self._contents);
    }
    
    static ShowTooltip = function() {
        // The implementation of this is up to you - but you probably want to
        // assign the element's "tooltip" text to be drawn on the UI somewhere
        return self;
    }
    
    static drawCheckerbox = function(_x, _y, _w, _h, _xscale = 1, _yscale = 1, _color = c_white, _alpha = 1) {
        var old_repeat = gpu_get_texrepeat();
        gpu_set_texrepeat(true);
        var _s = sprite_get_width(self.sprite_checkers);
        var _xcount = _w / _s / _xscale;
        var _ycount = _h / _s / _yscale;
        
        draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(self.sprite_checkers, 0));
        draw_vertex_texture_colour(_x, _y, 0, 0, _color, _alpha);
        draw_vertex_texture_colour(_x + _w, _y, _xcount, 0, _color, _alpha);
        draw_vertex_texture_colour(_x + _w, _y + _h, _xcount, _ycount, _color, _alpha);
        draw_vertex_texture_colour(_x + _w, _y + _h, _xcount, _ycount, _color, _alpha);
        draw_vertex_texture_colour(_x, _y + _h, 0, _ycount, _color, _alpha);
        draw_vertex_texture_colour(_x, _y, 0, 0, _color, _alpha);
        draw_primitive_end();
        
        gpu_set_texrepeat(old_repeat);
    }
    
    static isActiveDialog = function() {
        var top = EmuOverlay.GetTop();
        if (!top) return true;
        
        var root = self.root;
        
        while (root && root._override_root_check) {
            root = root.root;
        }
        
        return (top == root);
    }
    
    static isActiveElement = function() {
        return EmuActiveElement == self;
    }
    
    static Activate = function() {
        _emu_active_element(self);
        return self;
    }
    
    self.time_click_left = -1;
    self.time_click_left_last = -10000;
    
    static GetInteractive = function() {
        return self.enabled && self.interactive && self.isActiveDialog();
    }
    
    static GetTop = function() {
        return self._contents[| ds_list_size(self._contents) - 1];
    };
    
    static getMouseHover = function(x1, y1, x2, y2) {
        return self.GetInteractive() && point_in_rectangle(window_mouse_get_x() - view_get_xport(view_current), window_mouse_get_y() - view_get_yport(view_current), x1, y1, x2 - 1, y2 - 1);
    }
    
    static getMousePressed = function(x1, y1, x2, y2) {
        var click = (self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_pressed(mb_left)) || (self.isActiveElement() && keyboard_check_pressed(vk_space));
        // In the event that clicking is polled more than once per frame, don't
        // register two clicks per frame
        if (click && self.time_click_left != current_time) {
            self.time_click_left_last = self.time_click_left;
            self.time_click_left = current_time;
        }
        return click;
    }
    
    static getMouseDouble = function(x1, y1, x2, y2) {
        return self.getMousePressed(x1, y1, x2, y2) && (current_time - self.time_click_left_last < EMU_TIME_DOUBLE_CLICK_THRESHOLD);
    }
    
    static getMouseHold = function(x1, y1, x2, y2) {
        return (self.getMouseHover(x1, y1, x2, y2) && mouse_check_button(mb_left)) || (self.isActiveElement() && keyboard_check(vk_space));
    }
    
    static getMouseHoldDuration = function(x1, y1, x2, y2) {
        return self.getMouseHold(x1, y1, x2, y2) ? (current_time - self.time_click_left) : 0;
    }
    
    static getMouseReleased = function(x1, y1, x2, y2) {
        return (self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_released(mb_left)) || (self.isActiveElement() && keyboard_check_released(vk_space));
    }
    
    static getMouseMiddlePressed = function(x1, y1, x2, y2) {
        return self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_pressed(mb_middle);
    }
    
    static getMouseMiddleReleased = function(x1, y1, x2, y2) {
        return self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_released(mb_middle);
    }
    
    static GetMouseRightPressed = function(x1, y1, x2, y2) {
        return self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_pressed(mb_right);
    }
    
    static getMouseRightReleased = function(x1, y1, x2, y2) {
        return self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_released(mb_right);
    }
}

function EmuCallback(x, y, w, h, value, callback) : EmuCore(x, y, w, h) constructor {
    static SetCallback = function(callback) {
        self.callback = method(self, callback);
    }
    
    static SetCallbackMiddle = function(callback) {
        self.callback_middle = method(self, callback);
    }
    
    static SetCallbackRight = function(callback) {
        self.callback_right = method(self, callback);
    }
    
    static SetCallbackDouble = function(callback) {
        self.callback_double = method(self, callback);
    }
    
    static SetValue = function(value) {
        self.value = value;
        return self;
    }
    
    self.SetCallback(callback);
    self.SetValue(value);
    
    self.SetCallbackMiddle(emu_null);
    self.SetCallbackRight(emu_null);
    self.SetCallbackDouble(emu_null);
}

function emu_null() { }