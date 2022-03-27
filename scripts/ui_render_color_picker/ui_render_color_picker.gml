function ui_render_color_picker(picker, xx, yy) {
    var x1 = picker.x + xx;
    var y1 = picker.y + yy;
    var x2 = x1 + picker.width;
    var y2 = y1 + picker.height;
    var c = picker.color;
    
    var tx = picker.GetTextX(x1, x2);
    var ty = picker.GetTextX(y1, y2);
    
    // this is not quite the same as ui_render_text
    draw_set_halign(picker.alignment);
    draw_set_valign(picker.valignment);
    draw_text_colour(tx, ty, picker.text, c, c, c, c, 1);
    
    var vx1 = x1 + picker.value_x1;
    var vy1 = y1 + picker.value_y1;
    var vx2 = x1 + picker.value_x2;
    var vy2 = y1 + picker.value_y2;
    
    draw_checkerbox(vx1, vy1, (vx2 - vx1), (vy2 - vy1));
    draw_set_alpha(picker.alpha);
    draw_set_colour(picker.value);
    draw_rectangle(vx1 + 1, vy1 + 1, vx2 - 1, vy2 - 1, false);
    draw_set_colour(c_black);
    draw_set_alpha(1);
    if (!picker.interactive) {
        draw_rectangle_colour(vx1 + 2, vy1 + 2, vx2 - 2, vy2 - 2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, true);
        draw_rectangle_colour(vx1 + 3, vy1 + 3, vx2 - 3, vy2 - 3, c_ltgray, c_ltgray, c_ltgray, c_ltgray, true);
    }
    draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c_black, c_black, true);
    
    if (picker.interactive && dialog_is_active(picker.root)) {
        var inbounds = mouse_within_rectangle(vx1, vy1, vx2, vy2);
        if (inbounds) {
            if (Controller.release_left) {
                ui_activate(picker);
                var dialog = dialog_create_color_picker_options(picker, picker.value, uivc_color_picker_reflect);
                dialog.el_picker.alpha = picker.alpha;
                dialog.el_picker.allow_alpha = picker.allow_alpha;
                dialog.active_shade = picker.active_shade;
            }
            Stuff.element_tooltip = picker;
        }
    }
    
    ui_handle_dropped_files(picker);
}