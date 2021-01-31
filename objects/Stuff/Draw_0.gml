mode.render(mode);

// these shouldn't be attached to any one view or anything
// would put this in the draw gui event except i dont know what would
// happen to the cursor on that layer and i dont feel like finding out
if (view_current == view_overlay) {
    for (var i = 0; i < ds_list_size(dialogs); i++) {
        var thing = dialogs[| i];
        thing.render(thing);
    }
    
    if (Stuff.element_tooltip_previous && !Stuff.element_tooltip_t) {
        Stuff.element_tooltip_t = -1;
    } else if (!Stuff.element_tooltip_previous && Stuff.element_tooltip) {
        Stuff.element_tooltip_t = Stuff.time;
    }
    
    // @gml update try-catch, oh my god
    if (Settings.config.tooltip && Stuff.element_tooltip && (Stuff.element_tooltip_t > -1 && (Stuff.time - Stuff.element_tooltip_t > 1))) {
        instance_activate_object(Stuff.element_tooltip);
        if (instance_exists(Stuff.element_tooltip) && string_length(Stuff.element_tooltip.tooltip) > 0) {
            var str = Stuff.element_tooltip.tooltip;
            var str_padding = 8;
            var text_width = 540;
            var halign = global.scribble_state_box_halign;
            var valign = global.scribble_state_box_valign;
            var starting_font = global.scribble_state_starting_font;
            var starting_color = global.scribble_state_starting_color;
            var starting_halign = global.scribble_state_starting_halign;
            scribble_set_box_align(fa_left, fa_top);
            scribble_set_wrap(text_width, -1);
            scribble_set_starting_format("FDefault", c_black, fa_left);
            var scribble = scribble_cache(str, "", true, true);
            var str_width = scribble_get_width(scribble) + str_padding * 2;
            var str_height = scribble_get_height(scribble) + str_padding * 2;
            var tooltip_x = min(window_mouse_get_x() + 16, view_get_wport(view_current) - str_width);
            var tooltip_y = min(window_mouse_get_y() + 16, view_get_hport(view_current) - str_height);
            draw_rectangle_colour(
                tooltip_x, tooltip_y, tooltip_x + str_width, tooltip_y + str_height,
                c_tooltip, c_tooltip, c_tooltip, c_tooltip, false
            );
            draw_rectangle_colour(
                tooltip_x, tooltip_y, tooltip_x + str_width, tooltip_y + str_height,
                c_black, c_black, c_black, c_black, true
            );
            scribble_draw(tooltip_x + str_padding, tooltip_y + str_padding, scribble);
            scribble_set_box_align(halign, valign);
            scribble_set_starting_format(starting_font, starting_color, starting_halign);
            instance_deactivate_object(Stuff.element_tooltip);
        }
    }
    
    Stuff.element_tooltip_previous = Stuff.element_tooltip;
    Stuff.element_tooltip = noone;
}

/*
 * please don't touch these settings, or any of the other settings relating to
 * the room/views, unless you know what you're doing and are prepared for pain
 *
 * Views:
 *
 * 0. fullscreen
 * 1. 3D
 * 2. Ribbon
 * 3. HUD (side)
 * 4. 3D Preview
 * 5.
 * 6.
 * 7. overlay - always on, may not always have stuff in it
 */