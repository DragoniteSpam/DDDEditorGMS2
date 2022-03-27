render = ui_render;
file_dropper_action = null;
contents = ds_list_create();
root = noone;
enabled = true;
interactive = true;
outline = true;             // not used in all element types
tooltip = "";               // not used by all element types

active_element = noone;

text = "thing";
width = 128;
height = 24;
offset = 12;

color = c_black;
alignment = fa_left;
valignment = fa_middle;

contents_interactive = true;

// if you have a list of ui things in a list, and want to iterate over the list, but
// want to ignore this one
is_aux = false;

// if this is set to true the mouse click check will use mouse_within_rectangle
// instead of mouse_within_rectangle_view
adjust_view = false;

override_escape = false;

next = noone;
previous = noone;

// interface with emu a bit better
self._element_spacing_y = 16;
self._override_root_check = false;

AddContent = function(elements) {
    if (!is_array(elements)) {
        elements = [elements];
    }
    for (var i = 0; i < array_length(elements); i++) {
        var thing = elements[i];
        if (thing.y == undefined) {
            var top = self.GetTop();
            if (top) {
                thing.y = top.y + top.GetHeight() + self._element_spacing_y;
            } else {
                thing.y = self._element_spacing_y;
            }
        }
        ds_list_add(self.contents, thing);
        thing.root = self;
    }
    return self;
}

GetTop = function() {
    return self.contents[| ds_list_size(self.contents) - 1];
};

GetTextX = function(x1, x2, align = self.alignment) {
    switch (align) {
        case fa_left: return floor(x1 + self.offset);
        case fa_center: return floor(mean(x1, x2));
        case fa_right: return floor(x2 - self.offset);
    }
};

GetTextY = function(y1, y2, align = self.alignment) {
    switch (align) {
        case fa_top: return floor(y1 + self.offset);
        case fa_middle: return floor(mean(y1, y2));
        case fa_bottom: return floor(y2 - self.offset);
    }
};