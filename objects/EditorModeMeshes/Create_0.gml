event_inherited();

update = null;
render = editor_render_mesh;
save = editor_save_setting_mesh;

draw_meshes = setting_get("Mesh", "draw-mesh", true);
draw_wireframes = setting_get("Mesh", "draw-wire", true);
draw_textures = setting_get("Mesh", "draw-tex", true);
draw_lighting = setting_get("Mesh", "draw-light", false);
draw_scale = 1;
draw_rot_x = 0;
draw_rot_y = 0;
draw_rot_z = 0;

draw_light_direction = 180;

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

x = setting_get("Mesh", "x", def_x);
y = setting_get("Mesh", "y", def_y);
z = setting_get("Mesh", "z", def_z);

xto = setting_get("Mesh", "xto", def_xto);
yto = setting_get("Mesh", "yto", def_yto);
zto = setting_get("Mesh", "zto", def_zto);

// don't put the up vector in the settings file
xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("Mesh", "fov", def_fov);
pitch = arctan2(z, point_distance(0, 0, x, y));
direction = point_direction(x, y, 0, 0);

export_type = setting_get("Mesh", "export-type", MeshExportTypes.D3D);
format_json = json_decode(setting_get("Mesh", "vertex-formats", ""));

if (!ds_exists(format_json, ds_type_map)) {
    var fbuffer = buffer_load("data\\vertex-formats.json");
    format_json = json_decode(buffer_read(fbuffer, buffer_text));
    buffer_delete(fbuffer);
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
}

enum MeshExportTypes {
    D3D, OBJ, VB
}