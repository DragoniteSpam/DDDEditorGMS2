script_execute(mode.render, mode);

// these shouldn't be attached to any one view or anything
// would put this in the draw gui event except i dont know what would
// happen to the cursor on that layer and i dont feel like finding out
if (view_current == view_overlay) {
    for (var i = 0; i < ds_list_size(dialogs); i++) {
        var thing = dialogs[| i];
        script_execute(thing.render, thing);
    }
    
    if (Stuff.element_tooltip_previous && !Stuff.element_tooltip_t) {
        Stuff.element_tooltip_t = -1;
    } else if (!Stuff.element_tooltip_previous && Stuff.element_tooltip) {
        Stuff.element_tooltip_t = Stuff.time;
    }
    
    // @gml update try-catch, oh my god
    if (Stuff.setting_tooltip && Stuff.element_tooltip && (Stuff.element_tooltip_t > -1 && (Stuff.time - Stuff.element_tooltip_t > 1))) {
        instance_activate_object(Stuff.element_tooltip);
        if (instance_exists(Stuff.element_tooltip) && string_length(Stuff.element_tooltip.tooltip) > 0) {
            var str = Stuff.element_tooltip.tooltip;
            var str_padding = 8;
            var text_width = 540;
            draw_set_valign(fa_top);
            draw_set_halign(fa_left);
            var str_width = string_width_ext(str, -1, text_width) + str_padding * 2;
            var str_height = string_height_ext(str, -1, text_width) + str_padding * 2;
            var halign = draw_get_halign();
            var valign = draw_get_valign();
            var tooltip_x = min(window_mouse_get_x(), view_get_wport(view_current) - str_width);
            var tooltip_y = min(window_mouse_get_y(), view_get_hport(view_current) - str_height);
            draw_rectangle_colour(
                tooltip_x, tooltip_y, tooltip_x + str_width, tooltip_y + str_height,
                c_tooltip, c_tooltip, c_tooltip, c_tooltip, false
            );
            draw_rectangle_colour(
                tooltip_x, tooltip_y, tooltip_x + str_width, tooltip_y + str_height,
                c_black, c_black, c_black, c_black, true
            );
            draw_text_ext(tooltip_x + str_padding, tooltip_y + str_padding, str, -1, text_width);
            draw_set_halign(halign);
            draw_set_valign(valign);
            instance_deactivate_object(Stuff.element_tooltip);
            window_set_cursor(cr_none);
        } else {
            window_set_cursor(cr_default);
        }
    } else {
        window_set_cursor(cr_default);
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