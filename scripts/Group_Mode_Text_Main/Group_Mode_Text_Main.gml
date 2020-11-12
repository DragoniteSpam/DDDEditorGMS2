function EditorModeText() : EditorMode_Struct() constructor {
    update = function() { };
    render = function(mode) { /* */ };
    save = function() { };
    
    mode_id = ModeIDs.TERRAIN;
}

function EditorMode_Struct() constructor {update = null;
    render = function() { };
    cleanup = function() { };
    save = function() { };
    
    ui = undefined;
    mode_id = ModeIDs.MAP;
    
    ds_list_add(Stuff.all_modes, self);
}