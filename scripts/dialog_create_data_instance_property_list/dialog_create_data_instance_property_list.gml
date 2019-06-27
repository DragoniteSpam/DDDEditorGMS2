/// @param Dialog

var selection = ui_list_selection(Camera.ui_game_data.el_instances);

// this is honestly easier than disabling/enabling interface elements when stuff is deselected
if (selection < 0) {
    return noone;
}

// only create the dialog if something's selected

var dw = 320;
var dh = 64;

var data = guid_get(Camera.ui_game_data.active_type_guid);
var property = data.properties[| argument0.key];
var instance = guid_get(data.instances[| selection].GUID);

var dg = dialog_create(dw, dh, instance.name + "." + property.name, dialog_default, dc_close_no_questions_asked, argument0);

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var vx1 = dw / (columns * 2) - 16;
var vy1 = 0;
var vx2 = vx1 + dw / (columns * 2) - 16;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var spacing = 16;

var yy = 64;

var plist = instance.values[| argument0.key];
var el_list = create_list(16, yy, "Values (" + string(ds_list_size(plist)) + " / " + string(property.max_size) + ")",
    "<something went wrong>", ew, eh, 8, uivc_list_data_list_select, false, dg);
el_list.numbered = true;
el_list.key = argument0.key;
// @todo when other data types are added that use guids like mesh or audio
if (property.type == DataTypes.ENUM || property.type == DataTypes.DATA) {
    el_list.entries_are = ListEntries.GUIDS;
} else {
    el_list.entries_are = ListEntries.STRINGS;
}
dg.el_list_main = el_list;

for (var i = 0; i < ds_list_size(plist); i++) {
    if (el_list.entries_are == ListEntries.STRINGS) {
        create_list_entries(el_list, string(plist[| i]), c_black);
    } else {
        create_list_entries(el_list, plist[| i], c_black);
    }
}

yy = yy + ui_get_list_height(el_list) + spacing;

var el_add = create_button(16, yy, "Add", ew, eh, fa_center, omu_data_list_add, dg);
el_add.key = argument0.key;
dg.el_add = el_add;
yy = yy + el_add.height + spacing;
var el_remove = create_button(16, yy, "Remove", ew, eh, fa_center, omu_data_list_remove, dg);
el_remove.key = argument0.key;
dg.el_remove = el_remove;
yy = yy + el_remove.height + spacing;

