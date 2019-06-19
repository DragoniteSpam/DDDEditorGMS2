/// @param UIProgressBar
/// @param x
/// @param y

if (Stuff.fmod_sound != noone) {
    argument0.progress = FMODGMS_Chan_Get_Position(Stuff.fmod_channel) / FMODGMS_Snd_Get_Length(Stuff.fmod_sound);
}

ui_render_progress_bar(argument0, argument1, argument2);