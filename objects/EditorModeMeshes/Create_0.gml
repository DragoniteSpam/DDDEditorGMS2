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
    
    Settings.mesh.vertex_formats = json_encode(format_json);
    
    Settings.mesh.draw_mesh = draw_meshes;
    Settings.mesh.draw_wire = draw_wireframes;
    Settings.mesh.draw_tex = draw_textures;
    Settings.mesh.draw_light = draw_lighting;
    Settings.mesh.draw_axes = draw_axes;
    Settings.mesh.draw_grid = draw_grid;
    Settings.mesh.draw_back_faces = draw_back_faces;
    Settings.mesh.draw_reflections = draw_reflections;
    Settings.mesh.reflect_settings = reflect_settings;
    Settings.mesh.reflect_color = reflect_color;
};

draw_meshes = setting_get("mesh", "draw_mesh", true);
draw_wireframes = setting_get("mesh", "draw_wire", true);
draw_textures = setting_get("mesh", "draw_tex", true);
draw_lighting = setting_get("mesh", "draw_light", false);
draw_back_faces = setting_get("mesh", "backfaces", false);
draw_reflections = setting_get("mesh", "reflections", false);
draw_scale = 1;
draw_rot_x = 0;
draw_rot_y = 0;
draw_rot_z = 0;

draw_axes = setting_get("mesh", "draw_axes", true);
draw_light_direction = 180;
draw_grid = setting_get("mesh", "draw_grid", true);

reflect_settings = setting_get("mesh", "reflect_settings", MeshReflectionSettings.MIRROR_Y | MeshReflectionSettings.MIRROR_Z | MeshReflectionSettings.REVERSE | MeshReflectionSettings.COLORIZE);
reflect_color = setting_get("mesh", "reflect_color", 0x7fff6600);

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

// please don't keep trying to turn this into structs;
// the format and format names list need to be in a ds_list
// and accommodating for those would be a bit of work
var fbuffer = buffer_load("data/vertex-formats.json");
format_default = json_decode(buffer_read(fbuffer, buffer_text));
buffer_delete(fbuffer);

var json_string = setting_get("mesh", "vertex-formats", "");
if (json_string == "") {
    format_json = format_default;
} else {
    format_json = json_decode(json_string);
}

// if you screw this up, that's on you
formats = format_json[? "formats"];
format_names = format_json[? "names"];

ui = ui_init_mesh(id);

enum VertexFormatData {
    POSITION_2D,
    POSITION_3D,
    NORMAL,
    TEXCOORD,
    COLOUR,
    TANGENT,
    BITANGENT,
    // special things
    SMALL_NORMAL,                                                               // 4 bytes
    SMALL_TANGENT,                                                              // 4 bytes
    SMALL_BITANGENT,                                                            // 4 bytes
    SMALL_TEXCOORD,                                                             // 4 bytes
    SMALL_NORMAL_PLUS_TEXCOORD,                                                 // 4 bytes
}