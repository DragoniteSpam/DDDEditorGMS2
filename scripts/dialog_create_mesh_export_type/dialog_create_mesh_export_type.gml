/// @param root
/// @param selected-indices

var root = argument0;
var selection = argument1;

var dw = 400;
var dh = 280;
var b_width = 128;
var b_height = 32;

var dg = dialog_create(dw, dh, "Hey!", dialog_default, dmu_dialog_cancel, root);
dg.selection = selection;

var el_type = create_radio_array(32, 64, "Model type to save:", dw - 64, 32, null, 0, dg);
create_radio_array_options(el_type, ["GameMaker model (d3d)", "OBJ model file (obj)", "Vertex buffer (vbuff)"]);
el_type.tooltip = @"You may convert to several different types of 3D model files.
- [c_blue]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
- [c_blue]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
- [c_blue]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing.
If you loaded a model containing SMF data, it will be saved as is without conversion.";
dg.el_type = el_type;

var el_cancel = create_button(dw / 3 - b_width / 2, dh - 32 - b_height / 2, "Cancel", b_width, b_height, fa_center, dmu_dialog_cancel, dg);
var el_confirm = create_button(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, "Save", b_width, b_height, fa_center, omu_mesh_export_save, dg);

ds_list_add(dg.contents, el_type, el_cancel, el_confirm);

return dg;