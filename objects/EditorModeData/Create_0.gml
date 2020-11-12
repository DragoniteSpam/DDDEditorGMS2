event_inherited();

render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_fullscreen: draw_editor_fullscreen(); break;
        case view_ribbon: draw_editor_menu(); break;
    }
};
save = function() { };

ui = noone;
mode_id = ModeIDs.DATA;