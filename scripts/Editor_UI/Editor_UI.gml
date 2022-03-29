function editor_gui_button(sprite, index, x, y, offx, offy, callback_mouseover, callback_click) {    var iconw = sprite_get_width(sprite);
    var iconh = sprite_get_height(sprite);
    
    var inbounds = mouse_within_rectangle(x + offx, y + offy, x + iconw + offx, y + iconh + offy);
    draw_sprite_ext(sprite, index, x, y, 1, 1, 0, inbounds ? c_ui_select : c_white, 1);
    
    if (inbounds) {
        callback_mouseover();
        if (Controller.release_left) {
            callback_click();
        }
    }
}
