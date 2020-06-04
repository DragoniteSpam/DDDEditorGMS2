/// @param odds

var odds = argument0;
var frame_rate = game_get_speed(gamespeed_fps);

if (odds < frame_rate) {
    return -1 / (odds / 60);
} else {
    return odds / frame_rate;
}