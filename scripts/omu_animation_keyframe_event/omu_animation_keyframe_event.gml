/// @param UIThing

var thing = argument0;
var keyframe = thing.root.root.el_timeline.selected_keyframe;

if (keyframe) {
    // keyframe is guaranteed to have a value
    var dw = 960;
    var dh = 640;

    var dg = dialog_create(dw, dh, "More Keyframe Events", undefined, undefined, thing);
    
    var spacing = 16;
    var columns = 3;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var col1_x = dw * 0 / columns + spacing;
    var col2_x = dw * 1 / columns + spacing;
    var col3_x = dw * 2 / columns + spacing;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_graphic_type = create_radio_array(col1_x, yy, "Graphic Type", ew, eh, uivc_animation_keyframe_graphic_type, keyframe.graphic_type, dg);
    create_radio_array_options(el_graphic_type, ["None", "No Change", "Sprite", "Mesh"]);
    yy += ui_get_radio_array_height(el_graphic_type) + spacing;
    
    var el_event = create_input(col1_x, yy, "Function call", ew, eh, uivc_animation_keyframe_function, keyframe.event, "string", validate_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
    yy += el_event.height + spacing;
    
    var el_audio = create_list(col1_x, yy, "Sound Effect", "<no sound effects>", ew, eh, 10, uivc_animation_keyframe_audio, false, dg, Stuff.all_se);
    el_audio.entries_are = ListEntries.INSTANCES;
    dg.el_audio = el_audio;
    
    var audio_index = ds_list_find_index(Stuff.all_se, keyframe.audio);
    ui_list_select(el_audio, audio_index);
    
    yy += ui_get_list_height(el_audio) + spacing;
    
    yy = yy_base;
    
    // these will be switched off unless graphic type is set to the relevant setting
    var el_graphic_none = create_text(col2_x, yy, "No graphic will be shown", ew, eh, fa_left, ew, dg);
    el_graphic_none.enabled = (keyframe.graphic_type == GraphicTypes.NONE);
    dg.el_graphic_none = el_graphic_none;
    
    var el_graphic_no_change = create_text(col2_x, yy, "The layer's graphic will not change", ew, eh, fa_left, ew, dg);
    el_graphic_no_change.enabled = (keyframe.graphic_type == GraphicTypes.NO_CHANGE);
    dg.el_graphic_no_change = el_graphic_no_change;
    
    var el_graphic_overworld_sprite_list = create_list(col2_x, yy, "Sprite: Overworlds", "<no overworld sprites>", ew, eh, 8, uivc_animation_keyframe_graphic_sprite, false, dg, Stuff.all_graphic_overworlds);
    el_graphic_overworld_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
    el_graphic_overworld_sprite_list.entries_are = ListEntries.INSTANCES;
    dg.el_graphic_overworld_sprite_list = el_graphic_overworld_sprite_list;
    
    var el_graphic_battler_sprite_list = create_list(col3_x, yy, "Sprite: Battlers", "<no battler sprites>", ew, eh, 8, uivc_animation_keyframe_graphic_sprite, false, dg, Stuff.all_graphic_battlers);
    el_graphic_battler_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
    el_graphic_battler_sprite_list.entries_are = ListEntries.INSTANCES;
    dg.el_graphic_battler_sprite_list = el_graphic_battler_sprite_list;
    
    yy += ui_get_list_height(el_graphic_overworld_sprite_list) + spacing;
    
    var el_graphic_frame = create_input(col2_x, yy, "Frame", ew, eh, uivc_animation_keyframe_graphic_frame, keyframe.graphic_frame, "float", validate_int, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
    dg.el_graphic_frame = el_graphic_frame;
    yy += el_graphic_frame.height + spacing;
    
    var el_graphic_direction = create_input(col2_x, yy, "Direction", ew, eh, uivc_animation_keyframe_graphic_direction, keyframe.graphic_direction, "float", validate_int, 0, 4, 1, vx1, vy1, vx2, vy2, dg);
    dg.el_graphic_direction = el_graphic_direction;
    yy += el_graphic_direction.height + spacing;
    
    var sprite_overworld_index = ds_list_find_index(Stuff.all_graphic_overworlds, keyframe.graphic_sprite);
    ui_list_select(el_graphic_overworld_sprite_list, sprite_overworld_index);
    
    var sprite_battler_index = ds_list_find_index(Stuff.all_graphic_battlers, keyframe.graphic_sprite);
    ui_list_select(el_graphic_battler_sprite_list, sprite_battler_index);
    
    var el_graphic_mesh_list = create_list(col2_x, yy, "Mesh", "<no meshes>", ew, eh, 16, uivc_animation_keyframe_graphic_mesh, false, dg, Stuff.all_meshes);
    el_graphic_mesh_list.enabled = (keyframe.graphic_type == GraphicTypes.MESH);
    // @todo this will need to be shifted to guids when meshes become those
    el_graphic_mesh_list.entries_are = ListEntries.INSTANCES;
    dg.el_graphic_mesh_list = el_graphic_mesh_list;
    
    var mesh_index = ds_list_find_index(Stuff.all_meshes, keyframe.graphic_mesh);
    ui_list_select(el_graphic_mesh_list, mesh_index);
    
    yy += ui_get_list_height(el_graphic_mesh_list) + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_graphic_type,
        el_event,
        el_audio,
        el_graphic_none,
        el_graphic_no_change,
        el_graphic_overworld_sprite_list,
        el_graphic_battler_sprite_list,
        el_graphic_frame,
        el_graphic_direction,
        el_graphic_mesh_list,
        el_confirm
    );
}