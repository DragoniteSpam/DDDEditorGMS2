/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2

var surface = argument0;
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;
var mode = Stuff.scribble;
var padding = 32;

draw_clear(c_white);
draw_rectangle_colour(1, 1, surface_get_width(surface.surface) - 2, surface_get_height(surface.surface) - 2, c_black, c_black, c_black, c_black, true);

var f = normalize_correct(mode.scribble_bounds_width, mode.scribble_bounds_width_min, mode.scribble_bounds_width_max, 0, 1);
scribble_draw_set_wrap(-1, f * (surface_get_width(surface.surface) - padding * 2), -1);

if (!is_array(mode.scribble) || (mode.scribble[__SCRIBBLE.STRING] != mode.scribble_text && (mode.scribble_text_time + 1000) < current_time)) {
    scribble_draw_set_cache_group(0, false, true);
    mode.scribble = scribble_draw(padding, padding, mode.scribble_text);
    scribble_draw_set_cache_group(0, true, true);
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

scribble_draw(padding, padding, mode.scribble);