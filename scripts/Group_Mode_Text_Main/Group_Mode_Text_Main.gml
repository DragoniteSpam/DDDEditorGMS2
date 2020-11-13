function EditorModeText() : EditorMode_Struct() constructor {
    update = function() { };
    render = function(mode) {
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_fullscreen: draw_editor_fullscreen(mode); break;
            case view_ribbon: draw_editor_menu(false); break;
        }
    }
    save = function() { };
    
    ui = ui_init_text();
    
    mode_id = ModeIDs.TEXT;
}

function EditorMode_Struct() constructor {update = null;
    render = function() { };
    cleanup = function() { };
    save = function() { };
    
    ui = undefined;
    mode_id = ModeIDs.MAP;
    
    ds_list_add(Stuff.all_modes, self);
}