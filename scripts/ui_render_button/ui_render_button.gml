function ui_render_button(button, xx, yy) {
    var x1 = button.x + xx;
    var y1 = button.y + yy;
    var x2 = x1 + button.width;
    var y2 = y1 + button.height;
    
    var tx = button.GetTextX(x1, x2);
    var ty = button.GetTextX(y1, y2);
    
    ui_render_button_general(
        x1, y1, x2, y2, tx, ty, button.text, button.alignment, button.valignment, button.color,
        button.interactive && dialog_is_active(button.root), button.onmouseup, button
    );
    
    ui_handle_dropped_files(button);
}