function menu_render_main(menu, xx, yy) {
    draw_rectangle_colour(0, 0, xx + room_width, yy + menu.element_height, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, false);
    draw_set_font(FDefault);
    draw_set_valign(fa_middle);
    
    menu.mouse_over = noone;
    
    for (var i = 0; i < ds_list_size(menu.contents); i++) {
        var thing = menu.contents[| i];
        if (thing.enabled) {
            if (is_struct(thing)) {
                thing.Render(xx + menu.element_width * i, yy); 
            } else {
                thing.render(thing, xx + menu.element_width * i, yy); 
            }
        }
    }
    
    draw_line_colour(0, yy + menu.element_height, xx + room_width, yy + menu.element_height, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT);
    
    var element = Stuff.menu.extra_element;
    if (element) {
        if (is_struct(element)) {
            element.Render(element.x, element.y); 
        } else {
            element.render(element, element.x, element.y); 
        }
    }
    
    if (!dialog_exists()) {
        if (mouse_within_rectangle_view(0, 0, xx + room_width, yy + menu.element_height)) {
            if (!menu.mouse_over && (Controller.press_left || Controller.press_right)) {
                menu_activate(noone);
            }
            Controller.press_left = false;
            Controller.press_right = false;
        }
    }
    
    // if the cursor is in the menu bar just disable clicking, because it'll be more
    // trouble than it's worth
}