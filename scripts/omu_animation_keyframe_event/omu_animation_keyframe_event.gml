/// @param UIThing
function omu_animation_keyframe_event(argument0) {

    var thing = argument0;
    var keyframe = thing.root.root.el_timeline.selected_keyframe;

    if (!keyframe) {
        return;
    }

    // keyframe is guaranteed to have a value
    var dw = 960;
    var dh = 640;

    var dg = dialog_create(dw, dh, "More Keyframe Events", undefined, undefined, thing);
    dg.keyframe = keyframe;

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
    yy += el_graphic_type.GetHeight() + spacing;

    var el_event = create_input(col1_x, yy, "Function call", ew, eh, uivc_animation_keyframe_function, keyframe.event, "string", validate_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
    yy += el_event.height + spacing;

    var el_audio = create_list(col1_x, yy, "Sound Effect", "<no sound effects>", ew, eh, 10, uivc_animation_keyframe_audio, false, dg, Game.audio.se);
    el_audio.entries_are = ListEntries.INSTANCES;
    dg.el_audio = el_audio;

    var audio_index = array_get_index(Game.audio.se, keyframe.audio);
    ui_list_select(el_audio, audio_index);

    yy += el_audio.GetHeight() + spacing;

    yy = yy_base;

    // these will be switched off unless graphic type is set to the relevant setting
    var el_graphic_none = create_text(col2_x, yy, "No graphic will be shown", ew, eh, fa_left, ew, dg);
    el_graphic_none.enabled = (keyframe.graphic_type == GraphicTypes.NONE);
    dg.el_graphic_none = el_graphic_none;

    var el_graphic_no_change = create_text(col2_x, yy, "The layer's graphic will not change", ew, eh, fa_left, ew, dg);
    el_graphic_no_change.enabled = (keyframe.graphic_type == GraphicTypes.NO_CHANGE);
    dg.el_graphic_no_change = el_graphic_no_change;

    var el_graphic_overworld_sprite_list = create_list(col2_x, yy, "Sprite: Overworlds", "<no overworld sprites>", ew, eh, 8, uivc_animation_keyframe_graphic_sprite, false, dg, Game.graphics.overworlds);
    el_graphic_overworld_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
    el_graphic_overworld_sprite_list.entries_are = ListEntries.INSTANCES;
    dg.el_graphic_overworld_sprite_list = el_graphic_overworld_sprite_list;

    var el_graphic_battler_sprite_list = create_list(col3_x, yy, "Sprite: Battlers", "<no battler sprites>", ew, eh, 8, uivc_animation_keyframe_graphic_sprite, false, dg, Game.graphics.battlers);
    el_graphic_battler_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
    el_graphic_battler_sprite_list.entries_are = ListEntries.INSTANCES;
    dg.el_graphic_battler_sprite_list = el_graphic_battler_sprite_list;

    yy += el_graphic_overworld_sprite_list.GetHeight() + spacing;

    var el_graphic_battler_sprite_render = create_render_surface(col3_x, yy, ew, ew, ui_render_surface_render_animation_frame, null, c_white, dg);
    el_graphic_battler_sprite_render.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
    dg.el_graphic_battler_sprite_render = el_graphic_battler_sprite_render;

    var el_graphic_frame = create_input(col2_x, yy, "Frame", ew, eh, uivc_animation_keyframe_graphic_frame, keyframe.graphic_frame, "float", validate_int, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
    dg.el_graphic_frame = el_graphic_frame;
    yy += el_graphic_frame.height + spacing;

    var el_graphic_direction = create_input(col2_x, yy, "Direction", ew, eh, uivc_animation_keyframe_graphic_direction, keyframe.graphic_direction, "float", validate_int, 0, 4, 1, vx1, vy1, vx2, vy2, dg);
    dg.el_graphic_direction = el_graphic_direction;
    yy += el_graphic_direction.height + spacing;

    var sprite_overworld_index = array_get_index(Game.graphics.overworlds, keyframe.graphic_sprite);
    ui_list_select(el_graphic_overworld_sprite_list, sprite_overworld_index, true);

    var sprite_battler_index = array_get_index(Game.graphics.battlers, keyframe.graphic_sprite);
    ui_list_select(el_graphic_battler_sprite_list, sprite_battler_index, true);

    var el_graphic_mesh_list = create_list(col2_x, yy, "Mesh", "<no meshes>", ew, eh, 16, uivc_animation_keyframe_graphic_mesh, false, dg, Game.meshes);
    el_graphic_mesh_list.enabled = (keyframe.graphic_type == GraphicTypes.MESH);
    el_graphic_mesh_list.entries_are = ListEntries.INSTANCES;
    dg.el_graphic_mesh_list = el_graphic_mesh_list;

    var mesh_index = array_get_index(Game.meshes, keyframe.graphic_mesh);
    ui_list_select(el_graphic_mesh_list, mesh_index);

    yy += el_graphic_mesh_list.GetHeight() + spacing;

    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_graphic_type,
        el_event,
        el_audio,
        el_graphic_none,
        el_graphic_no_change,
        el_graphic_overworld_sprite_list,
        el_graphic_battler_sprite_list,
        el_graphic_battler_sprite_render,
        el_graphic_frame,
        el_graphic_direction,
        el_graphic_mesh_list,
        el_confirm
    );


}
