function ui_init_voxelish(mode) {
    var hud_start_x = 1080;
    var hud_start_y = 0;
    var hud_width = room_width - hud_start_x;
    var hud_height = room_height;
    var col1x = 32;
    var col2x = 272;
    var col_width = 216;
    
    var container = new EmuCore(0, 0, hud_width, hud_height);
    
    container.AddContent([
        (new EmuRenderSurface(0, 0, CW, CH, function(mx, my) {
            // draw
        }, function(mx, my) {
            if (mx < 0 || my < 0 || mx >= self.width || my >= self.height) return;
            if (Settings.terrain.orthographic) {
                Stuff.voxelish.camera.UpdateOrtho();
            } else {
                Stuff.voxelish.camera.Update();
            }
        }, function() {
            // create
        }, function() {
            // destroy
        }))
            .SetID("VOXELISH VIEWPORT"),
    ]);
    
    return container;
}