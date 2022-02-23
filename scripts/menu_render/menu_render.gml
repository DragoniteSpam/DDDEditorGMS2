function menu_render(menu, x1, y1) {
    var x2 = x1 + menu.width;
    var y2 = y1 + menu.height;
    
    menu.x = x1;
    menu.y = y1;
    
    var tx = menu.GetTextX(x1, x2);
    var ty = menu.GetTextX(y1, y2);
    
    draw_set_halign(menu.alignment);
    draw_set_valign(menu.valignment);
    draw_set_color(menu.color);
    
    if (!menu.invisible) {
        // click on the header
        if (mouse_within_rectangle(x1, y1, x2, y2)) {
            draw_rectangle_colour(x1, y1, x2, y2, EMU_COLOR_HOVER, EMU_COLOR_HOVER, EMU_COLOR_HOVER, EMU_COLOR_HOVER, false);
            if (!dialog_exists() && Controller.press_left) {
                Controller.press_left = false;
                menu_activate(menu);
            }
        }
        
        draw_text(tx, ty - 4, string(menu.text));
    }
    
    if (menu_is_active(menu)) {
        var separation = 20;
        var ww = separation * 2;
        for (var i = 0; i < ds_list_size(menu.contents); i++) {
            var ew = string_width(string(menu.contents[| i].text));
            if (menu.contents[| i].expandable) ew += separation;
            ww = max(ww, ew + separation * 2);
        }
        // todo limit hh and add a scroll bar if it flows offscreen
        var hh = menu.height * ds_list_size(menu.contents) + separation * 2;
        var xx = x1;
        if (xx + ww > CW) {
            xx = CW - ww;
        }
        var yy = y2;
        if (yy + hh > CH) {
            yy = CH - hh;
        }
        
        draw_rectangle_colour(xx, yy, xx + ww, yy + hh, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, false);
        
        for (var i = 0; i < ds_list_size(menu.contents); i++) {
            var thing = menu.contents[| i];
            if (thing.enabled) {
                var mx1 = xx;
                var my1 = yy + menu.height * i + separation;
                var mx2 = mx1 + ww + 2;
                var my2 = my1 + menu.height;
                if (is_struct(thing)) {
                    thing.Render(mx1, my1, mx2, my2); 
                } else {
                    thing.render(thing, mx1, my1, mx2, my2); 
                }
            }
        }
        
        draw_line_colour(xx, yy, xx, yy + hh, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT);
        draw_line_colour(xx + ww, yy, xx + ww, yy + hh, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT);
        draw_line_colour(xx, yy + hh, xx + ww, yy + hh, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT);
    }
}