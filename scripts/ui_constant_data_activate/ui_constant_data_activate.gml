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

base_dialog.el_event_entrypoint.enabled = false;
base_dialog.el_event.enabled = false;

switch (what.type) {
    case DataTypes.INT:
        what.value_real = floor(what.value_real);
        base_dialog.el_value_int.enabled = true;
        base_dialog.el_value_int.value = string(what.value_real);
        break;
    case DataTypes.FLOAT:
        // no need to cast, since anything in here will already be a valid float
        base_dialog.el_value_real.enabled = true;
        base_dialog.el_value_real.value = string(what.value_real);
        break;
    case DataTypes.STRING:
        base_dialog.el_value_string.enabled = true;
        base_dialog.el_value_string.value = what.value_string;
        break;
    case DataTypes.BOOL:
        what.value_real = clamp(floor(what.value_real), 0, 1);
        base_dialog.el_value_bool.enabled = true;
        base_dialog.el_value_bool.value = what.value_real;
        break;
    case DataTypes.CODE:
        base_dialog.el_value_code.enabled = true;
        base_dialog.el_value_code.value = what.value_string;
        break;
    case DataTypes.ENUM:
    case DataTypes.DATA:
        var list_data = base_dialog.el_value_data;
        var list = base_dialog.el_type_guid;
        var type = guid_get(what.type_guid);
        list_data.enabled = true;
        list.enabled = true;
        ui_list_clear(list);
        ui_list_deselect(list_data);
        
        if (type && (what.type != type.type)) {
            what.value_guid = NULL;
            what.type_guid = NULL;
            type = noone;
        }
        
        for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
            var datadata = Stuff.all_data[| i];
            if (what.type == datadata.type) {
                ds_list_add(list.entries, datadata);
            }
        }
        
        if (type) {
            // select the type in the type list, if there is one
            var index = ds_list_find_index(list.entries, type);
            ui_list_select(list, index, true);
            // set the data in the data list
            list_data.entries = (what.type == DataTypes.DATA) ? type.instances : type.properties;
            
            var data = guid_get(what.value_guid);
            
            if (data) {
                ui_list_select(list_data, ds_list_find_index(list_data.entries, data), true);
            }
        } else {
            list_data.entries = noone;
        }
        
        list_data.index = 0;
        break;
    case DataTypes.MESH:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_meshes;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.IMG_TILESET:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_tilesets;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.TILE:
        not_yet_implemented_polite();
        break;
    case DataTypes.IMG_TILE_ANIMATION:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_tile_animations;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.AUDIO_BGM:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_bgm;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.AUDIO_SE:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_se;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.ANIMATION:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_animations;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.MAP:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_maps;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.IMG_BATTLER:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_battlers;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.IMG_OVERWORLD:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_overworlds;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.IMG_PARTICLE:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_particles;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.IMG_UI:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_ui;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.IMG_ETC:
        var list = base_dialog.el_value_other;
        list.entries = Stuff.all_graphic_etc;
        ui_list_deselect(list);
        ui_list_select(list, ds_list_find_index(list.entries, guid_get(what.value_guid)), true);
        list.enabled = true;
        list.index = 0;
        break;
    case DataTypes.COLOR:
        what.value_real = c_black;
        base_dialog.el_value_color.enabled = true;
        base_dialog.el_value_color.value = c_black;
        break;
    case DataTypes.EVENT:
        base_dialog.el_event.enabled = true;
        base_dialog.el_event_entrypoint.enabled = true;
        var entrypoint = guid_get(what.value_guid);
        var event = entrypoint ? entrypoint.event : noone;
        base_dialog.el_event.text = "Event: " + (event ? event.name : "");
        base_dialog.el_event_entrypoint.text = "Entrypoint: " + (entrypoint ? entrypoint.name : "");
        break;
    case DataTypes.ENTITY:
        show_error("How did you get here?", false);
        break;
}