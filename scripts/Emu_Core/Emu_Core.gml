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
    self.identifier_pending = false;
    /// @ignore
    self.child_ids = { };
    
    self.enabled = true;
    self.interactive = true;
    self.contents_interactive = true;
    self.outline = true;             // not used in all element types
    self.tooltip = "";               // not used by all element types
    self.color = function() { return EMU_COLOR_DEFAULT; };
    
    self.update_script = function() { };
    
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
    self._ignore_space_activate = true;
    
    self._next = noone;
    self._previous = noone;
    self._element_spacing_y = 16;
    self._element_spacing_x = 32;
    self._ref_name = "";
    
    self.refresh_script = function(data) { };
    
    static SetUpdate = function(f) {
        self.update_script = method(self, f);
        return self;
    };
    
    static SetRefresh = function(f) {
        self.refresh_script = method(self, f);
        return self;
    };
    
    static SetDefaultSpacingX = function(spacing) {
        self._element_spacing_x = spacing;
        return self;
    };
    
    static SetDefaultSpacingY = function(spacing) {
        self._element_spacing_y = spacing;
        return self;
    };
    
    static SetContentsInteractive = function(interactive) {
        self.contents_interactive = interactive;
        return self;
    };
    
    static SetID = function(identifier) {
        identifier = string(identifier);
        if (self.root) {
            if (self.root.child_ids[$ self.identifier] == self) {
                variable_struct_remove(self.root.child_ids, self.identifier);
            }
            if (identifier != "") {
                self.root.child_ids[$ identifier] = self;
            }
        } else {
            self.identifier_pending = true;
        }
        self.identifier = identifier;
        return self;
    };
    
    static SearchID = function(identifier, recursive = true) {
        for (var i = 0, n = ds_list_size(self._contents); i < n; i++) {
            var element = self._contents[| i];
            if (element.identifier == identifier) {
                return element;
            }
            if (recursive) {
                var recursive_search_result = element.SearchID(identifier, recursive);
                if (recursive_search_result) return recursive_search_result;
            }
        }
        return undefined;
    };
    
    /// @ignore
    static setPendingIDs = function() {
        for (var i = 0, n = ds_list_size(self._contents); i < n; i++) {
            var element = self._contents[| i];
            if (element.identifier_pending) {
                element.SetID(element.identifier);
                element.setPendingIDs();
                element.identifier_pending = false;
            }
        }
    };
    
    static SetAlignment = function(h, v) {
        self.alignment = h;
        self.valignment = v;
        return self;
    };
    
    static SetEnabled = function(enabled) {
        self.enabled = enabled;
        return self;
    };
    
    static SetOverrideRootCheck = function(override) {
        self._override_root_check = override;
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
    
    static Refresh = function(data = undefined) {
        self.refresh_script(data);
        for (var i = 0, n = ds_list_size(self._contents); i < n; i++) {
            self._contents[| i].Refresh(data);
        }
        return self;
    };
    
    static AddContent = function(elements) {
        if (!is_array(elements)) {
            elements = [elements];
        }
        for (var i = 0; i < array_length(elements); i++) {
            var thing = elements[i];
            var top = self.GetTop();
            // calculate the vertical position first
            if (thing.y == EMU_AUTO) {
                if (top) {
                    thing.y = top.y + top.GetHeight() + self._element_spacing_y;
                } else {
                    thing.y = self._element_spacing_y;
                }
            } else if (thing.y == EMU_AUTO_NO_SPACING) {
                top = self.GetTop();
                if (top) {
                    thing.y = top.y + top.GetHeight();
                } else {
                    thing.y = self._element_spacing_y;
                }
            } else if (thing.y == EMU_INLINE) {
                top = self.GetTop();
                if (top) {
                    thing.y = top.y;
                } else {
                    thing.y = self._element_spacing_y;
                }
            } else if (thing.y == EMU_BASE) {
                thing.y = self._element_spacing_y;
            }
            // and then the horizontal position second
            if (thing.x == EMU_AUTO) {
                if (top) {
                    if (thing.y + thing.y + self._element_spacing_y > self.height) {
                        thing.x = top.x + top.width + self._element_spacing_x;
                    } else {
                        thing.x = self._element_spacing_x;
                    }
                } else {
                    thing.x = self._element_spacing_x;
                }
            }
            // and then the other stuff
            ds_list_add(self._contents, thing);
            thing.root = self;
            if (thing._ref_name != "") {
                self[$ thing._ref_name] = thing;
            }
            if (thing.identifier != "") {
                self.child_ids[$ thing.identifier] = thing;
            }
        }
        self.setPendingIDs();
        return self;
    };
    
    self.tooltip = "";
    
    static SetTooltip = function(text) {
        self.tooltip = text;
        return self;
    };
    
    static getTextX = function(_x) {
        switch (self.alignment) {
            case fa_left: return floor(_x + self.offset);
            case fa_center: return floor(_x + self.width / 2);
            case fa_right: return floor(_x + self.width - self.offset);
        }
    }
    
    static getTextY = function(_y) {
        switch (self.valignment) {
            case fa_top: return floor(_y + self.offset);
            case fa_middle: return floor(_y + self.height / 2);
            case fa_bottom: return floor(_y + self.height - self.offset);
        }
    }
    
    static SetInteractive = function(_interactive) {
        self.interactive = _interactive;
        return self;
    }
    
    static SetNext = function(_element) {
        self._next = _element;
        if (is_struct(self._next)) self._next._previous = self;
        return self;
    }
    
    static SetPrevious = function(_element) {
        self._previous = _element;
        if (is_struct(self._previous)) self._previous._next = self;
        return self;
    }
    
    static RemoveContent = function(elements) {
        if (!is_array(elements)) {
            elements = [elements];
        }
        for (var i = array_length(elements) - 1; i >= 0; i--) {
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
            if (self._contents[| i] && self._contents[| i].enabled) self._contents[| i].Render(at_x, at_y);
        }
    }
    
    static processAdvancement = function() {
        if (!self.isActiveElement()) return false;
        if (!self._override_tab && keyboard_check_pressed(vk_tab)) {
            if (keyboard_check(vk_shift) && self._previous != undefined) {
                if (is_struct(self._previous))
                    self._previous.Activate();
                else if (self.GetSibling(self._previous))
                    self.GetSibling(self._previous).Activate();
                keyboard_clear(vk_tab);
                return true;
            }
            if (self._next != undefined) {
                if (is_struct(self._next))
                    self._next.Activate();
                else if (self.GetSibling(self._next))
                    self.GetSibling(self._next).Activate();
                keyboard_clear(vk_tab);
                return true;
            }
        }
    }
    
    static Destroy = function() {
        self.destroyContent();
    };
    
    static destroyContent = function() {
        if (self.isActiveElement()) _emu_active_element(undefined);
        for (var i = 0; i < ds_list_size(self._contents); i++) {
            self._contents[| i].Destroy();
        }
        ds_list_destroy(self._contents);
    };
    
    static ClearContent = function() {
        if (self.isActiveElement()) _emu_active_element(undefined);
        for (var i = 0; i < ds_list_size(self._contents); i++) {
            self._contents[| i].Destroy();
        }
        ds_list_clear(self._contents);
    };
    
    static ShowTooltip = function() {
        // The implementation of this is up to you - but you probably want to
        // assign the element's "tooltip" text to be drawn on the UI somewhere
        return self;
    }
    
    static drawCheckerbox = function(_x = 0, _y = 0, _w = self.width - 1, _h = self.height - 1, _xscale = 1, _yscale = 1, _color = c_white, _alpha = 1) {
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
        return self.enabled && self.interactive && self.isActiveDialog() && (!self.root || self.root.contents_interactive);
    }
    
    static GetTop = function() {
        return self._contents[| ds_list_size(self._contents) - 1];
    };
    
    static getMouseHover = function(x1, y1, x2, y2) {
        return self.GetInteractive() && point_in_rectangle(window_mouse_get_x(), window_mouse_get_y(), x1, y1, x2 - 1, y2 - 1);
    }
    
    static getMousePressed = function(x1, y1, x2, y2) {
        var click = (self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_pressed(mb_left)) || (!self._ignore_space_activate && self.isActiveElement() && keyboard_check_pressed(vk_space));
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
        return (self.getMouseHover(x1, y1, x2, y2) && mouse_check_button(mb_left)) || (!self._ignore_space_activate && self.isActiveElement() && keyboard_check(vk_space));
    }
    
    static getMouseHoldDuration = function(x1, y1, x2, y2) {
        return self.getMouseHold(x1, y1, x2, y2) ? (current_time - self.time_click_left) : 0;
    }
    
    static getMouseReleased = function(x1, y1, x2, y2) {
        return (self.getMouseHover(x1, y1, x2, y2) && mouse_check_button_released(mb_left)) || (!self._ignore_space_activate && self.isActiveElement() && keyboard_check_released(vk_space));
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
    
    self.GetBaseElement = function() {
        var element = self;
        while (true) {
            if (!element.root) return element;
            element = element.root;
        }
        // this will never happen
        return undefined;
    };
}

function EmuCallback(x, y, w, h, value, callback) : EmuCore(x, y, w, h) constructor {
    static SetCallback = function(callback) {
        self.callback = method(self, callback);
        return self;
    }
    
    static SetCallbackMiddle = function(callback) {
        self.callback_middle = method(self, callback);
        return self;
    }
    
    static SetCallbackRight = function(callback) {
        self.callback_right = method(self, callback);
        return self;
    }
    
    static SetCallbackDouble = function(callback) {
        self.callback_double = method(self, callback);
        return self;
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