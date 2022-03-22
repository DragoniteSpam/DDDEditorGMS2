event_inherited();

update = null;
render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_ribbon: draw_editor_menu(); break;
        case view_fullscreen: draw_editor_fullscreen(); break;
    }
};
save = function() {
    Settings.mesh.x = x;
    Settings.mesh.y = y;
    Settings.mesh.z = z;
    Settings.mesh.xto = xto;
    Settings.mesh.yto = yto;
    Settings.mesh.zto = zto;
    Settings.mesh.fov = fov;
    
    Settings.mesh.draw_mesh = draw_meshes;
    Settings.mesh.draw_wire = draw_wireframes;
    Settings.mesh.draw_tex = draw_textures;
    Settings.mesh.draw_light = draw_lighting;
    Settings.mesh.draw_axes = draw_axes;
    Settings.mesh.draw_grid = draw_grid;
    Settings.mesh.draw_back_faces = draw_back_faces;
    Settings.mesh.draw_reflections = draw_reflections;
    Settings.mesh.draw_collision = draw_collision;
};

draw_meshes = setting_get("mesh", "draw_mesh", true);
draw_wireframes = setting_get("mesh", "draw_wire", true);
draw_textures = setting_get("mesh", "draw_tex", true);
draw_lighting = setting_get("mesh", "draw_light", false);
draw_back_faces = setting_get("mesh", "backfaces", false);
draw_reflections = setting_get("mesh", "reflections", false);
draw_collision = setting_get("mesh", "draw_collision", false);
draw_position = { x: 0, y: 0, z: 0 };
draw_rotation = { x: 0, y: 0, z: 0 };
draw_scale = { x: 1, y: 1, z: 1 };

ResetTransform = function() {
    self.draw_position = { x: 0, y: 0, z: 0 };
    self.draw_rotation = { x: 0, y: 0, z: 0 };
    self.draw_scale = { x: 1, y: 1, z: 1 };
};

draw_axes = setting_get("mesh", "draw_axes", true);
draw_light_direction = 180;
draw_grid = setting_get("mesh", "draw_grid", true);

def_x = 256;
def_y = 256;
def_z = 128;
def_xto = 0;
def_yto = 0;
def_zto = 0;
def_xup = 0;
def_yup = 0;
def_zup = 1;
def_fov = 60;

ResetCamera = function() {
    self.x = self.def_x;
    self.y = self.def_y;
    self.z = self.def_z;
    self.xto = self.def_xto;
    self.yto = self.def_yto;
    self.zto = self.def_zto;
    self.xup = self.def_xup;
    self.yup = self.def_yup;
    self.zup = self.def_zup;
    self.fov = self.def_fov;
    self.pitch = darctan2(self.z - self.zto, point_distance(self.x, self.y, self.xto, self.yto));
    self.direction = point_direction(self.x, self.y, self.xto, self.yto);
};

x = setting_get("mesh", "x", def_x);
y = setting_get("mesh", "y", def_y);
z = setting_get("mesh", "z", def_z);

xto = setting_get("mesh", "xto", def_xto);
yto = setting_get("mesh", "yto", def_yto);
zto = setting_get("mesh", "zto", def_zto);

// don't put the up vector in the settings file
xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("mesh", "fov", def_fov);
pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

vertex_format = (1 << VertexFormatData.POSITION_3D) |
    (1 << VertexFormatData.NORMAL) |
    (1 << VertexFormatData.TEXCOORD) |
    (1 << VertexFormatData.COLOUR);

ui = ui_init_mesh(id);

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