switch (property.type) {
    case DataTypes.INT:
        var el_value = create_input(16, yy, "Value: ", ew, eh, uivc_data_property_list_number, argument0.key, "0", string(property.range_min) + "..." + string(property.range_max),
            validate_int, ui_value_real, property.range_min, property.range_max, log10(property.range_max) + 2, vx1, vy1, vx2, vy2, dg);
        yy = yy + el_value.height + spacing;
        break;
    case DataTypes.FLOAT:
        var el_value = create_input(16, yy, "Value: ", ew, eh, uivc_data_property_list_number, argument0.key, "0", string(property.range_min) + "..." + string(property.range_max),
            validate_double, ui_value_real, property.range_min, property.range_max, 12, vx1, vy1, vx2, vy2, dg);
        yy = yy + el_value.height + spacing;
        break;
    case DataTypes.STRING:
        var el_value = create_input(16, yy, "Value: ", ew, eh, uivc_data_property_list_string, argument0.key, "0", "text", validate_string, ui_value_string, 0, 1, property.char_limit, vx1, vy1, vx2, vy2, dg);
        yy = yy + el_value.height + spacing;
        break;
    case DataTypes.BOOL:
        // this onvaluechange just copies the value without casting it so we can do this even though it's designed for strings and
        // bools are decidedly not strings
        var el_value = create_checkbox(16, yy, "Value", ew, eh, uivc_data_property_list_string, argument0.key, false, dg);
        yy = yy + el_value.height + spacing;
        break;
    case DataTypes.CODE:
        var el_value = create_input_code(16, yy, "Code: ", ew, eh, vx1, vy1, vx2, vy2, "-- write Lua here", uivc_data_property_list_string, dg, argument0.key);
        yy = yy + el_value.height + spacing;
        break;
    case DataTypes.ENUM:
    case DataTypes.DATA:
        var el_value = create_list(16, yy, "Select " + guid_get(property.type_guid).name + ":", "<no options>", ew, eh, 8, uivc_data_property_list_data, false, dg);
        el_value.entries_are = ListEntries.GUIDS;
        
        var base_type = guid_get(property.type_guid);
        var base_list = (property.type == DataTypes.ENUM) ? base_type.properties : base_type.instances;
        for (var i = 0; i < ds_list_size(base_list); i++) {
            create_list_entries(el_value, base_list[| i].GUID, c_black);
        }
        
        dg.el_list_main = el_list;
        el_value.key = argument0.key;
        yy = yy + ui_get_list_height(el_value) + spacing;
        break;
    case DataTypes.AUDIO_BGM:
        var el_value = create_list(16, yy, "Select a BGM resource:", "<no BGM>", ew, eh, 8, stack_trace, false, dg);
        el_value.entries_are = ListEntries.GUIDS;
        
        for (var i = 0; i < ds_list_size(Stuff.all_bgm); i++) {
            create_list_entries(el_value, Stuff.all_bgm[| i].GUID, c_black);
        }
        
        dg.el_list_main = el_list;
        el_value.key = argument0.key;
        yy = yy + ui_get_list_height(el_value) + spacing;
        break;
    case DataTypes.AUDIO_SE:
        var el_value = create_list(16, yy, "Select an SE resource:", "<no SE>", ew, eh, 8, stack_trace, false, dg);
        el_value.entries_are = ListEntries.GUIDS;
        
        for (var i = 0; i < ds_list_size(Stuff.all_se); i++) {
            create_list_entries(el_value, Stuff.all_se[| i].GUID, c_black);
        }
        
        dg.el_list_main = el_list;
        el_value.key = argument0.key;
        yy = yy + ui_get_list_height(el_value) + spacing;
        break;
    case DataTypes.AUTOTILE:
        var el_value = create_list(16, yy, "Select an Autotile resource:", "<no Autotiles>", ew, eh, 8, stack_trace, false, dg);
        el_value.entries_are = ListEntries.GUIDS;
        /*
        for (var i = 0; i < ds_list_size(Stuff.all_se); i++) {
            create_list_entries(el_value, Stuff.all_se[| i].GUID, c_black);
        }
        */
        dg.el_list_main = el_list;
        el_value.key = argument0.key;
        yy = yy + ui_get_list_height(el_value) + spacing;
        break;
    case DataTypes.COLOR:
        stack_trace();
        break;
    case DataTypes.MESH:
        var el_value = create_list(16, yy, "Select a Mesh resource:", "<no Meshes>", ew, eh, 8, stack_trace, false, dg);
        el_value.entries_are = ListEntries.GUIDS;
        /*
        for (var i = 0; i < ds_list_size(Stuff.all_se); i++) {
            create_list_entries(el_value, Stuff.all_se[| i].GUID, c_black);
        }
        */
        dg.el_list_main = el_list;
        el_value.key = argument0.key;
        yy = yy + ui_get_list_height(el_value) + spacing;
        break;
    case DataTypes.TILESET:
        var el_value = create_list(16, yy, "Select a Tileset resource:", "<no Tilesets>", ew, eh, 8, stack_trace, false, dg);
        el_value.entries_are = ListEntries.GUIDS;
        /*
        for (var i = 0; i < ds_list_size(Stuff.all_se); i++) {
            create_list_entries(el_value, Stuff.all_se[| i].GUID, c_black);
        }
        */
        dg.el_list_main = el_list;
        el_value.key = argument0.key;
        yy = yy + ui_get_list_height(el_value) + spacing;
        break;
    case DataTypes.TILE:
        stack_trace();
        break;
}

dg.el_value = el_value;

dg.height = dg.height + yy;

var el_confirm = create_button(dw / 2 - b_width / 2, dg.height - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
dg.el_confirm = el_confirm;

ds_list_add(dg.contents, el_list, el_add, el_remove, el_value,
    el_confirm);

keyboard_string = "";

return dg;