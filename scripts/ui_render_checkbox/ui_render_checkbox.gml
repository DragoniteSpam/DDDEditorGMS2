/// @param UICheckbox
/// @param x
/// @param y
function ui_render_checkbox(argument0, argument1, argument2) {

    var checkbox = argument0;
    var xx = argument1;
    var yy = argument2;

    var x1 = checkbox.x + xx;
    var y1 = checkbox.y + yy;
    var x2 = x1 + checkbox.width;
    var y2 = y1 + checkbox.height;

    var tx = ui_get_text_x(checkbox, x1, x2);
    var ty = ui_get_text_y(checkbox, y1, y2);

    draw_set_halign(checkbox.alignment);
    draw_set_valign(checkbox.valignment);
    draw_set_color(checkbox.color);
    draw_text(tx + 32, ty, string(checkbox.text));

    var s2 = 8;
    var inbounds = mouse_within_rectangle_determine(x1, y1, x2, y2, checkbox.adjust_view);

    if (!checkbox.interactive) {
        draw_rectangle_colour(tx + 16 - s2, ty - s2, tx + 16 + s2, ty + s2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
    } else {
        if (dialog_is_active(checkbox.root)) {
            if (inbounds) {
                draw_rectangle_colour(tx + 16 - s2, ty - s2, tx + 16 + s2, ty + s2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
            }
        }
    }
    draw_rectangle(tx + 16 - s2, ty - s2, tx + 16 + s2, ty + s2, true);

    var a = checkbox.interactive ? 1 : 0.5;

    // these are actually not binary states - in some rare cases there may be an "undecided," etc state
    if (checkbox.value == 2) {
        draw_sprite_ext(spr_check, 1, tx + 16, ty, 1, 1, 0, c_white, a);
    } else if (checkbox.value) {
        draw_sprite_ext(spr_check, 0, tx + 16, ty, 1, 1, 0, c_white, a);
    }

    if (checkbox.interactive && dialog_is_active(checkbox.root)) {
        if (inbounds) {
            if (Controller.release_left) {
                checkbox.value = !checkbox.value;
                ui_activate(checkbox);
                script_execute(checkbox.onvaluechange, checkbox);
            }
            Stuff.element_tooltip = checkbox;
        }
    }

    ui_handle_dropped_files(checkbox);


}
