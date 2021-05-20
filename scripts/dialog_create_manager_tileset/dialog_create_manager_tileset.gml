function dialog_create_manager_tileset(root) {
    var dw = 1280;
    var dh = 720;
    
    var dg = dialog_create(dw, dh, "Data: Textures and Tilesets", dialog_default, dc_close_no_questions_asked, root);
    dg.dialog_flags |= DialogFlags.IS_GENERIC_WARNING;
    var columns = 4;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var c1 = 0 * dw / columns;
    var c2 = 1 * dw / columns;
    var c3 = 2 * dw / columns;
    var c4 = 3 * dw / columns;
    
    var vx1 = 0;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_list = create_list(16, yy, "Tilesets and Textures", "<no tilesets or textures>", ew, eh, 20, uivc_list_graphic_generic, false, dg, Stuff.all_graphic_tilesets);
    el_list.render_colors = ui_list_colors_image_exclude;
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.numbered = true;
    dg.el_list = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(16, yy, "Add Image", ew, eh, fa_center, dmu_dialog_load_graphic_texture, dg);
    el_add.file_dropper_action = uifd_load_img_tileset;
    yy += el_add.height + spacing;
    
    var el_remove = create_button(16, yy, "Delete Image", ew, eh, fa_center, dmu_dialog_remove_graphic_texture, dg);
    
    yy = yy_base;
    
    var el_change = create_button(c2 + 16, yy, "Change Image", ew, eh, fa_center, dmu_dialog_change_graphic_general, dg);
    yy += el_change.height + spacing;
    
    var el_export = create_button(c2 + 16, yy, "Export Image", ew, eh, fa_center, dmu_dialog_export_graphic, dg);
    yy += el_export.height + spacing;
    
    var el_remove_background = create_button(c2 + 16, yy, "Remove Background Color", ew, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var data = list.entries[| selection];
            data.picture = sprite_remove_transparent_color(data.picture);
            button.root.el_image.image = data.picture;
        }
    }, dg);
    yy += el_remove_background.height + spacing;
    
    var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
    yy += el_name_text.height + spacing;
    var el_name = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_name, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
    yy += el_name_internal_text.height + spacing;
    
    var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_internal_name, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name_internal = el_name_internal;
    yy += el_name_internal.height + spacing;
    
    var el_dimensions = create_text(c2 + 16, yy, "Dimensions:", ew, eh, fa_left, ew, dg);
    dg.el_dimensions = el_dimensions;
    yy += el_dimensions.height + spacing;
    
    vx1 = ew / 2;
    
    dg.el_frames_horizontal = noone;
    dg.el_frames_vertical = noone;
    dg.el_texture_exclude = noone;
    
    yy = yy_base;
    
    var el_image = create_image_button(c3 + 16, yy, "", -1, ew * 2, ew * 2, fa_center, dmu_dialog_show_big_picture, dg);
    el_image.draw_checker_behind = true;
    el_image.render = ui_render_image_button_graphic;
    dg.el_image = el_image;
    yy += el_image.height + spacing;
    
    dg.el_dim_x = noone;
    dg.el_dim_y = noone;
    dg.el_frame_speed = noone;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit__select_tileset, dg);
    el_confirm.select_tileset = false;
    dg.el_confirm = el_confirm;
    
    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_remove,
        el_change,
        el_export,
        el_remove_background,
        el_name_text,
        el_name,
        el_name_internal_text,
        el_name_internal,
        el_dimensions,
        el_image,
        el_confirm
    );
    
    return dg;
}