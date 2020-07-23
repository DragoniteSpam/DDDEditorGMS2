event_inherited();

update = null;
render = editor_render_mesh;
save = editor_save_setting_mesh;

draw_meshes = true;
draw_wireframes = true;
draw_textures = false;
draw_lighting = false;
draw_scale = 1;
draw_rot_x = 0;
draw_rot_y = 0;
draw_rot_z = 0;

x = setting_get("Mesh", "x", 256);
y = setting_get("Mesh", "y", 256);
z = setting_get("Mesh", "z", 128);

xto = setting_get("Mesh", "xto", 0);
yto = setting_get("Mesh", "yto", 0);
zto = setting_get("Mesh", "zto", 0);

// don't put the up vector in the settings file
xup = 0;
yup = 0;
zup = 1;

fov = setting_get("Mesh", "fov", 60);
pitch = setting_get("Mesh", "pitch", arctan2(z, point_distance(0, 0, x, y)));
direction = setting_get("Mesh", "direction", point_direction(x, y, 0, 0));

export_type = MeshExportTypes.D3D;

var fbuffer = buffer_load("data\\vertex-formats.json");
format_json = json_decode(buffer_read(fbuffer, buffer_text));
buffer_delete(fbuffer);

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