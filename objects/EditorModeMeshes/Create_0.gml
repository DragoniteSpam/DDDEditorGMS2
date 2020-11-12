event_inherited();

update = null;
render = editor_render_mesh;
save = function() {
    setting_set("Mesh", "x", x);
    setting_set("Mesh", "y", y);
    setting_set("Mesh", "z", z);
    setting_set("Mesh", "xto", xto);
    setting_set("Mesh", "yto", yto);
    setting_set("Mesh", "zto", zto);
    setting_set("Mesh", "fov", fov);
    
    setting_set("Mesh", "vertex-formats", json_encode(format_json));
    
    setting_set("Mesh", "draw-mesh", draw_meshes);
    setting_set("Mesh", "draw-wire", draw_wireframes);
    setting_set("Mesh", "draw-tex", draw_textures);
    setting_set("Mesh", "draw-light", draw_lighting);
    setting_set("Mesh", "draw-axes", draw_axes);
};

draw_meshes = setting_get("Mesh", "draw-mesh", true);
draw_wireframes = setting_get("Mesh", "draw-wire", true);
draw_textures = setting_get("Mesh", "draw-tex", true);
draw_lighting = setting_get("Mesh", "draw-light", false);
draw_scale = 1;
draw_rot_x = 0;
draw_rot_y = 0;
draw_rot_z = 0;

draw_axes = setting_get("Mesh", "draw-axes", true);
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
pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

var fbuffer = buffer_load("data\\vertex-formats.json");
format_default = json_decode(buffer_read(fbuffer, buffer_text));
buffer_delete(fbuffer);

var json_string = setting_get("Mesh", "vertex-formats", "");
if (json_string == "") {
    format_json = format_default;
} else {
    format_json = json_decode(json_string);
}

// if you screw this up, that's on you
format_default = format_default[? "formats"];
format_default = format_default[| 0];
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