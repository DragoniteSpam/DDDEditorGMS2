function dialog_entity_data_enable_by_type(dialog) {
    var entity = dialog.entity;
    var selection = ui_list_selection(dialog.el_list);
    var data = entity.generic_data[selection];
    
    dialog.el_name.interactive = true;
    ui_input_set_value(dialog.el_name, data.name);
    
    dialog.el_data_type.interactive = true;
    dialog.el_data_type.value = data.type;
    
    dialog.el_data_ext_type.interactive = true;
    
    switch (data.type) {
        case DataTypes.CODE:
            dialog.el_data_property_code.interactive = true;
            dialog.el_data_property_code.enabled = true;
            dialog.el_data_property_code.value = data.value_code;
            break;
        case DataTypes.STRING:
            dialog.el_data_property_string.interactive = true;
            dialog.el_data_property_string.enabled = true;
            dialog.el_data_property_string.value = data.value_string;
            break;
        case DataTypes.FLOAT:
            dialog.el_data_property_real.interactive = true;
            dialog.el_data_property_real.enabled = true;
            dialog.el_data_property_real.value = string(data.value_real);
            break;
        case DataTypes.INT:
            dialog.el_data_property_int.interactive = true;
            dialog.el_data_property_int.enabled = true;
            dialog.el_data_property_int.value = string(data.value_int);
            break;
        case DataTypes.BOOL:
            dialog.el_data_property_bool.interactive = true;
            dialog.el_data_property_bool.enabled = true;
            dialog.el_data_property_bool.value = data.value_bool;
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
            
            dialog.el_data_type_guid.onmouseup = (data.type == DataTypes.ENUM) ? omu_entity_data_enum_select : omu_entity_data_data_select;
            
            break;
        case DataTypes.COLOR:
            dialog.el_data_property_color.interactive = true;
            dialog.el_data_property_color.enabled = true;
            dialog.el_data_property_bool.value = data.value_color;
            break;
        case DataTypes.MESH:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.meshes;
            break;
        case DataTypes.MESH_AUTOTILE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Stuff.all_mesh_autotiles;
            break;
        case DataTypes.IMG_TEXTURE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.tilesets;
            break;
        case DataTypes.IMG_SKYBOX:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.skybox;
            break;
        case DataTypes.IMG_TILE_ANIMATION:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.tile_animations;
            break;
        case DataTypes.TILE:
            not_yet_implemented();
            break;
        case DataTypes.AUDIO_BGM:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.audio.bgm;
            break;
        case DataTypes.AUDIO_SE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.audio.se;
            break;
        case DataTypes.ANIMATION:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Stuff.all_animations;
            break;
        case DataTypes.ENTITY:
            not_yet_implemented();
            break;
        case DataTypes.MAP:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Stuff.all_maps;
            break;
        case DataTypes.IMG_BATTLER:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.battlers;
            break;
        case DataTypes.IMG_OVERWORLD:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.overworlds;
            break;
        case DataTypes.IMG_PARTICLE:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.particles;
            break;
        case DataTypes.IMG_UI:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.ui;
            break;
        case DataTypes.IMG_ETC:
            dialog.el_data_builtin_list.interactive = true;
            dialog.el_data_builtin_list.enabled = true;
            dialog.el_data_builtin_list.entries = Game.graphics.etc;
            break;
        case DataTypes.EVENT:
        case DataTypes.ASSET_FLAG:
            not_yet_implemented();
            break;
    }
    
    // this is occasionally not needed because it'll run both of these every time,
    // but it's way cleaner than trying to only do it when necessary
    if (dialog.el_data_builtin_list.entries) {
        for (var i = 0; i < ds_list_size(dialog.el_data_builtin_list.entries); i++) {
            var entry = dialog.el_data_builtin_list.entries[| i];
            if (data.value_data == entry.GUID) {
                ui_list_select(dialog.el_data_builtin_list, i, true);
                break;
            }
        }
    }
    
    if (dialog.el_data_list.entries) {
        for (var i = 0; i < ds_list_size(dialog.el_data_list.entries); i++) {
            var entry = dialog.el_data_list.entries[| i];
            if (data.value_data == entry.GUID) {
                ui_list_select(dialog.el_data_list, i, true);
                break;
            }
        }
    }
}