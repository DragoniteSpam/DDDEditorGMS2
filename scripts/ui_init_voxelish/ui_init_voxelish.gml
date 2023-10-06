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
            if (Settings.voxelish.orthographic) {
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
        (new EmuTabGroup(hud_start_x, EMU_BASE, hud_width, hud_height - 32, 1, 32)).AddTabs(0, [
            (new EmuTab("General")).AddContent([
                new EmuText(col1x, EMU_AUTO, col_width, 32, "[c_aqua]General Settings"),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Width"))
                    .SetTextUpdate(function() { return "Width: " + string(Stuff.voxelish.model.width); })
                    .SetID("LABEL_WIDTH"),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Height:"))
                    .SetTextUpdate(function() { return "Height: " + string(Stuff.voxelish.model.height); })
                    .SetID("LABEL_HEIGHT"),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Orthographic view?", Settings.voxelish.orthographic, function() {
                    Settings.voxelish.orthographic = self.value;
                }))
                    .SetTooltip("View the world through an overhead camera."),
            ]),
            (new EmuTab("Rendering")).AddContent([
            ]),
            (new EmuTab("Deforming")).AddContent([
            ]),
            (new EmuTab("Pathing")).AddContent([
            ])
        ])
    ]);
    
    return container;
}