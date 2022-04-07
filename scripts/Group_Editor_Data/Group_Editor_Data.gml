function EditorModeData() : EditorModeBase() constructor {
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.DATA);
        
        // creating and destroying the data editor UI is probably the easiest
        // way to do this; this may need to get stuffed off into its own script
        // later
        if (self.ui) {
            instance_activate_object(self.ui);
            instance_destroy(self.ui);
        }
    
        self.ui = ui_init_game_data(self);
    
        if (array_length(Game.data) > 0) {
            ui_list_select(self.ui.el_master, 0);
        }
    
        ui_init_game_data_activate();
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        self.ui.Render();
        editor_gui_post();
    };

    self.Save = function() {
        
    };
    
    self.active_type_guid = NULL;
    self.ui = undefined;
    self.mode_id = ModeIDs.DATA;
}
