/// @param UIButton

var button = argument0;
var mode = Stuff.mesh_ed;

ds_list_add(mode.format_names, "Format" + string(ds_list_size(mode.format_names)));
var format = ds_list_create();
ds_list_add(format,
    VertexFormatData.POSITION_3D,
    VertexFormatData.NORMAL,
    VertexFormatData.TEXCOORD,
    VertexFormatData.COLOUR,
);
ds_list_add(mode.formats, format);
ds_list_mark_as_list(mode.formats, 0);