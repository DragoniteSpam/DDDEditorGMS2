function dialog_create_mesh_advanced(root, mesh) {
    var dw = 1280;
    var dh = 560;
    
    var dg = dialog_create(dw, dh, "Advanced Mesh Options: " + mesh.name, dialog_default, dc_close_no_questions_asked, root);
    dg.mesh = mesh;
    
    var columns = 4;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = dw * 0 / 4 + spacing;
    var col2_x = dw * 1 / 4 + spacing;
    var col3_x = dw * 2 / 4 + spacing;
    var col4_x = dw * 3 / 4 + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    
    var replace_sub = function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        var fn = get_open_filename_mesh();
        var mesh_data = button.root.mesh;
        
        if (selection + 1 && file_exists(fn)) {
            // @todo try catch
            switch (filename_ext(fn)) {
                case ".obj": import_obj(fn, undefined, mesh_data, selection); break;
                case ".d3d": case ".gmmod": import_d3d(fn, undefined, false, mesh_data, selection); break;
                case ".smf": import_smf(fn, mesh_data, selection); break;
            }
        }
        
        batch_again();
    }
    
    var el_list = create_list(col1_x, yy, mesh.name + " submeshes", "(none)", ew, eh, 10, function(list) {
        selection = ui_list_selection(list);
        ui_input_set_value(list.root.el_name, list.root.mesh.submeshes[| selection].name);
    }, false, dg, mesh.submeshes);
    el_list.tooltip = "Each mesh can have a number of different sub-meshes. This can be used to give multiple meshes different visual skins, or to imitate primitive frame-based animation.";
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.ondoubleclick = replace_sub;
    ui_list_select(el_list, 0);
    dg.el_list = el_list;
    yy += ui_get_list_height(el_list) + spacing;

    var el_add = create_button(col1_x, yy, "Add Sub-Mesh", ew, eh, fa_center, function(button) {
        var fn = get_open_filename_mesh();
        var mesh_data = button.root.mesh;
        // @todo try catch
        if (file_exists(fn)) {
            switch (filename_ext(fn)) {
                case ".obj": import_obj(fn, undefined, mesh_data); break;
                case ".d3d": case ".gmmod": import_d3d(fn, undefined, false, mesh_data); break;
                case ".smf": import_smf(fn, mesh_data); break;
            }
        }
    }, dg);
    el_add.file_dropper_action = function(thing, files) {
        var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".smf"]);
        for (var i = 0; i < ds_list_size(filtered_list); i++) {
            var fn = filtered_list[| i];
            switch (filename_ext(fn)) {
                case ".obj": import_obj(fn, true, false, thing.root.mesh); break;
                case ".d3d": case ".gmmod": import_d3d(fn, true, false, thing.root.mesh); break;
                case ".smf": import_smf(fn);
            }
        }
    };
    el_add.tooltip = "Add a sub-mesh";
    yy += el_add.height + spacing;
    
    var el_replace = create_button(col1_x, yy, "Replace Sub-Mesh", ew, eh, fa_center, replace_sub, dg);
    el_replace.tooltip = "Replace a sub-mesh";
    yy += el_replace.height + spacing;
    
    var el_delete = create_button(col1_x, yy, "Delete Sub-Mesh", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            if (ds_list_size(mesh.submeshes) == 1) {
                dialog_create_notice(button, "Please don't delete the last submesh!");
            } else {
                mesh.submeshes[| selection]._destructor();
                ds_list_delete(mesh.submeshes, selection);
                ui_list_deselect(list);
            }
        }
    }, dg);
    el_delete.tooltip = "Delete a sub-mesh";
    yy += el_delete.height + spacing;
    
    var el_name = create_input(col1_x, yy, "Name:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            list.root.mesh.submeshes[| selection].name = input.value;
        }
    }, mesh.submeshes[| 0].name, "Enter a name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "You don't have to, but it's generally helpful to give your submeshes names to identify them with.";
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    if (mesh.submeshes[| 0].path == "") {
        var text = "<no path saved>";
    } else {
        var text = mesh.submeshes[| 0].path;
    }
    var el_text_submesh_path = create_text(col1_x, yy, text, ew, eh, fa_left, ew, dg);
    el_text_submesh_path.render = function(text, x, y) {
        var selection = ui_list_selection(text.root.el_list);
        var mesh_data = text.root.mesh;
        var base_text = text.text;
        
        if (selection + 1) {
            if (mesh_data.submeshes[| selection].path == "") {
                var str = "<no path saved>";
            } else {
                var str = mesh_data.submeshes[| selection].path;
            }
        } else {
            var str = "";
        }
        
        text.text = "";
        for (var i = string_length(str); i > 0; i--) {
            text.text = string_char_at(str, i) + text.text;
            if (string_width(text.text) > (text.wrap_width - string_width("...") - text.offset)) {
                if (i < string_length(str)) {
                    text.text = "..." + text.text;
                }
                break;
            }
        }
        text.tooltip = str;
        
        ui_render_text(text, x, y);
        text.text = base_text;
    };
    yy += el_text_submesh_path.height + spacing;
    
    yy = yy_base;
    
    var el_auto_bounds = create_button(col2_x, yy, "Auto-calculate bounds", ew, eh, fa_center, omu_mesh_auto_bounds, dg);
    el_auto_bounds.tooltip = "Automatically calculate the bounds of a mesh. Rounds to the nearest 32, i.e. [0, 0, 0] to [28, 36, 32] would be assigned bounds of [0, 0, 0] to [1, 1, 1].";
    yy += el_auto_bounds.height + spacing;
    
    var el_normal_flat = create_button(col2_x, yy, "Normals: Flat", ew, eh, fa_center, omu_mesh_normal_flat, dg);
    el_normal_flat.tooltip = "Flattens all normals in all submeshes mesh.";
    yy += el_normal_flat.height + spacing;
    
    var el_normal_smooth = create_button(col2_x, yy, "Normals: Smooth", ew, eh, fa_center, omu_mesh_normal_smooth, dg);
    el_normal_smooth.tooltip = "Smooths all normals in all submeshes. Note that this will have no effect until I finally go and implement smooth shading in a shader.";
    yy += el_normal_smooth.height + spacing;
    
    var el_up_axis = create_button(col2_x, yy, "Rotate Up Axis", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
            mesh_rotate_up_axis(mesh, i);
        }
        batch_again();
    }, dg);
    el_up_axis.tooltip = "Rotates the axes of all submeshes. Useful if you exported it from a 3D modelling program that insists on using Y+Up instead of Z+Up (cough cough, Blender).";
    yy += el_up_axis.height + spacing;
    
    yy = yy_base;
    
    var el_markers = create_list(col3_x, yy, "Extra Mesh Markers", "", ew, eh, 8, function(list) {
        var mesh = list.root.mesh;
        var selection = ds_map_to_list(list.selected_entries);
        mesh.flags = 0;
        for (var i = 0; i < ds_list_size(selection); i++) {
            mesh.flags |= (1 << selection[| i]);
        }
        ds_list_destroy(selection);
    }, true, dg);
    create_list_entries(el_markers, "Particle Mesh");
    el_markers.tooltip = "Some extra flags you can assign on a mesh that will have no bearing on how they're used in-game, but may be useful to you as the game designer.";
    el_markers.select_toggle = true;
    for (var i = 0; i < 32; i++) {
        if (mesh.flags & (1 << i)) {
            ui_list_select(el_markers, i);
        }
    }
    yy += ui_get_list_height(el_markers) + spacing;
    
    yy = yy_base;
    
    var el_text_all = create_text(col4_x, yy, "All Submeshes", ew, eh, fa_left, ew, dg);
    yy += el_text_all.height + spacing;
    
    var el_all_normal_flat = create_button(col4_x, yy, "Normals: Flat", ew, eh, fa_center, not_yet_implemented_polite, dg);
    el_all_normal_flat.tooltip = "Flattens all normals in every mesh in the data file.";
    yy += el_all_normal_flat.height + spacing;
    
    var el_all_normal_smooth = create_button(col4_x, yy, "Normals: Smooth", ew, eh, fa_center, not_yet_implemented_polite, dg);
    el_all_normal_smooth.tooltip = "Smooths all normals in every mesh in the data file. Note that this will have no effect until I finally go and implement smooth shading in a shader.";
    yy += el_all_normal_smooth.height + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_delete,
        el_replace,
        el_name,
        el_text_submesh_path,
        el_auto_bounds,
        el_normal_flat,
        el_normal_smooth,
        el_up_axis,
        el_markers,
        el_text_all,
        el_all_normal_flat,
        el_all_normal_smooth,
        el_confirm
    );
    
    return dg;
}