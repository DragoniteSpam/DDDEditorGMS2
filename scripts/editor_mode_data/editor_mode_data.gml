function editor_mode_data() {
    Stuff.mode = Stuff.data;
    
    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.DATA;
    }
    
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