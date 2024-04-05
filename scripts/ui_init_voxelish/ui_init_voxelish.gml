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
            Stuff.voxelish.DrawTerrain();
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
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Width (X):", string(Stuff.voxelish.model.width), "Map width (X)", 3, E_InputTypes.INT, function() {
                    
                    var value = real(self.value);
                    if (value < Stuff.voxelish.model.width) {
                        var dialog = emu_dialog_confirm(self, "Trying to resize the grid to be smaller than the current one may result in cells being lost. Continue?", function() {
                            Stuff.voxelish.model.Resize(self.root.dimension_value, Stuff.voxelish.model.height, Stuff.voxelish.model.depth);
                            self.root.Dispose();
                        });
                        dialog.dimension_value = value;
                    } else {
                        Stuff.voxelish.model.Resize(value, Stuff.voxelish.model.height, Stuff.voxelish.model.depth);
                    }
                }))
                    .SetRequireConfirm(true)
                    .SetID("LABEL_WIDTH"),
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Height (Y):", string(Stuff.voxelish.model.height), "Map height (Y)", 3, E_InputTypes.INT, function() {
                    var value = real(self.value);
                    if (value < Stuff.voxelish.model.height) {
                        var dialog = emu_dialog_confirm(self, "Trying to resize the grid to be smaller than the current one may result in cells being lost. Continue?", function() {
                            Stuff.voxelish.model.Resize(Stuff.voxelish.model.width, self.root.dimension_value, Stuff.voxelish.model.depth);
                            self.root.Dispose();
                        });
                        dialog.dimension_value = value;
                    } else {
                        Stuff.voxelish.model.Resize(Stuff.voxelish.model.width, value, Stuff.voxelish.model.depth);
                    }
                }))
                    .SetRequireConfirm(true)
                    .SetID("LABEL_HEIGHT"),
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Depth (Z):", string(Stuff.voxelish.model.height), "Map depth (Z)", 3, E_InputTypes.INT, function() {
                    var value = real(self.value);
                    if (value < Stuff.voxelish.model.depth) {
                        var dialog = emu_dialog_confirm(self, "Trying to resize the grid to be smaller than the current one may result in cells being lost. Continue?", function() {
                            Stuff.voxelish.model.Resize(Stuff.voxelish.model.width, Stuff.voxelish.model.height, self.root.dimension_value);
                            self.root.Dispose();
                        });
                        dialog.dimension_value = value;
                    } else {
                        Stuff.voxelish.model.Resize(Stuff.voxelish.model.width, Stuff.voxelish.model.height, value);
                    }
                }))
                    .SetRequireConfirm(true)
                    .SetID("LABEL_DEPTH"),
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Total size:")
                    .SetTextUpdate(function() {
                        var model = Stuff.voxelish.model;
                        return $"Total size: {string_comma(model.width * model.height * model.depth)} cubic cells";
                    })
                    .SetID("LABEL_TOTAL_SIZE"),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Orthographic view?", Settings.voxelish.orthographic, function() {
                    Settings.voxelish.orthographic = self.value;
                }))
                    .SetTooltip("View the world through an overhead camera."),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Autotile meshes", function() {
                    dialog_create_manager_mesh_autotile();
                })
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