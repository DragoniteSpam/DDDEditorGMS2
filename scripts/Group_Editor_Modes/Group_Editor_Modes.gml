function EditorModeMesh() : EditorModeBase() constructor {
    self.Update = null;
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.MESH);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        self.ui.Render();
        editor_gui_post();
    };
    
    self.ui = ui_init_mesh(self);
    
    var threed_surface = self.ui.SearchID("3D VIEW");
    self.camera = new Camera(150, 150, 150, 0, 0, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, emu_null);
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
    
    self.vertex_format = VertexFormatData.POSITION_3D | VertexFormatData.NORMAL | VertexFormatData.TEXCOORD | VertexFormatData.COLOUR;
    
    enum VertexFormatData {
        POSITION_2D                         = 0x0001,
        POSITION_3D                         = 0x0002,
        NORMAL                              = 0x0004,
        TEXCOORD                            = 0x0008,
        COLOUR                              = 0x0010,
        TANGENT                             = 0x0020,
        BITANGENT                           = 0x0040,
        BARYCENTRIC                         = 0x0080,
        // special things
        SMALL_NORMAL                        = 0x0100,       // 4 bytes (nx ny nz 0)
        SMALL_TANGENT                       = 0x0200,       // 4 bytes (tx ty tz 0)
        SMALL_BITANGENT                     = 0x0400,       // 4 bytes (bx by bz 0)
        SMALL_TEXCOORD                      = 0x0080,       // 4 bytes (u v 0 0)
        SMALL_NORMAL_PLUS_PALETTE           = 0x0100,       // 4 bytes (nx ny nz and a byte representing a 256 color palette index)
        SMALL_BARYCENTIRC                   = 0x0200,       // 4 bytes (x y z 0)
        __COUNT,
    }
}

function EditorModeText() : EditorModeBase() constructor {
    self.Update = function() { };
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.TEXT);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        self.ui.Render();
        editor_gui_post();
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
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.ANIMATION);
    };
    
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
        editor_gui_post();
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
    self.camera.SetSkybox(Stuff.graphics.skybox_base, Stuff.graphics.default_skybox);
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.SPART);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        self.ui.Render();
        editor_gui_post();
    };
    
    self.Save = function() {
        Settings.spart.camera = self.camera.Save();
    };
    
    self.DrawSpart = function() {
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
        gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
        
        draw_clear(EMU_COLOR_BACK);
        self.camera.SetProjection();
        
        // draw the grid here
        
        // draw the spart editor here
    };

    self.mode_id = ModeIDs.SPART;
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
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.EVENT);
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        draw_editor_event();
        self.ui.Render();
        editor_gui_post();
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
    self.SetMode = function() {
        show_message("implementation required");
    };
    
    self.ui = undefined;
    self.mode_id = ModeIDs.MAP;
    
    ds_list_add(Stuff.all_modes, self);
}

function editor_set_mode(mode_structure, mode_id) {
    Stuff.mode = mode_structure;
    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = mode_id;
    }
}
