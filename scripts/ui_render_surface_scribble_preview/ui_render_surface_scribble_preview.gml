/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2
function ui_render_surface_scribble_preview(argument0, argument1, argument2, argument3, argument4) {

    var surface = argument0;
    var x1 = argument1;
    var y1 = argument2;
    var x2 = argument3;
    var y2 = argument4;
    var mode = Stuff.scribble;
    var padding = 32;
    var sw = surface_get_width(surface.surface);
    var sh = surface_get_height(surface.surface);

    var old_color = global.scribble_state_starting_color;
    mode.scribble_default_colour = surface.root.el_scribble_default_colour.value;
    global.scribble_state_starting_color = mode.scribble_default_colour;

    draw_clear(mode.scribble_back_colour);
    draw_rectangle_colour(1, 1, sw - 2, sh - 2, c_black, c_black, c_black, c_black, true);

    var f = normalize(mode.scribble_bounds_width, mode.scribble_bounds_width_min, mode.scribble_bounds_width_max, 0, 1) * (surface_get_width(surface.surface) - padding * 2);
    scribble_set_wrap(f, -1);

    if (!is_array(mode.scribble) || (mode.scribble[SCRIBBLE.STRING] != mode.scribble_text && (mode.scribble_text_time + 500) < current_time)) {
        scribble_flush();
        mode.scribble = scribble_cache(mode.scribble_text);
        editor_scribble_autotype_fire();
    } else {
        if (scribble_autotype_get(mode.scribble) == 1) {
            if (mode.scribble_autotype_completion_time == -1) {
                mode.scribble_autotype_completion_time = current_time;
            } else if (current_time > (mode.scribble_autotype_completion_time + mode.scribble_autotype_in_delay * 1000)) {
                editor_scribble_autotype_finish();
                mode.scribble_autotype_completion_time = -1;
            }
        } else if (scribble_autotype_get(mode.scribble) == 2) {
            if (mode.scribble_autotype_completion_time == -1) {
                mode.scribble_autotype_completion_time = current_time;
            } else if (current_time > (mode.scribble_autotype_completion_time + mode.scribble_autotype_out_delay * 1000)) {
                editor_scribble_autotype_fire();
                mode.scribble_autotype_completion_time = -1;
            }
        }
    }

    var box = scribble_get_bbox(0, 0, mode.scribble);
    var hh = box[SCRIBBLE_BBOX.H];
    var scribble_xx = padding;
    var scribble_yy = min(padding, sh - padding - hh);

    if (mode.scribble_back_show_guides) {
        var line_length = 32;
        var line_spacing = 16;
        var line_colour = c_green;
        // TIL game maker lets you skip terms in a for loop, the way other languages do
        // vertical rules
        for (var i = 0; i < sh;) {
            draw_line_colour(padding, i, padding, i + line_length, line_colour, line_colour);
            draw_line_colour(f + padding, i, f + padding, i + line_length, line_colour, line_colour);
            i = i + line_length + line_spacing;
        }
        // horizontal rule
        for (var i = 0; i < sw;) {
            draw_line_colour(i, scribble_yy, i + line_length, scribble_yy, line_colour, line_colour);
            i = i + line_length + line_spacing;
        }
    }

    scribble_draw(scribble_xx, scribble_yy, mode.scribble);

    global.scribble_state_starting_color = old_color;


}
