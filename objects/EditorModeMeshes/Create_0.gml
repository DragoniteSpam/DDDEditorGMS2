event_inherited();

update = null;

render = function() {
    gpu_set_cullmode(cull_noculling);
    draw_editor_menu();
    draw_editor_fullscreen();
};

ui = ui_init_mesh(id);

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

save = function() {
    Settings.mesh.camera = self.camera.Save();
};

ResetTransform = function() {
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

ResetCamera = function() {
    self.camera.Reset();
};

vertex_format = (1 << VertexFormatData.POSITION_3D) |
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