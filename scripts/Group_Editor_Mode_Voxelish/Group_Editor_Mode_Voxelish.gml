function EditorModeVoxelish() : EditorModeBase() constructor {
    debug_timer_start();
    
    Stuff.voxelish = self;
    self.ui = ui_init_voxelish(self);
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.VOXELISH);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        self.ui.Render(0, 0);
        editor_gui_post();
    };
}