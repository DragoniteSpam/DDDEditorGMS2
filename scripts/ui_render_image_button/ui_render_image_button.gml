function ui_render_image_button(button, xx, yy) {
    var x1 = button.x + xx;
    var y1 = button.y + yy;
    var x2 = x1 + button.width;
    var y2 = y1 + button.height;
    
    var tx = button.GetTextX(x1, x2);
    var ty = button.GetTextX(y1, y2);
    
    // Drawing to the surface instead of the screen directly - everything drawn needs
    // to be minus x1 and minus y1, because suddenly we're drawing at the origin again
    #region input drawing
    button.surface = surface_rebuild(button.surface, button.width, button.height);
    
    surface_set_target(button.surface);
    draw_clear_alpha(button.interactive ? c_white : c_ltgray, 1);
    
    if (button.draw_checker_behind) {
        draw_sprite_tiled(b_tileset_checkers, 0, 0, 0);
    }
    
    var color = c_white;
    if (button.interactive && dialog_is_active(button.root)) {
        var inbounds = mouse_within_rectangle(x1, y1, x2, y2);
        if (inbounds) {
            draw_rectangle_colour(0, 0, x2 - x1, y2 - y1, c_ui, c_ui, c_ui, c_ui, false);
            color = merge_color(c_white, c_ui, 0.5);
            if (Controller.release_left) {
                button.onmouseup(button);
            }
            Stuff.element_tooltip = button;
        }
    }
    
    if (!button.image) {
        draw_set_halign(button.alignment);
        draw_set_valign(button.valignment);
        draw_set_color(button.color);
        draw_text_ext(tx - x1, ty - y1, string(button.text), -1, button.width);
    } else {
        if (button.scale_to_fit) {
            var xscale = min(button.width / sprite_get_width(button.image), 1);
            var yscale = min(button.height / sprite_get_height(button.image), 1);
            draw_sprite_general(
                button.image, button.index, 0, 0, sprite_get_width(button.image),
                sprite_get_height(button.image), 0, 0, xscale, yscale, 0, color, color, color, color, 1
            );
        } else {
            draw_sprite_general(
                button.image, button.index, 0, 0, sprite_get_width(button.image),
                sprite_get_height(button.image), 0, 0, 1, 1, 0, color, color, color, color, 1
            );
        }
    }
    
    draw_rectangle_colour(1, 1, button.width - 2, button.height - 2, c_black, c_black, c_black, c_black, true);
    surface_reset_target();
    #endregion
    
    draw_surface(button.surface, x1, y1);
    
    ui_handle_dropped_files(button);
}