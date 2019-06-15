/// @param Button
/// @param x
/// @param y

var x1 = argument0.x + argument1;
var y1 = argument0.y + argument2;
var x2 = x1 + argument0.width;
var y2 = y1 + argument0.height;

var tx = ui_get_text_x(argument0, x1, x2);
var ty = ui_get_text_y(argument0, y1, y2);

var value = argument0.value;

// this is not quite the same as ui_render_text
draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx, ty, string(argument0.text));

var vx1 = x1 + argument0.value_x1;
var vy1 = y1 + argument0.value_y1;
var vx2 = x1 + argument0.value_x2;
var vy2 = y1 + argument0.value_y2;

var vtx = vx1 + 12;
var vty = mean(vy1, vy2);

if (argument0.editor_handle != noone) {
    if (ds_stuff_process_complete(argument0.editor_handle)) {
        argument0.editor_handle = noone;
        file_delete(PATH_TEMP_CODE + string(argument0.id) + get_code_extension());
    }
    script_execute(argument0.onsave, argument0);
    script_execute(argument0.onvaluechange, argument0);
}

if (argument0.editor_handle == noone) {
    var omu = argument0.onmouseup;
    var interactable = argument0.interactive && dialog_is_active(argument0.root);
} else {
    var omu = null;
    var interactable = false;
}

var message = string_comma(string_length(argument0.value)) + " bytes (edit)";

ui_render_button_general(vx1, vy1, vx2, vy2, vtx, vty, message, fa_left, fa_middle, c_black, interactable, omu, argument0);