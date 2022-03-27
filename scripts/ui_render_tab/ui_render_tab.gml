/// @param UITab
/// @param x
/// @param y
function ui_render_tab(argument0, argument1, argument2) {
    // this is for drawing the actual tab, not its contents. if you put
    // the code to draw the contents in here and have more than one tab,
    // everything is going to be layered on top of everything else.

    var tab = argument0;
    var xx = argument1;
    var yy = argument2;

    var x1 = tab.x + xx;
    var y1 = tab.y - tab.height / 2 + yy;
    var x2 = x1 + tab.width;
    var y2 = y1 + tab.height;

    if (!tab.interactive) {
        draw_rectangle_colour(x1, y1, x2, y2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, true);
    }

    draw_line(x1, y1, x2, y1);
    draw_line(x1, y1, x1, y2);
    draw_line(x2, y1, x2, y2);

    if (tab.root.active_tab != tab) {
        draw_line(x1, y2, x2, y2);
    }

    var tx = tab.GetTextX(x1, x2);
    var ty = tab.GetTextX(y1, y2);

    draw_set_halign(tab.alignment);
    draw_set_valign(tab.valignment);
    draw_set_color(tab.color);
    draw_text(tx, ty, string(tab.text));

    if (tab.interactive && dialog_is_active(tab.root)) {
        var inbounds = mouse_within_rectangle(x1, y1, x2, y2);
        if (inbounds) {
            if (Controller.release_left) {
                ui_activate(tab);
                tab.onmouseup(tab);
            }
            Stuff.element_tooltip = tab;
        }
    }

    ui_handle_dropped_files(tab);


}
