function dialog_create_data_instance_property_list(root) {
    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    
    // this is honestly easier than disabling/enabling interface elements when stuff is deselected
    if (!(selection + 1)) {
        return noone;
    }
    
    var dw = 320;
    var dh = 64;
    
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var property = data.properties[root.key];
    var instance = guid_get(data.instances[selection].GUID);
    
    var dg = dialog_create(dw, dh, instance.name + ": " + property.name, dialog_default, dialog_destroy, root);
    dg.property = property;
    
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var vx1 = dw / (columns * 2) - 16;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2) - 16;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    
    var plist = instance.values[root.key];
    var el_list = create_list(16, yy,
        "Values (" + string(array_length(plist)) + " / " + string(property.max_size) + ")",
        "<no values>", ew, eh, 8, uivc_list_data_list_select, false, dg, plist
    );
    el_list.numbered = true;
    el_list.key = root.key;
    
    switch (property.type) {
        case DataTypes.ENUM:
        case DataTypes.DATA:
        case DataTypes.AUDIO_BGM:
        case DataTypes.AUDIO_SE:
        case DataTypes.IMG_TILE_ANIMATION:
        case DataTypes.MESH:
        case DataTypes.MESH_AUTOTILE:
        case DataTypes.IMG_TEXTURE:
        case DataTypes.IMG_BATTLER:
        case DataTypes.IMG_OVERWORLD:
        case DataTypes.IMG_PARTICLE:
        case DataTypes.IMG_UI:
        case DataTypes.IMG_ETC:
        case DataTypes.IMG_SKYBOX:
        case DataTypes.EVENT:
            el_list.entries_are = ListEntries.GUIDS;
            break;
        case DataTypes.TILE:
            not_yet_implemented();
            break;
        case DataTypes.COLOR:
        case DataTypes.ENTITY:
        case DataTypes.MAP:
            not_yet_implemented();
            break;
        case DataTypes.ASSET_FLAG:
            not_yet_implemented();
            break;
        default:
            el_list.entries_are = ListEntries.STRINGS;
            break;
    }
    dg.el_list_main = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(16, yy, "Add", ew, eh, fa_center, omu_data_list_add, dg);
    el_add.key = root.key;
    dg.el_add = el_add;
    yy += el_add.height + spacing;
    var el_remove = create_button(16, yy, "Delete", ew, eh, fa_center, omu_data_list_remove, dg);
    el_remove.key = root.key;
    dg.el_remove = el_remove;
    yy += el_remove.height + spacing;
    
    switch (property.type) {
        case DataTypes.INT:
            var el_value = create_input(16, yy, "Value: ", ew, eh, uivc_data_property_list_number,
                "0", string(property.range_min) + "..." + string(property.range_max),
                validate_int, property.range_min, property.range_max, number_max_digits(property.range_max), vx1, vy1, vx2, vy2, dg
            );
            el_value.key = root.key;
            yy += el_value.height + spacing;
            break;
        case DataTypes.FLOAT:
            var el_value = create_input(16, yy, "Value: ", ew, eh, uivc_data_property_list_number, "0", string(property.range_min) + "..." + string(property.range_max),
                validate_double, property.range_min, property.range_max, 12, vx1, vy1, vx2, vy2, dg);
            el_value.key = root.key;
            yy += el_value.height + spacing;
            break;
        case DataTypes.STRING:
            var el_value = create_input(16, yy, "Value: ", ew, eh, uivc_data_property_list_string, "0", "text", validate_string, 0, 1, property.char_limit, vx1, vy1, vx2, vy2, dg);
            el_value.key = root.key;
            yy += el_value.height + spacing;
            break;
        case DataTypes.BOOL:
            // this onvaluechange just copies the value without casting it so we can do this even though it's designed for strings and
            // bools are decidedly not strings
            var el_value = create_checkbox(16, yy, "Value", ew, eh, uivc_data_property_list_string, false, dg);
            el_value.key = root.key;
            yy += el_value.height + spacing;
            break;
        case DataTypes.ASSET_FLAG:
            not_yet_implemented();
            break;
        case DataTypes.CODE:
            var el_value = create_input_code(16, yy, "Code: ", ew, eh, vx1, vy1, vx2, vy2, "", uivc_data_property_list_string, dg, root.key);
            yy += el_value.height + spacing;
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
            var base_type = guid_get(property.type_guid);
            var base_list = (property.type == DataTypes.ENUM) ? base_type.properties : base_type.instances;
            var el_value = create_list(16, yy, "Select " + guid_get(property.type_guid).name + ":", "<no options>", ew, eh, 8, uivc_data_property_list_guid, false, dg, base_list);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.AUDIO_BGM:
            var el_value = create_list(16, yy, "Select a BGM resource:", "<no BGM>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.audio.bgm);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.AUDIO_SE:
            var el_value = create_list(16, yy, "Select an SE resource:", "<no SE>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.audio.se);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_TILE_ANIMATION:
            var el_value = create_list(16, yy, "Select a Tile Animation resource:", "<no Autotiles>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.tile_animations);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.COLOR:
            var el_value = create_button(16, yy, "Value", ew, eh, fa_left, not_yet_implemented, dg);
            el_value.key = root.key;
            yy += el_value.height + spacing;
            break;
        case DataTypes.MESH:
            var el_value = create_list(16, yy, "Select a Mesh resource:", "<no Meshes>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.meshes);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.MESH_AUTOTILE:
            var el_value = create_list(16, yy, "Select a Mesh Autotile resource:", "<no Mesh Autotiles>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Stuff.all_mesh_autotiles);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_TEXTURE:
            not_yet_implemented();
            var el_value = create_list(16, yy, "Select a Tileset resource:", "<no Tilesets>", ew, eh, 8, uivc_data_property_list_guid, false, dg);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_BATTLER:
            var el_value = create_list(16, yy, "Select a Battler sprite:", "<no Battlers>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.battlers);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_OVERWORLD:
            var el_value = create_list(16, yy, "Select am Overworld sprite:", "<no Overworlds>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.overworlds);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_PARTICLE:
            var el_value = create_list(16, yy, "Select a Particle sprite:", "<no Particles>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.particles);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_UI:
            var el_value = create_list(16, yy, "Select a UI images:", "<no UI images>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.ui);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_ETC:
            var el_value = create_list(16, yy, "Select a misc. image:", "<no misc. images>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.etc);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.IMG_SKYBOX:
            var el_value = create_list(16, yy, "Select a skybox image:", "<no skybox images>", ew, eh, 8, uivc_data_property_list_guid, false, dg, Game.graphics.skybox);
            el_value.entries_are = ListEntries.INSTANCES;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
        case DataTypes.TILE:
            not_yet_implemented();
            break;
        case DataTypes.ANIMATION:
            var el_value = create_list(16, yy, "Select an Animation resource:", "<no Animation>", ew, eh, 8, uivc_data_property_list_guid, false, dg);
            el_value.entries_are = ListEntries.GUIDS;
            el_value.key = root.key;
            yy += ui_get_list_height(el_value) + spacing;
            break;
    }
    
    dg.el_value = el_value;
    
    dg.height = dg.height + yy;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dg.height - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    dg.el_confirm = el_confirm;
    
    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_remove,
        el_value,
        el_confirm
    );
    
    return dg;
}