function editor_set_mode(mode_structure, mode_id) {
    Stuff.mode = mode_structure;
    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = mode_id;
    }
}

function editor_mode_3d() {
    editor_set_mode(Stuff.map, ModeIDs.MAP);
}

function editor_mode_text() {
    editor_set_mode(Stuff.text, ModeIDs.TEXT);
}

function editor_mode_spart() {
    editor_set_mode(Stuff.spart, ModeIDs.SPART);
}

function editor_mode_heightmap() {
    editor_set_mode(Stuff.terrain, ModeIDs.TERRAIN);
}

function editor_mode_event() {
    editor_set_mode(Stuff.event, ModeIDs.EVENT);
}

function editor_mode_data() {
    editor_set_mode(Stuff.data, ModeIDs.DATA);
    
    // creating and destroying the data editor UI is probably the easiest way
    // to do this; this may need to get stuffed off into its own script later
    
    if (Stuff.data.ui) {
        instance_activate_object(Stuff.data.ui);
        instance_destroy(Stuff.data.ui);
    }
    
    Stuff.data.ui = ui_init_game_data(Stuff.data);
    
    if (array_length(Game.data) > 0) {
        ui_list_select(Stuff.data.ui.el_master, 0);
    }
    
    ui_init_game_data_activate();
}

function editor_mode_animation() {
    editor_set_mode(Stuff.animation, ModeIDs.ANIMATION);
}

function editor_mode_meshes() {
    editor_set_mode(Stuff.mesh_ed, ModeIDs.MESH);
}