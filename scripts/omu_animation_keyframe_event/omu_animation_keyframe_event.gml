/// @param UIThing

var thing = argument0;
var keyframe = thing.root.root.el_timeline.selected_keyframe;

if (keyframe) {
    // keyframe is guaranteed to have a value
    var dw = 640;
    var dh = 560;

    var dg = dialog_create(dw, dh, "More Keyframe Events", undefined, undefined, argument0);
    
    var columns = 2;
    var ew = (dw - 64) / columns;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var col2_x = dw / columns;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    var spacing = 16;
    
    var el_graphic_type = create_radio_array(16, yy, "Graphic Type", ew, eh, uivc_animation_keyframe_graphic_type, keyframe.graphic_type, dg);
    create_radio_array_options(el_graphic_type, ["None", "No Change", "Sprite", "Mesh"]);
    
    yy = yy + ui_get_radio_array_height(el_graphic_type) + spacing;
    
    var el_graphic_speed = create_input(16, yy, "Animation Speed", ew, eh, uivc_animation_keyframe_graphic_speed, 0, keyframe.graphic_speed, "float", validate_double, ui_value_real, 0, 16, 4, vx1, vy1, vx2, vy2, dg);
    
    yy = yy + el_graphic_speed.height + spacing;
    
    var el_event = create_input(16, yy, "Function call", ew, eh, uivc_animation_keyframe_function, 0, keyframe.event, "string", validate_string, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
    
    yy = yy + el_event.height + spacing;
    
    var el_audio = create_list(16, yy, "Sound Effect", "<no sound effects>", ew, eh, 8, uivc_animation_keyframe_audio, false, dg);
    el_audio.entries_are = ListEntries.GUIDS;
    for (var i = 0; i < ds_list_size(Stuff.all_se); i++) {
        create_list_entries(el_audio, Stuff.all_se[| i].GUID);
        if (keyframe.audio == Stuff.all_se[| i].GUID) {
            ds_map_add(el_audio.selected_entries, i, true);
        }
    }
    
    yy = yy + ui_get_list_height(el_audio) + spacing;
    
    yy = yy_base;
    
    // these will be switched off unless graphic type is set to the relevant setting
    var el_graphic_none = create_text(col2_x + 16, yy, "No graphic will be shown", ew, eh, fa_left, ew, dg);
    el_graphic_none.enabled = (keyframe.graphic_type == GraphicTypes.NONE);
    dg.el_graphic_none = el_graphic_none;
    
    var el_graphic_no_change = create_text(col2_x + 16, yy, "The layer's graphic will not change", ew, eh, fa_left, ew, dg);
    el_graphic_no_change.enabled = (keyframe.graphic_type == GraphicTypes.NO_CHANGE);
    dg.el_graphic_no_change = el_graphic_no_change;
    
    var el_graphic_sprite_list = create_list(col2_x + 16, yy, "Sprite", "<no sprites>", ew, eh, 16, not_yet_implemented, false, dg);
    el_graphic_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
    el_graphic_sprite_list.entries_are = ListEntries.GUIDS;
    dg.el_graphic_sprite_list = el_graphic_sprite_list;
    
    var el_graphic_mesh_list = create_list(col2_x + 16, yy, "Mesh", "<no meshes>", ew, eh, 16, not_yet_implemented, false, dg);
    el_graphic_mesh_list.enabled = (keyframe.graphic_type == GraphicTypes.MESH);
    // @todo this will need to be shifted to guids when meshes become those
    el_graphic_sprite_list.entries_are = ListEntries.STRINGS;
    dg.el_graphic_mesh_list = el_graphic_mesh_list;
    
    yy = yy + ui_get_list_height(el_graphic_sprite_list) + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents, el_graphic_type, el_graphic_speed, el_event, el_audio,
        el_graphic_none, el_graphic_no_change, el_graphic_sprite_list, el_graphic_mesh_list,
        el_confirm);
}