function EditorModeVoxelish() : EditorModeBase() constructor {
    debug_timer_start();
    
    enum EVoxelCellData {
        EMPTY,
        DEFAULT
    }
    
    static voxelish_constructor = function() constructor {
        self.width = 16;
        self.height = 16;
        self.depth = 4;
        
        self.content = self.CreateContent();
        
        static Resize = function(w, h, d) {
            self.width = w;
            self.height = h;
            self.depth = d;
            
            array_foreach(self.content, function(i) {
                array_foreach(i, function(j) {
                    array_resize(j, self.depth);
                });
            });
        };
        
        static CreateContent = function() {
            return array_create_ext(self.width, function(i) {
                return array_create_ext(self.height, function(j) {
                    return array_create(self.depth, EVoxelCellData.EMPTY);
                });
            });
        };
        
        static Set = function(x, y, z, value) {
            self.content[x][y][z] = value;
        };
        
        static Get = function(x, y, z) {
            return self.content[x][y][z];
        };
    };
    
    self.model = new self.voxelish_constructor();
    
    Stuff.voxelish = self;
    self.ui = ui_init_voxelish(self);
    
    self.camera = new Camera(0, 0, 64, 64, 64, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
        Stuff.voxelish.mouse_interaction(mouse_vector);
    });
    self.camera.base_speed = 20;
    self.camera.Load(setting_get("voxelish", "camera", undefined));
    self.camera.SetViewportAspect(function() {
        return Stuff.voxelish.ui.SearchID("VOXELISH VIEWPORT").width;
    }, function() {
        return Stuff.voxelish.ui.SearchID("VOXELISH VIEWPORT").height;
    });
    self.camera.SetCenter(self.ui.SearchID("VOXELISH VIEWPORT").width / 2, self.ui.SearchID("VOXELISH VIEWPORT").height / 2);
    self.camera.SetSkybox(Stuff.graphics.skybox_base, Stuff.graphics.default_skybox);
    
    self.cursor_position = undefined;
    
    self.mouse_interaction = function(mouse_vector) {
        self.cursor_position = undefined;
        
        if (mouse_vector.direction.z < mouse_vector.origin.z) {
            var f = abs(mouse_vector.origin.z / mouse_vector.direction.z);
            self.cursor_position = new Vector2(mouse_vector.origin.x + mouse_vector.direction.x * f, mouse_vector.origin.y + mouse_vector.direction.y * f);
            
            if (EmuOverlay.GetTop()) return false;
            
            if (Controller.mouse_left) {
                self.model.Set(self.cursor_position.x div TILE_WIDTH, self.cursor_position.y div TILE_HEIGHT, 0, EVoxelCellData.DEFAULT);
            }
            /*
            if (Controller.mouse_left) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: self.EditModeZ(self.cursor_position, 1); break;
                    case TerrainModes.TEXTURE: self.EditModeTexture(self.cursor_position); break;
                    case TerrainModes.COLOR: self.EditModeColor(self.cursor_position); break;
                }
            }
            
            if (Controller.mouse_right) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: self.EditModeZ(self.cursor_position, -1); break;
                    case TerrainModes.TEXTURE: self.EditModeTexture(self.cursor_position); break;
                    case TerrainModes.COLOR: self.EditModeColor(self.cursor_position); break;
                }
            }
            
            if (Controller.release_right) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: break;
                    case TerrainModes.TEXTURE: self.texture.Finish(); break;
                    case TerrainModes.COLOR: self.color.Finish(); break;
                }
            }
            
            if (Controller.release_left) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: break;
                    case TerrainModes.TEXTURE: self.texture.Finish(); break;
                    case TerrainModes.COLOR: self.color.Finish(); break;
                }
            }*/
        }
        
        if (keyboard_check_pressed(vk_space)) {
            
        }
        
        if (keyboard_check_pressed(vk_delete)) {
            
        }
    }
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.VOXELISH);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        self.ui.Render(0, 0);
        editor_gui_post();
    };
    
    self.DrawDepth = function() {
    };
    
    self.DrawTerrain = function() {
        self.DrawDepth();
        
        draw_set_color(c_white);
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
        gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
        
        self.camera.SetProjection();
        if (Settings.voxelish.view_skybox) {
            self.camera.DrawSkybox();
        }
        
        if (Settings.voxelish.orthographic) {
            self.camera.SetProjectionOrtho();
        } else {
            self.camera.SetProjection();
        }
        
        if (Settings.terrain.view_axes) {
            Stuff.graphics.DrawAxes();
        }
        
        Stuff.graphics.DrawMapGrid(0, 0, 0 * TILE_DEPTH + 0.5, self.model.width * TILE_WIDTH, self.model.height * TILE_HEIGHT, self.cursor_position);
        
        for (var i = 0; i < self.model.width; i++) {
            for (var j = 0; j < self.model.height; j++) {
                for (var k = 0; k < self.model.depth; k++) {
                    if (self.model.Get(i, j, k) != EVoxelCellData.EMPTY) {
                        matrix_set(matrix_world, matrix_build(i * 32, j * 32, k * 32, 0, 0, 0, 1, 1, 1));
                        vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
                    }
                }
            }
        }
        
        matrix_set(matrix_world, matrix_build_identity());
        
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        gpu_set_cullmode(cull_noculling);
        
        // overlay stuff
        self.camera.SetProjectionGUI();
        
        editor_gui_button(spr_camera_icons, 2, 16, window_get_height() - 48, 0, 0, null, function() {
            self.camera.Reset();
        });
    };
}