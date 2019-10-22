/// @param base-dialog
/// @param DataConstant

var base_dialog = argument[0];
var what = argument[1];

base_dialog.el_value_code.enabled = false;
base_dialog.el_value_string.enabled = false;
base_dialog.el_value_real.enabled = false;
base_dialog.el_value_int.enabled = false;
base_dialog.el_value_bool.enabled = false;
base_dialog.el_type_guid.enabled = false;

switch (what.type) {
    case DataTypes.INT: base_dialog.el_value_int.enabled = true; break;
    case DataTypes.FLOAT: base_dialog.el_value_real.enabled = true; break;
    case DataTypes.STRING: base_dialog.el_value_string.enabled = true; break;
    case DataTypes.BOOL: base_dialog.el_value_bool.enabled = true; break;
    case DataTypes.CODE: base_dialog.el_value_code.enabled = true; break;
    case DataTypes.ENUM:
    case DataTypes.DATA:
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
            ui_list_select(list, ds_list_find_index(list.entries, type));
        }
        break;
    case DataTypes.COLOR:
    case DataTypes.MESH:
    case DataTypes.IMG_TILESET:
    case DataTypes.TILE:
    case DataTypes.AUTOTILE:
    case DataTypes.AUDIO_BGM:
    case DataTypes.AUDIO_SE:
    case DataTypes.ANIMATION:
    case DataTypes.ENTITY:
    case DataTypes.MAP:
    case DataTypes.IMG_BATTLER:
    case DataTypes.IMG_OVERWORLD:
    case DataTypes.IMG_PARTICLE:
    case DataTypes.IMG_UI:
    case DataTypes.IMG_ETC:
}