/// @param Dialog
/// @param value
/// @param onvaluechange

var dialog = argument0;
var value = argument1;
var onvaluechange = argument2;

var dw = 560;
var dh = 480;

var dg = dialog_create(dw, dh, "Other Data Types", dialog_default, dc_close_no_questions_asked, dialog);

var columns = 2;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var c2 = dw / columns;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var n_slots = 14;

var yy = 64;

var offset = DataTypes.AUDIO_BGM;

var el_list = create_radio_array(16, yy, "All Data Types: ", ew, eh, onvaluechange, value, dg);
create_radio_array_options(el_list, [
    "Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color", "Mesh", "Tileset", "Tile", "Autotile",
    "Audio (BGM)", "Audio (SE)", "Animation", "Entity (RefID)", "Map", "Battler sprite", "Overworld sprite",
    "Particle", "UI image", "Misc. image", "Event",
]);

el_list.contents[| DataTypes.AUDIO_BGM].color = c_green;
el_list.contents[| DataTypes.AUDIO_SE].color = c_green;
el_list.contents[| DataTypes.IMG_BATTLER].color = c_purple;
el_list.contents[| DataTypes.IMG_ETC].color = c_purple;
el_list.contents[| DataTypes.IMG_OVERWORLD].color = c_purple;
el_list.contents[| DataTypes.IMG_PARTICLE].color = c_purple;
el_list.contents[| DataTypes.IMG_TILESET].color = c_purple;
el_list.contents[| DataTypes.IMG_UI].color = c_purple;
el_list.contents[| DataTypes.MESH].color = c_blue;
el_list.contents[| DataTypes.TILE].color = c_blue;
el_list.contents[| DataTypes.AUTOTILE].color = c_blue;
el_list.contents[| DataTypes.MAP].color = c_blue;
el_list.contents[| DataTypes.ENTITY].color = c_blue;
el_list.contents[| DataTypes.ANIMATION].color = c_blue;

create_radio_array_option_column(el_list, DataTypes.AUDIO_BGM, c2 + 32);

dg.el_list = el_list;

var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_close_no_questions_asked, dg, fa_center);

ds_list_add(dg.contents,
    el_list,
    el_confirm
);

return dg;