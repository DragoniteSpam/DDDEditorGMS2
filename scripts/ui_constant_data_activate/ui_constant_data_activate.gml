/// @param base-dialog
/// @param DataConstant

var base_dialog = argument[0];
var what = argument[1];

base_dialog.el_value_code.enabled = false;
base_dialog.el_value_string.enabled = false;
base_dialog.el_value_real.enabled = false;
base_dialog.el_value_int.enabled = false;
base_dialog.el_value_bool.enabled = false;
base_dialog.el_value_color.enabled = false;
base_dialog.el_value_other.enabled = false;

base_dialog.el_type_guid.enabled = false;
base_dialog.el_value_data.enabled = false;

switch (what.type) {
    case DataTypes.INT:
        base_dialog.el_value_int.enabled = true;
        what.value = 0;
        break;
    case DataTypes.FLOAT:
        base_dialog.el_value_real.enabled = true;
        what.value = 0;
        break;
    case DataTypes.STRING:
        base_dialog.el_value_string.enabled = true;
        what.value = "";
        break;
    case DataTypes.BOOL:
        base_dialog.el_value_bool.enabled = true;
        what.value = false;
        break;
    case DataTypes.CODE:
        base_dialog.el_value_code.enabled = true;
        what.value = "";
        break;
    case DataTypes.ENUM:
    case DataTypes.DATA:
        base_dialog.el_value_data.enabled = true;
        var list = base_dialog.el_type_guid;
        var type = guid_get(what.type_guid);
        list.enabled = true;
        ui_list_clear(list);
        
        for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
            var datadata = Stuff.all_data[| i];
            if (what.type == datadata.type) {
                ds_list_add(list.entries, datadata);
            }
        }
        
        if (type) {
            var index = ds_list_find_index(list.entries, type);
            ui_list_select(list, index, true);
        }
        what.value = 0;
        break;
    case DataTypes.MESH:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_meshes;
        what.value = 0;
        break;
    case DataTypes.IMG_TILESET:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_tilesets;
        what.value = 0;
        break;
        break;
    case DataTypes.TILE:
        not_yet_implemented();
        break;
    case DataTypes.AUTOTILE:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_autotiles;
        what.value = 0;
        break;
    case DataTypes.AUDIO_BGM:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_bgm;
        what.value = 0;
        break;
    case DataTypes.AUDIO_SE:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_se;
        what.value = 0;
        break;
    case DataTypes.ANIMATION:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_animations;
        what.value = 0;
        break;
    case DataTypes.MAP:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_maps;
        what.value = 0;
        break;
    case DataTypes.IMG_BATTLER:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_battlers;
        what.value = 0;
        break;
    case DataTypes.IMG_OVERWORLD:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_overworlds;
        what.value = 0;
        break;
    case DataTypes.IMG_PARTICLE:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_particles;
        what.value = 0;
        break;
    case DataTypes.IMG_UI:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_ui;
        what.value = 0;
        break;
    case DataTypes.IMG_ETC:
        var list = base_dialog.el_value_other;
        ui_list_deselect(list);
        list.enabled = true;
        list.index = 0;
        list.entries = Stuff.all_graphic_etc;
        what.value = 0;
        break;
    case DataTypes.COLOR:
        base_dialog.el_value_color.enabled = true;
        what.value = c_black;
        break;
    case DataTypes.ENTITY:
        show_error("How did you get here?", false);
        break;
}