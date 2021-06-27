function dialog_map_data_enable_by_type(dialog) {
    var map = Stuff.map.active_map;
    var selection = ui_list_selection(dialog.el_list);
    var data = map.generic_data[selection];
    
    dialog.el_name.interactive = true;
    ui_input_set_value(dialog.el_name, data.name);
    
    dialog.el_data_type.interactive = true;
    dialog.el_data_type.value = data.type;
    dialog.el_data_ext_type.interactive = true;
    
    switch (data.type) {
        case DataTypes.CODE:
            dialog.el_data_property_code.interactive = true;
            dialog.el_data_property_code.enabled = true;
            dialog.el_data_property_code.value = string(data.value);
            break;
        case DataTypes.STRING:
            dialog.el_data_property_string.interactive = true;
            dialog.el_data_property_string.enabled = true;
            dialog.el_data_property_string.value = string(data.value);
            break;
        case DataTypes.FLOAT:
            dialog.el_data_property_real.interactive = true;
            dialog.el_data_property_real.enabled = true;
            dialog.el_data_property_real.value = string(data.value);
            break;
        case DataTypes.INT:
            dialog.el_data_property_int.interactive = true;
            dialog.el_data_property_int.enabled = true;
            dialog.el_data_property_int.value = string(data.value);
            break;
        case DataTypes.BOOL:
            dialog.el_data_property_bool.interactive = true;
            dialog.el_data_property_bool.enabled = true;
            try {
                dialog.el_data_property_bool.value = real(data.value);
            } catch (e) {
                dialog.el_data_property_bool.value = false;
            }
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
            dialog.el_data_type_guid.interactive = true;
            dialog.el_data_type_guid.enabled = true;
            dialog.el_data_list.interactive = true;
            dialog.el_data_list.enabled = true;
            
            var type = guid_get(data.value_type_guid);
            
            if (type) {
                dialog.el_data_type_guid.text = type.name + " (Select)";
                dialog.el_data_type_guid.color = (data.type == type.type) ? c_black : c_red;
                if (type.type == data.type) {
                    dialog.el_data_list.entries = (data.type == DataTypes.ENUM) ? type.properties : type.instances;
                } else {
                    dialog.el_data_list.entries = [];
                }
            } else {
                dialog.el_data_type_guid.text = "Select";
                dialog.el_data_type_guid.color = c_black;
            }
            
            if (data.type == DataTypes.ENUM) {
                dialog.el_data_type_guid.onmouseup = omu_map_data_enum_select;
            } else  {
                dialog.el_data_type_guid.onmouseup = omu_map_data_data_select;
            }
            break;
        case DataTypes.COLOR:
            dialog.el_data_property_color.interactive = true;
            dialog.el_data_property_color.enabled = true;
            try {
                dialog.el_data_property_bool.value = real(data.value);
            } catch (e) {
                dialog.el_data_property_bool.value = c_black;
            }
            break;
        case DataTypes.MESH:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.meshes;
            var data_index = array_search(Game.meshes, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_TEXTURE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.tilesets;
            var data_index = array_search(Game.graphics.tilesets, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_TILE_ANIMATION:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.tile_animations;
            var data_index = array_search(Game.graphics.tile_animations, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.TILE:
            not_yet_implemented();
            break;
        case DataTypes.AUDIO_BGM:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.audio.bgm;
            var data_index = array_search(Game.audio.bgm, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.AUDIO_SE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.audio.se;
            var data_index = array_search(Game.audio.se, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.ANIMATION:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.animations;
            var data_index = array_search(Game.animations, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.ENTITY:
            dialog.el_data_property_entity.interactive = true;
            dialog.el_data_property_entity.enabled = true;
            var ref_index = array_search(map.contents.all_entities, refid_get(data.value));
            ui_list_deselect(dialog.el_data_property_entity);
            ui_list_select(dialog.el_data_property_entity, ref_index, true);
            break;
        case DataTypes.MAP:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.maps;
            var data_index = array_search(Game.maps, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_BATTLER:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.battlers;
            var data_index = array_search(Game.graphics.battlers, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_OVERWORLD:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.overworlds;
            var data_index = array_search(Game.graphics.overworlds, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_PARTICLE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.particles;
            var data_index = array_search(Game.graphics.particles, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_UI:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.ui;
            var data_index = array_search(Game.graphics.ui, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.IMG_ETC:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.etc;
            var data_index = array_search(Game.graphics.etc, guid_get(data.value));
            ui_list_deselect(dialog.el_data_builtin_list);
            ui_list_select(dialog.el_data_builtin_list, data_index, true);
            break;
        case DataTypes.EVENT:
            not_yet_implemented();
            break;
    }

    // this is occasionally not needed because it'll run both of these every time,
    // but it's way cleaner than trying to only do it when necessary
    if (dialog.el_data_builtin_list.entries != undefined) {
        for (var i = 0; i < array_length(dialog.el_data_builtin_list.entries); i++) {
            var entry = dialog.el_data_builtin_list.entries[i];
            if (data.value == entry.GUID) {
                ui_list_select(dialog.el_data_builtin_list, i, true);
                break;
            }
        }
    }
    
    if (dialog.el_data_list.entries != undefined) {
        for (var i = 0; i < array_length(dialog.el_data_list.entries); i++) {
            var entry = dialog.el_data_list.entries[i];
            if (data.value == entry.GUID) {
                ui_list_select(dialog.el_data_list, i, true);
                break;
            }
        }
    }
}