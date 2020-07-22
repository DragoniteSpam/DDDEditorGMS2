event_inherited();

update = null;
render = editor_render_mesh;
save = null;

draw_meshes = true;
draw_wireframes = true;
draw_textures = false;
draw_lighting = false;
draw_scale = 1;
draw_rot_x = 0;
draw_rot_y = 0;
draw_rot_z = 0;

x = setting_get("Mesh", "x", 0);
y = setting_get("Mesh", "y", 0);
z = setting_get("Mesh", "z", 100);

xto = setting_get("Mesh", "xto", 512);
yto = setting_get("Mesh", "yto", 512);
zto = setting_get("Mesh", "zto", 0);

// don't put the up vector in the settings file
xup = 0;
yup = 0;
zup = 1;

fov = setting_get("Mesh", "fov", 60);
pitch = setting_get("Mesh", "pitch", 0);
direction = setting_get("Mesh", "direction", 0);

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