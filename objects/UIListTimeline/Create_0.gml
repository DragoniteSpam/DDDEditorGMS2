event_inherited();

render = ui_render_list_timeline;

moment_index = 0;
moment_width = 32;
moment_slots = 16;

selected_moment = -1;
selected_layer = -1;
selected_keyframe = noone;

playing = false;
playing_moment = 0;

oninteract = null;