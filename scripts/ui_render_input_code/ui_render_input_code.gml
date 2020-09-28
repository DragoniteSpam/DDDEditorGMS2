/// @param UIInputCode
/// @param x
/// @param y
function ui_render_input_code(argument0, argument1, argument2) {

    var code = argument0;
    var xx = argument1;
    var yy = argument2;

    var x1 = code.x + xx;
    var y1 = code.y + yy;
    var x2 = x1 + code.width;
    var y2 = y1 + code.height;

    var tx = ui_get_text_x(code, x1, x2);
    var ty = ui_get_text_y(code, y1, y2);

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

    if (code.editor_handle) {
        script_execute(code.onsave, code);
        script_execute(code.onvaluechange, code);
    
        if (ds_stuff_process_complete(code.editor_handle)) {
            code.editor_handle = noone;
            var location = code.is_code ? get_temp_code_path(code) : get_temp_text_path(code);
            file_delete(location);
        }
    }

    if (code.editor_handle) {
        var omu = null;
        var interactable = false;
    } else {
        var omu = code.onmouseup;
        var interactable = code.interactive && dialog_is_active(code.root);
    }

    var message = string_comma(string_length(code.value)) + " bytes (edit)";

    ui_render_button_general(vx1, vy1, vx2, vy2, vtx, vty, message, fa_left, fa_middle, c_black, interactable, omu, code);

    ui_handle_dropped_files(code);


}
