function dialog_create_mesh_viewer_settings() {
    var dialog = new EmuDialog(32 + 320 + 32, 640, "Mesh viewer settings");
    dialog.root = self;
    dialog.active_shade = 0;
    dialog.x = 320;
    dialog.y = 120;
    
    var col1x = 32;
    var col_width = 320;
    
    dialog.AddContent([
        #region column 1
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw textures?", Settings.mesh.draw_textures, function() {
            Settings.mesh.draw_textures = self.value;
        }))
            .SetTooltip("Whether or not to draw the meshes in the preview window using a texture.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_textures;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw vertex colors?", Settings.mesh.draw_vertex_colors, function() {
            Settings.mesh.draw_vertex_colors = self.value;
        }))
            .SetTooltip("Whether or not to colorize the verties of meshes.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_vertex_colors;
            }),
        new EmuText(col1x, EMU_AUTO, col_width, 32, "Wireframe alpha:"),
        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 1, true, Settings.mesh.wireframe_alpha, function() {
            Settings.mesh.wireframe_alpha = self.value;
        }))
            .SetTooltip("Draw a wireframe over the 3D mesh. Turn this off if it gets annoying.")
            .SetRefresh(function() {
                self.value = Settings.mesh.wireframe_alpha;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw lighting?", Settings.mesh.draw_lighting, function() {
            Settings.mesh.draw_lighting = self.value;
        }))
            .SetTooltip("Whether or not to lighting should be enabled.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_lighting;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw backfaces?", Settings.mesh.draw_back_faces, function() {
            Settings.mesh.draw_back_faces = self.value;
        }))
            .SetTooltip("For backface culling.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_back_faces;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw 3D axes?", Settings.mesh.draw_axes, function() {
            Settings.mesh.draw_axes = self.value;
        }))
            .SetTooltip("Whether or not to draw the red, green, and blue axes in the 3D view.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_axes;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw grid?", Settings.mesh.draw_grid, function() {
            Settings.mesh.draw_grid = self.value;
        }))
            .SetTooltip("Whether or not to draw the tile grid on the Z = 0 plane.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_grid;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw physical bounds?", Settings.mesh.draw_physical_bounds, function() {
            Settings.mesh.draw_physical_bounds = self.value;
        }))
            .SetTooltip("Whether or not to draw the tile grid on the Z = 0 plane.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_physical_bounds;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw gizmos?", Settings.mesh.draw_gizmos, function() {
            Settings.mesh.draw_gizmos = self.value;
        }))
            .SetTooltip("Whether or not to draw the tile grid on the Z = 0 plane.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_physical_bounds;
            }),
        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw collision?", Settings.mesh.draw_collision, function() {
            Settings.mesh.draw_collision = self.value;
        }))
            .SetTooltip("Whether or not to show collision shapes associated with meshes.")
            .SetRefresh(function() {
                self.value = Settings.mesh.draw_collision;
            }),
    ]);
    
    if (!IS_MESH_MODE) {
        dialog.AddContent([
            (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw reflections?", Settings.mesh.draw_reflections, function() {
                Settings.mesh.draw_reflections = self.value;
            }))
                .SetTooltip("If you have a reflection mesh set up, you may draw it, as well.")
                .SetRefresh(function() {
                    self.value = Settings.mesh.draw_reflections;
                }),
        ]);
        dialog.height += 96;
    }
    
    dialog.AddContent([
        (new EmuButton(col1x, EMU_AUTO, col_width, 32, "[c_aqua]Reset", function() {
            Settings.mesh.draw_position = MESH_DEF_VIEW_DRAW_POSITION;
            Settings.mesh.draw_rotation = MESH_DEF_VIEW_DRAW_ROTATION;
            Settings.mesh.draw_scale = MESH_DEF_VIEW_DRAW_SCALE;
            Settings.mesh.draw_textures = MESH_DEF_VIEW_DRAW_TEXTURES;
            Settings.mesh.draw_vertex_colors = MESH_DEF_VIEW_DRAW_VERTEX_COLORS;
            Settings.mesh.draw_physical_bounds = MESH_DEF_VIEW_DRAW_PHYSICAL_BOUNDS;
            Settings.mesh.draw_gizmos = MESH_DEF_VIEW_DRAW_GIZMOS;
            Settings.mesh.draw_lighting = MESH_DEF_VIEW_DRAW_LIGHTING; 
            Settings.mesh.draw_back_faces = MESH_DEF_VIEW_DRAW_BACK_FACES;
            Settings.mesh.draw_reflections = MESH_DEF_VIEW_DRAW_REFLECTIONS;
            Settings.mesh.draw_collision = MESH_DEF_VIEW_DRAW_COLLISION;
            Settings.mesh.draw_axes = MESH_DEF_VIEW_DRAW_AXES;
            Settings.mesh.draw_grid = MESH_DEF_VIEW_DRAW_GRID;
            Settings.mesh.wireframe_alpha = MESH_DEF_VIEW_WIREFRAME_ALPHA;
            self.root.Refresh();
        }))
        #endregion
    ]).AddDefaultCloseButton();
}