function EditorModeText() : EditorMode_Struct() constructor {
    Update = function() { };
    
    Render = function() {
        gpu_set_cullmode(cull_noculling);
        draw_editor_fullscreen();
        draw_editor_menu(false);
    };
    
    Save = function() { };
    
    ui = ui_init_text();
    
    mode_id = ModeIDs.TEXT;
}

function EditorMode_Struct() constructor {
    Update = function() { };
    Render = function() { };
    Cleanup = function() { };
    Save = function() { };
    
    ui = undefined;
    mode_id = ModeIDs.MAP;
    
    ds_list_add(Stuff.all_modes, self);
}