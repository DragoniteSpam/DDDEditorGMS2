function ui_render_input_code(code, xx, yy) {
    var x1 = code.x + xx;
    var y1 = code.y + yy;
    var x2 = x1 + code.width;
    var y2 = y1 + code.height;
    
    var tx = code.GetTextX(x1, x2);
    var ty = code.GetTextX(y1, y2);
    
    var value = code.value;
    
    // this is not quite the same as ui_render_text
    draw_set_halign(code.alignment);
    draw_set_valign(code.valignment);
    draw_set_color(code.color);
    draw_text(tx, ty, string(code.text));
    
    var vx1 = x1 + code.value_x1;
    var vy1 = y1 + code.value_y1;
    var vx2 = x1 + code.value_x2;
    var vy2 = y1 + code.value_y2;
    
    var vtx = vx1 + 12;
    var vty = mean(vy1, vy2);
    
    var omu = null;
    var interactable = false;
    
    if (code.interactive) {
        if (code.editor_handle) {
            code.onsave(code);
            code.onvaluechange(code);
        }
        
        if (!code.editor_handle) {
            omu = code.onmouseup;
            interactable = code.interactive && dialog_is_active(code.root);
        }
        
        ui_handle_dropped_files(code);
    }
    
    var message = string_comma(string_length(code.value)) + " bytes (edit)";
    ui_render_button_general(vx1, vy1, vx2, vy2, vtx, vty, message, fa_left, fa_middle, c_black, interactable, omu, code);
}