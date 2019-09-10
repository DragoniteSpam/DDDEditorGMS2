/// @param UIProgressBar
/// @param x
/// @param y

var progress = argument0;
var xx = argument1;
var yy = argument2;

if (Stuff.fmod_sound) {
    progress.value = FMODGMS_Chan_Get_Position(Stuff.fmod_channel) / FMODGMS_Snd_Get_Length(Stuff.fmod_sound);
}

var selection = ui_list_selection(progress.root.el_list);
if (!ds_list_empty(Stuff.all_bgm) && selection) {
    var thing = Stuff.all_bgm[| selection];
    var length = FMODGMS_Snd_Get_Length(thing.fmod);
    
    var padding = 16;
    var x1 = xx + progress.x + padding;
    var y1 = yy + progress.y;
    var x2 = x1 + progress.width - padding * 2;
    var y2 = y1 + progress.height;

    var mid_yy = mean(y1, y2);
    var bar_y1 = mid_yy - progress.thickness / 2 + 2;
    var bar_y2 = mid_yy + progress.thickness / 2 - 2;
    var loop_start_x = x1 + thing.loop_start * AUDIO_BASE_FREQUENCY / length * (x2 - x1);
    var loop_end_x = x1 + thing.loop_end * AUDIO_BASE_FREQUENCY / length * (x2 - x1);
    
    draw_line_width_color(loop_start_x, bar_y1, loop_start_x, bar_y2, 2, c_red, c_red);
    draw_line_width_color(loop_end_x, bar_y1, loop_end_x, bar_y2, 2, c_red, c_red);
}

ui_render_progress_bar(progress, xx, yy);