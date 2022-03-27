event_inherited();

ui = ui_init_animation(id);

self.camera = new Camera(0, 0, 100, 100, 100, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
    
});
var threed_surface = self.ui.SearchID("3D VIEW");
self.camera.SetCenter(threed_surface.x + threed_surface.width / 2, threed_surface.y + threed_surface.height / 2);
self.camera.base_speed = 20;
self.camera.Load(setting_get("mesh", "camera", undefined));
self.camera.SetViewportAspect(function() {
    return Stuff.mesh_ed.ui.SearchID("3D VIEW").width;
}, function() {
    return Stuff.mesh_ed.ui.SearchID("3D VIEW").height;
});

update = function() {
    if (!Stuff.mouse_3d_lock && !dialog_exists()) {
        self.camera.Update();
    }
};

render = function() {
    gpu_set_cullmode(cull_noculling);
    draw_editor_animation();
    draw_animator();
    draw_animator_overlay();
    draw_editor_menu();
};

save = function() {
    Settings.animation.camera = self.camera.Save();
};

mode_id = ModeIDs.ANIMATION;