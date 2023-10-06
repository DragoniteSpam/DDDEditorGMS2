function EditorModeVoxelish() : EditorModeBase() constructor {
    debug_timer_start();
    
    Stuff.voxelish = self;
    self.ui = ui_init_voxelish(self);
    
    self.camera = new Camera(0, 0, 64, 64, 64, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
        Stuff.terrain.mouse_interaction(mouse_vector);
    });
    self.camera.base_speed = 20;
    self.camera.Load(setting_get("voxelish", "camera", undefined));
    self.camera.SetViewportAspect(function() {
        return Stuff.terrain.ui.SearchID("VOXELISH VIEWPORT").width;
    }, function() {
        return Stuff.terrain.ui.SearchID("VOXELISH VIEWPORT").height;
    });
    self.camera.SetCenter(self.ui.SearchID("VOXELISH VIEWPORT").width / 2, self.ui.SearchID("VOXELISH VIEWPORT").height / 2);
    self.camera.SetSkybox(Stuff.graphics.skybox_base, Stuff.graphics.default_skybox);
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.VOXELISH);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        self.ui.Render(0, 0);
        editor_gui_post();
    };
}