if (is_struct(mode)) {
    mode.Render();
} else {
    mode.render(mode);
}

self.base_camera.SetProjectionOrtho();

// these shouldn't be attached to any one view or anything
// would put this in the draw gui event except i dont know what would
// happen to the cursor on that layer and i dont feel like finding out
for (var i = 0; i < ds_list_size(dialogs); i++) {
    var thing = dialogs[| i];
    if (is_struct(thing)) {
        thing.Render();
    } else {
        thing.render(thing);
    }
}
EmuOverlay.Render();

if (Stuff.element_tooltip_previous && !Stuff.element_tooltip_t) {
    Stuff.element_tooltip_t = -1;
} else if (!Stuff.element_tooltip_previous && Stuff.element_tooltip) {
    Stuff.element_tooltip_t = Stuff.time;
}

if (Settings.config.tooltip && Stuff.element_tooltip && (Stuff.element_tooltip_t > -1 && (Stuff.time - Stuff.element_tooltip_t > 1))) {
    instance_activate_object(Stuff.element_tooltip);
    if (instance_exists(Stuff.element_tooltip) && string_length(Stuff.element_tooltip.tooltip) > 0) {
        var str_padding = 8;
        var text_width = 540;
        
        var scribb = scribble(Stuff.element_tooltip.tooltip)
            .align(fa_left, fa_top)
            .padding(str_padding, str_padding, str_padding, str_padding)
            .wrap(text_width, -1);
        
        var str_width = scribb.get_width();
        var str_height = scribb.get_height();
        var tooltip_x = min(window_mouse_get_x() + 16, -str_width);
        var tooltip_y = min(window_mouse_get_y() + 16, -str_height);
        draw_rectangle_colour(
            tooltip_x, tooltip_y, tooltip_x + str_width, tooltip_y + str_height,
            c_tooltip, c_tooltip, c_tooltip, c_tooltip, false
        );
        draw_rectangle_colour(
            tooltip_x, tooltip_y, tooltip_x + str_width, tooltip_y + str_height,
            c_black, c_black, c_black, c_black, true
        );
        
        scribb.draw(tooltip_x, tooltip_y);
        
        instance_deactivate_object(Stuff.element_tooltip);
    }
}

Stuff.element_tooltip_previous = Stuff.element_tooltip;
Stuff.element_tooltip = noone;

if (Settings.config.show_status_messages) {
    for (var i = 0, n = array_length(self.status_messages); i < n; i++) {
        self.status_messages[i].Render();
    }
}