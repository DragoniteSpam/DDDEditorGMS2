function menu_render_element(menumenu, x1, y1, x2, y2) {
    // the root menu objects calculate their x2 and y2 based on their width
    // and height, but since the width and height of menu elements are based
    // on their neighbors, we just pass them as parameters
    x2--;
    y2--;
    
    menumenu.x = x1;
    menumenu.y = y1;
    
    var tx = menumenu.GetTextX(x1, x2);
    var ty = menumenu.GetTextY(y1, y2);
    
    var active = menu_is_active(menumenu) && menumenu.interactive;
    var mouse_inbounds = mouse_within_rectangle(x1, y1, x2, y2);
    
    // click on the element
    if (mouse_inbounds || active || !menumenu.interactive) {
        draw_rectangle_colour(x1, y1, x2 - 1, y2, EMU_COLOR_HOVER, EMU_COLOR_HOVER, EMU_COLOR_HOVER, EMU_COLOR_HOVER, false);
    }
    
    if (menumenu.interactive && mouse_inbounds) {
        if (Controller.release_left && !dialog_exists()) {
            Controller.release_left = false;
            menumenu.onmouseup();
        }
        Stuff.menu.mouse_over = menumenu;
    }
    
    draw_set_halign(menumenu.alignment);
    draw_set_valign(menumenu.valignment);
    draw_text_colour(tx, ty, string(menumenu.text), menumenu.color, menumenu.color, menumenu.color, menumenu.color, 1);
    
    if (menumenu.expandable) {
        var s = 5;
        draw_triangle(x2 - s * 2, ty - s, x2 - s, ty, x2 - s * 2, ty + s, false);
    }
    
    if (active) {
        var separation = 20;
        var ww = separation * 2;
        for (var i = 0; i < ds_list_size(menumenu.contents); i++) {
            var ew = string_width(string(menumenu.contents[| i].text));
            if (menumenu.contents[| i].expandable) {
                ew += separation;
            }
            ww = max(ww, ew + separation * 2);
        }
        // todo limit hh and add a scroll bar if it flows offscreen
        var hh = menumenu.height * ds_list_size(menumenu.contents) + separation * 2;
        var xx = x2;
        if (xx + ww > CW) {
            xx = CW - ww;
        }
        var yy = y1;
        if (yy + hh > CH) {
            yy = CH - hh;
        }
        draw_rectangle_colour(xx, yy, xx + ww, yy + hh, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, false);
        for (var i = 0; i < ds_list_size(menumenu.contents); i++) {
            var thing = menumenu.contents[| i];
            if (thing.enabled) {
                var mx1 = xx;
                var my1 = yy + menumenu.height * i + separation;
                var mx2 = mx1 + ww;
                var my2 = my1 + menumenu.height;
                if (is_struct(thing)) {
                    thing.Render(mx1, my1, mx2, my2); 
                } else {
                    thing.render(thing, mx1, my1, mx2, my2); 
                }
            }
        }
        draw_rectangle_colour(xx, yy, xx + ww - 1, yy + hh - 1, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT, EMU_COLOR_DEFAULT, true);
    }
}