function ui_render_button_general(x1, y1, x2, y2, tx, ty, text, halign, valign, color, interactive, onmouseup, thing) {
    // the background goes before everything, because you want to draw over it on hover
    var c = interactive ? c_white : c_ltgray;
    draw_rectangle_colour(x1, y1, x2, y2, c, c, c, c, false);
    
    if (interactive) {
        var inbounds = mouse_within_rectangle(x1, y1, x2, y2);
        if (inbounds) {
            draw_rectangle_colour(x1, y1, x2, y2, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.release_left) {
                Controller.release_left = false;
                ui_activate(thing);
                onmouseup(thing);
            }
            Stuff.element_tooltip = thing;
        }
    }
    
    if (thing.outline) {
        draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);
    }
    
    draw_set_halign(halign);
    draw_set_valign(valign);
    draw_set_color(color);
    draw_text_ext(tx, ty, string(text), -1, x2 - x1);
}