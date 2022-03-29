function editor_gui_button(sprite, index, x, y, offx, offy, callback) {    var iconw = sprite_get_width(sprite);
    var iconh = sprite_get_height(sprite);
    var inbounds = mouse_within_rectangle(x + offx, y + offy + 16, x + iconw + offx, y + iconh + offy + 16);
    var c = inbounds ? c_ui_select : c_white;
    draw_roundrect_colour(x, y, x + iconw, y + iconh, c, c, false);
    draw_roundrect_colour(x, y, x + iconw, y + iconh, c_black, c_black, true);
    draw_sprite(sprite, index, x, y);
    
    if (inbounds && Controller.release_left) {
        callback();
    }
}
