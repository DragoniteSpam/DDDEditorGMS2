event_inherited();

render = function() {
    gpu_set_cullmode(cull_noculling);
    draw_editor_fullscreen();
    draw_editor_menu();
};

save = function() { };

ui = noone;
mode_id = ModeIDs.DATA;