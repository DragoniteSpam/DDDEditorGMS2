event_inherited();

update = null;
render = editor_render_mesh;
save = null;

use_textures = false;
draw_scale = 1;

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

ui = ui_init_mesh(id);

formats = ds_list_create();
format_default = ds_list_create();
ds_list_add(format_default,
    VertexFormatData.POSITION_3D,
    VertexFormatData.NORMAL,
    VertexFormatData.TEXCOORD,
    VertexFormatData.COLOUR,
);
ds_list_add(formats, format_default);
ds_list_mark_as_list(formats, 0);

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