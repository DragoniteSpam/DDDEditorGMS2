/// @param UIProgressBar
/// @param x
/// @param y

if (Stuff.fmod_sound != noone) {
    argument0.value = FMODGMS_Chan_Get_Position(Stuff.fmod_channel) / FMODGMS_Snd_Get_Length(Stuff.fmod_sound);
}

// no alphabetize

var selection = ui_list_selection(argument0.root.el_list);
if (!ds_list_empty(Stuff.all_bgm) && selection !=noone) {
    var thing = Stuff.all_bgm[| selection];
    var length = FMODGMS_Snd_Get_Length(thing.fmod);
    
    var padding = 16;
    var x1 = argument1 + argument0.x + padding;
    var y1 = argument2 + argument0.y;
    var x2 = x1 + argument0.width - padding * 2;
    var y2 = y1 + argument0.height;

    var mid_yy = mean(y1, y2);
    var bar_y1 = mid_yy - argument0.thickness / 2 + 2;
    var bar_y2 = mid_yy + argument0.thickness / 2 - 2;
    var loop_start_x = x1 + thing.loop_start * AUDIO_BASE_FREQUENCY / length * (x2 - x1);
    var loop_end_x = x1 + thing.loop_end * AUDIO_BASE_FREQUENCY / length * (x2 - x1);
    
    draw_line_width_color(loop_start_x, bar_y1, loop_start_x, bar_y2, 2, c_red, c_red);
    draw_line_width_color(loop_end_x, bar_y1, loop_end_x, bar_y2, 2, c_red, c_red);
}

ui_render_progress_bar(argument0, argument1, argument2);