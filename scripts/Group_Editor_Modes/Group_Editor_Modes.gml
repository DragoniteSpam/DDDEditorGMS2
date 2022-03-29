function EditorModeMesh() : EditorModeBase() constructor {
    self.Update = null;
    
    self.Render = function() {
        gpu_set_cullmode(cull_noculling);
        draw_editor_menu();
        draw_editor_fullscreen();
        draw_editor_menu();
    };
    
    self.ui = ui_init_mesh(self);
    
    var threed_surface = self.ui.SearchID("3D VIEW");
    self.camera = new Camera(0, 0, 100, 100, 100, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, emu_null);
    self.camera.SetCenter(threed_surface.x + threed_surface.width / 2, threed_surface.y + threed_surface.height / 2);
    self.camera.base_speed = 20;
    self.camera.Load(setting_get("mesh", "camera", undefined));
    self.camera.SetViewportAspect(function() {
        return Stuff.mesh_ed.ui.SearchID("3D VIEW").width;
    }, function() {
        return Stuff.mesh_ed.ui.SearchID("3D VIEW").height;
    });
    
    self.Save = function() {
        Settings.mesh.camera = self.camera.Save();
    };
    
    self.ResetTransform = function() {
        Settings.mesh.draw_position = new Vector3(0, 0, 0);
        Settings.mesh.draw_rotation = new Vector3(0, 0, 0);
        Settings.mesh.draw_scale = new Vector3(1, 1, 1);
        self.ui.SearchID("MESH POSITION X").Refresh();
        self.ui.SearchID("MESH POSITION Y").Refresh();
        self.ui.SearchID("MESH POSITION Z").Refresh();
        self.ui.SearchID("MESH ROTATE X").Refresh();
        self.ui.SearchID("MESH ROTATE Y").Refresh();
        self.ui.SearchID("MESH ROTATE Z").Refresh();
        self.ui.SearchID("MESH SCALE X").Refresh();
        self.ui.SearchID("MESH SCALE Y").Refresh();
        self.ui.SearchID("MESH SCALE Z").Refresh();
    };
    
    self.ResetCamera = function() {
        self.camera.Reset();
    };
    
    self.vertex_format = (1 << VertexFormatData.POSITION_3D) |
        (1 << VertexFormatData.NORMAL) |
        (1 << VertexFormatData.TEXCOORD) |
        (1 << VertexFormatData.COLOUR);
    
    enum VertexFormatData {
        POSITION_2D,
        POSITION_3D,
        NORMAL,
        TEXCOORD,
        COLOUR,
        TANGENT,
        BITANGENT,
        BARYCENTRIC,
        // special things
        SMALL_NORMAL,                                                               // 4 bytes (nx ny nz 0)
        SMALL_TANGENT,                                                              // 4 bytes (tx ty tz 0)
        SMALL_BITANGENT,                                                            // 4 bytes (bx by bz 0)
        SMALL_TEXCOORD,                                                             // 4 bytes (u v 0 0)
        SMALL_NORMAL_PLUS_PALETTE,                                                  // 4 bytes (nx ny nz and a byte representing a 256 color palette index)
        SMALL_BARYCENTIRC,                                                          // 4 bytes (x y z 0)
        __COUNT,
    }
}

function EditorModeText() : EditorModeBase() constructor {
    self.Update = function() { };
    
    self.Render = function() {
        gpu_set_cullmode(cull_noculling);
        draw_editor_fullscreen();
        draw_editor_menu(false);
    };
    
    self.Save = function() { };
    
    self.ui = ui_init_text();
    
    self.mode_id = ModeIDs.TEXT;
}

function EditorModeAnimation() : EditorModeBase() constructor {
    self.ui = ui_init_animation(self);
    
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
    
    self.Update = function() {
        if (!Stuff.mouse_3d_lock && !dialog_exists()) {
            self.camera.Update();
        }
    };
    
    self.Render = function() {
        gpu_set_cullmode(cull_noculling);
        draw_editor_animation();
        draw_animator();
        draw_animator_overlay();
        draw_editor_menu();
    };
    
    self.Save = function() {
        Settings.animation.camera = self.camera.Save();
    };
    
    self.mode_id = ModeIDs.ANIMATION;
}

function EditorModeSpart() : EditorModeBase() constructor {
    self.ui = ui_init_spart();
    
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
    self.camera.SetSprite(Stuff.graphics.skybox_base, Stuff.graphics.skybox_base);
    
    self.Render = function() {
        draw_editor_spart();
        draw_editor_menu(true);
        draw_editor_hud();
    };
    
    self.Save = function() {
        Settings.spart.camera = self.camera.Save();
    };

    self.mode_id = ModeIDs.SPART;
}

function EditorModeData() : EditorModeBase() constructor {
    self.Render = function() {
        gpu_set_cullmode(cull_noculling);
        draw_editor_fullscreen();
        draw_editor_menu();
    };

    self.Save = function() {
        
    };

    self.ui = undefined;
    self.mode_id = ModeIDs.DATA;
}

function EditorModeEvent() : EditorModeBase() constructor {
    self.ui = ui_init_event(self);
    self.mode_id = ModeIDs.EVENT;
    
    self.def_x = 0;
    self.def_y = 100;
    
    Settings.event[$ "x"] ??= self.def_x;
    Settings.event[$ "y"] ??= self.def_y;
    
    self.x = Settings.event.x;
    self.y = Settings.event.y;
    
    self.Render = function() {
        gpu_set_cullmode(cull_noculling);
        draw_editor_event();
        draw_editor_menu();
        draw_editor_hud();
    };
    
    self.Save = function() {
        Settings.event.x = self.x;
        Settings.event.y = self.y;
    };
    
    self.canvas_active_node = noone;
    self.canvas_active_node_index = 0;
    self.request_cancel_active_node = false;
    
    self.active = undefined;
    self.node_info = undefined;
}

function EditorModeBase() constructor {
    self.Update = function() { };
    self.Render = function() { };
    self.Cleanup = function() { };
    self.Save = function() { };
    
    self.ui = undefined;
    self.mode_id = ModeIDs.MAP;
    
    ds_list_add(Stuff.all_modes, self);
}


