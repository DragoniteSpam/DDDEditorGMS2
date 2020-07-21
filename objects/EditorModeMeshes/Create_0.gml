event_inherited();

update = null;
render = editor_render_mesh;
save = null;

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