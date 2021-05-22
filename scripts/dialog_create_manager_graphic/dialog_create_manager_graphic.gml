function dialog_create_manager_graphic(root, name, list, prefix, load_function, drag_function, delete_function, change_function, export_function) {
    var dw = 1280;
    var dh = 720;
    
    var dg = dialog_create(dw, dh, name, dialog_default, dialog_destroy, root);
    dg.dialog_flags |= DialogFlags.IS_GENERIC_WARNING;
    dg.graphics_prefix = prefix;
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
    
    var el_list = create_list(16, yy, name, "<no images>", ew, eh, 20, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            // direct references to the texture images are dealt with elsewhere
            var what = list.entries[| selection];
            ui_input_set_value(list.root.el_name, what.name);
            ui_input_set_value(list.root.el_name_internal, what.internal_name);
            ui_input_set_value(list.root.el_frames_horizontal, string(what.hframes));
            ui_input_set_value(list.root.el_frames_vertical, string(what.vframes));
            ui_input_set_value(list.root.el_frame_speed, string(what.aspeed));
            list.root.el_texture_exclude.value = what.texture_exclude;
        }
    }, false, dg, list);
    el_list.render_colors = function(list, index) {
        return list.entries[| index].texture_exclude ? c_dkgray : c_black;
    };
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.numbered = true;
    dg.el_list = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(16, yy, "Add Image", ew, eh, fa_center, load_function, dg);
    el_add.file_dropper_action = drag_function;
    yy += el_add.height + spacing;
    
    var el_remove = create_button(16, yy, "Delete Image", ew, eh, fa_center, delete_function, dg);
    
    yy = yy_base;
    
    var el_change = create_button(c2 + 16, yy, "Change Image", ew, eh, fa_center, change_function, dg);
    yy += el_change.height + spacing;
    
    var el_export = create_button(c2 + 16, yy, "Export Image", ew, eh, fa_center, export_function, dg);
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
    var el_name = create_input(c2 + 16, yy, "", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list)
        if (selection + 1) {
            list.entries[| selection].name = input.value;
        }
    }, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
    yy += el_name_internal_text.height + spacing;
    
    var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        
        if (selection + 1) {
            var already = internal_name_get(input.value);
            if (!already || already == list.entries[| selection]) {
                internal_name_remove(list.entries[| selection].internal_name);
                internal_name_set(list.entries[| selection], input.value);
                input.color = c_black;
            } else {
                input.color = c_red;
            }
        }
    }, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name_internal.render = function(input, x, y) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            ui_input_set_value(input, list.entries[| selection].internal_name);
        }
        ui_render_input(input, x, y);
    };
    dg.el_name_internal = el_name_internal;
    yy += el_name_internal.height + spacing;
    
    var el_dimensions = create_text(c2 + 16, yy, "Dimensions:", ew, eh, fa_left, ew, dg);
    el_dimensions.render = function(text, x, y) {
        var list = text.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var image = list.entries[| selection];
            text.text = "Dimensions: " + string(image.width) + " x " + string(image.height);
            if (image.width != sprite_get_width(image.picture) || image.height != sprite_get_height(image.picture)) {
                text.text += " (" + string(sprite_get_width(image.picture)) + " x " + string(sprite_get_height(image.picture)) + ")";
            }
        } else {
            text.text = "Dimensions: N/A";
        }
        ui_render_text(text, x, y);
    };
    dg.el_dimensions = el_dimensions;
    yy += el_dimensions.height + spacing;
    
    vx1 = ew / 2;
    
    var el_frames_horizontal = create_input(c2 + 16, yy, "X frames:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var image = list.entries[| selection];
            image.hframes = real(input.value);
            sprite_delete(image.picture_with_frames);
            var temp_name = PATH_TEMP + "particle_strip" + string(image.hframes) + ".png";
            sprite_save(image.picture, 0, temp_name);
            image.picture_with_frames = sprite_add(temp_name, image.hframes, false, false, 0, 0);
            sprite_set_speed(image.picture_with_frames, image.aspeed, spritespeed_framespersecond);
            data_image_npc_frames(list.entries[| selection]);
        }
    }, "1", "0...255", validate_int, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
    el_frames_horizontal.render = function(input, x, y) {
        ui_render_input(input, x, y);
    };
    dg.el_frames_horizontal = el_frames_horizontal;
    yy += el_name_internal.height + spacing;
    
    var el_frames_vertical = create_input(c2 + 16, yy, "Y frames:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);

        if (selection + 1) {
            list.entries[| selection].vframes = real(input.value);
        }
    }, "1", "0...255", validate_int, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
    dg.el_frames_vertical = el_frames_vertical;
    yy += el_frames_vertical.height + spacing;
    
    var el_texture_exclude = create_checkbox(c2 + 16, yy, "Exclude from texture page?", ew, eh, function(checkbox) {
        var list = checkbox.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            list.entries[| selection].texture_exclude = checkbox.value;
        }
    }, false, dg);
    el_texture_exclude.tooltip = "For optimization purposes the game may attempt to pack related sprites onto a single texture. In some cases you may wish for that to not happen.";
    el_texture_exclude.enabled = false;
    dg.el_texture_exclude = el_texture_exclude;
    
    var el_frame_speed = create_input(c2 + 16, yy, "Speed:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var image = list.entries[| selection];
            image.aspeed = real(input.value);
            sprite_set_speed(image.picture_with_frames, image.aspeed, spritespeed_framespersecond);
        }
    }, "1", "float", validate_double, 0, 60, 4, vx1, vy1, vx2, vy2, dg);
    el_frame_speed.tooltip = "This should be frames per second, although like everything else this depends largely on how you plan on using it.";
    dg.el_frame_speed = el_frame_speed;
    yy += el_frame_speed.height + spacing;
    
    var el_dim_set_crop = create_button(c2 + 16, yy, "Dimensions: Crop", ew, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var data = list.entries[| selection];
            // @todo impelment a cutoff value
            var dim = sprite_get_cropped_dimensions(data.picture, 0, 127);
            // @todo implement a value to round to?
            var round_to = 16;
            data.width = round_ext(dim[vec3.xx], round_to);
            data.height = round_ext(dim[vec3.yy], round_to);
            data_image_npc_frames(data);
        }
    }, dg);
    yy += el_dim_set_crop.height + spacing;
    
    var el_dim_set_full = create_button(c2 + 16, yy, "Dimensions: Full", ew, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var data = list.entries[| selection];
            data.width = sprite_get_width(data.picture);
            data.height = sprite_get_height(data.picture);
            data_image_npc_frames(data);
        }
    }, dg);
    yy += el_dim_set_full.height + spacing;
    
    yy = yy_base;
    
    var el_image = create_image_button(c3 + 16, yy, "", -1, ew * 2, ew * 2, fa_center, function(button) {
        if (button.image) {
            var xpadding = 64;
            var ypadding = 128;
            var dw = clamp(sprite_get_width(button.image), 192, 960) + xpadding;
            var dh = clamp(sprite_get_height(button.image), 192, 960) + ypadding;
            var dg = dialog_create(dw, dh, "Picture", dialog_default, dialog_destroy, button.root);
            var b_width = 128;
            var b_height = 32;
            var el_picture = create_image_button(xpadding / 2, ypadding / 2, "", button.image, dw - xpadding, dh - ypadding, fa_center, null, dg);
            el_picture.draw_checker_behind = true;
            el_picture.interactive = false;
            var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Okay", b_width, b_height, fa_center, dmu_dialog_commit, dg);
            ds_list_add(dg.contents, el_picture, el_confirm);
        }
    }, dg);
    el_image.draw_checker_behind = true;
    el_image.render = function(button, x, y) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            button.image = list.entries[| selection].picture;
        } else {
            button.image = -1;
        }
        ui_render_image_button(button, x, y);
    };
    dg.el_image = el_image;
    yy += el_image.height + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
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
        el_frames_horizontal,
        el_frames_vertical,
        el_texture_exclude,
        el_image,
        el_frame_speed,
        el_dim_set_crop,
        el_dim_set_full,
        el_confirm
    );
    
    return dg;
}