function dialog_create_mesh_advanced(root, mesh) {
    var dw = 1280;
    var dh = 560;
    
    var dg = dialog_create(dw, dh, "Advanced Mesh Options: " + mesh.name, dialog_default, dialog_destroy, root);
    dg.mesh = mesh;
    dg.type = 0;
    
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
                case ".smf": break;
            }
        }
        
        batch_again(undefined);
    }
    
    var el_list = create_list(col1_x, yy, mesh.name + " submeshes", "(none)", ew, eh, 10, function(list) {
        selection = ui_list_selection(list);
        ui_input_set_value(list.root.el_name, list.root.mesh.submeshes[selection].name);
    }, false, dg, mesh.submeshes);
    el_list.tooltip = "Each mesh can have a number of different sub-meshes. This can be used to give multiple meshes different visual skins, or to imitate primitive frame-based animation.";
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.ondoubleclick = replace_sub;
    ui_list_select(el_list, 0);
    dg.el_list = el_list;
    yy += el_list.GetHeight() + spacing;

    var el_add = create_button(col1_x, yy, "Add Sub-Mesh", ew, eh, fa_center, function(button) {
        var fn = get_open_filename_mesh();
        var mesh_data = button.root.mesh;
        // @todo try catch
        if (file_exists(fn)) {
            switch (filename_ext(fn)) {
                case ".obj": import_obj(fn, undefined, mesh_data); break;
                case ".d3d": case ".gmmod": import_d3d(fn, undefined, false, mesh_data); break;
                case ".smf": break;
            }
        }
    }, dg);
    el_add.file_dropper_action = function(thing, files) {
        var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".smf"]);
        for (var i = 0; i < array_length(filtered_list); i++) {
            var fn = filtered_list[i];
            switch (filename_ext(fn)) {
                case ".obj": import_obj(fn, true, false, thing.root.mesh); break;
                case ".d3d": case ".gmmod": import_d3d(fn, true, false, thing.root.mesh); break;
                case ".smf": break;
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
            if (array_length(mesh.submeshes) == 1) {
                emu_dialog_notice("Please don't delete the last submesh!");
            } else {
                mesh.RemoveSubmesh(selection);
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
            list.root.mesh.submeshes[selection].name = input.value;
        }
    }, mesh.submeshes[0].name, "Enter a name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "You don't have to, but it's generally helpful to give your submeshes names to identify them with.";
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    var text;
    if (mesh.submeshes[0].path == "") {
        text = "<no path saved>";
    } else {
        text = mesh.submeshes[0].path;
    }
    var el_text_submesh_path = create_text(col1_x, yy, text, ew * 1.5, eh, fa_left, ew * 1.5, dg);
    el_text_submesh_path.render = function(text, x, y) {
        var selection = ui_list_selection(text.root.el_list);
        var mesh_data = text.root.mesh;
        var base_text = text.text;
        
        var str = "";
        if (selection + 1) {
            if (mesh_data.submeshes[selection].path == "") {
                str = "<no path saved>";
            } else {
                str = mesh_data.submeshes[selection].path;
            }
        }
        
        if (string_width(str) <= text.wrap_width - text.offset) {
            text.text = str;
        } else {
            var prefix = string_copy(str, 1, 10) + "...   ";
            var prefix_width = string_width(prefix);
            text.text = "";
            for (var i = string_length(str); i > 0; i--) {
                text.text = string_char_at(str, i) + text.text;
                if (string_width(text.text) > (text.wrap_width - prefix_width - text.offset)) {
                    text.text = prefix + text.text;
                    break;
                }
            }
        }
        text.tooltip = str;
        
        ui_render_text(text, x, y);
        text.text = base_text;
    };
    yy += el_text_submesh_path.height + spacing;
    
    yy = yy_base;
    
    var f_attr_render = function(option, x, y) {
        option.state = option.root.value & option.value;
        ui_render_bitfield_option_text(option, x, y);
    };
    var f_attr_interact = function(option) {
        var mesh = option.root.root.mesh;
        mesh.flags ^= option.value;
        option.root.value ^= option.value;
    };
    
    var el_markers = create_bitfield(col2_x + col1_x, yy, "Mesh Attributes:", ew, eh, mesh.flags, dg);
    create_bitfield_options_vertical(el_markers, [
        create_bitfield_option_data(MeshFlags.PARTICLE, f_attr_render, f_attr_interact, "Particle Mesh", -1, 0, (ew - spacing) / 2, eh),
        create_bitfield_option_data(MeshFlags.SILHOUETTE, f_attr_render, f_attr_interact, "Player Silhouette", -1, 0, (ew - spacing) / 2, eh),
    ]);
    el_markers.tooltip = "Extra attributes you can assign to meshes.";
    
    yy = yy_base;
    
    var el_text_submesh = create_text(col3_x, yy, "This Submesh", ew, eh, fa_left, ew, dg);
    yy += el_text_submesh.height + spacing;
    
    var el_import_reflect  = create_button(col3_x, yy, "Import Reflection", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var submesh = mesh.submeshes[ui_list_selection(button.root.el_list)];
        if (submesh) {
            submesh.ImportReflection();
            batch_again(false);
        }
    }, dg);
    el_import_reflect.tooltip = "Import a reflection mesh.";
    yy += el_import_reflect.height + spacing;
    
    var el_auto_reflect = create_button(col3_x, yy, "Auto-Genreate Reflection", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var submesh = mesh.submeshes[ui_list_selection(button.root.el_list)];
        if (submesh) {
            submesh.GenerateReflections();
            batch_again(false);
        }
    }, dg);
    el_auto_reflect.tooltip = "Generate a reflection mesh for this submesh by flipping the model upside down over the XY plane.";
    yy += el_auto_reflect.height + spacing;
    
    var el_swap_reflect = create_button(col3_x, yy, "Swap Upright and Reflection", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var submesh = mesh.submeshes[ui_list_selection(button.root.el_list)];
        if (submesh) {
            submesh.SwapReflections();
            batch_again(false);
        }
    }, dg);
    el_swap_reflect.tooltip = "The upright mesh will become the reflection mesh, and vice versa.";
    yy += el_swap_reflect.height + spacing;
    
    var el_normal_flat = create_button(col3_x, yy, "Normals: Flat", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var submesh = mesh.submeshes[ui_list_selection(button.root.el_list)];
        if (submesh) {
            submesh.SetNormalsFlat();
        }
        batch_again(false);
    }, dg);
    el_normal_flat.tooltip = "Flattens all normals in all submeshes mesh.";
    yy += el_normal_flat.height + spacing;
    
    var el_normal_smooth = create_button(col3_x, yy, "Normals: Smooth", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var submesh = mesh.submeshes[ui_list_selection(button.root.el_list)];
        if (submesh) {
            submesh.SetNormalsSmooth(Settings.config.normal_threshold);
        }
        batch_again(false);
    }, dg);
    el_normal_smooth.tooltip = "Smooths all normals in all submeshes. Note that this will have no effect until I finally go and implement smooth shading in a shader.";
    yy += el_normal_smooth.height + spacing;
    
    var el_up_axis = create_button(col3_x, yy, "Rotate Up Axis", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        for (var i = 0; i < array_length(mesh.submeshes); i++) {
            mesh_rotate_up_axis(mesh, i);
        }
        batch_again(false);
    }, dg);
    el_up_axis.tooltip = "Rotates the axes of all submeshes. Useful if you exported it from a 3D modelling program that insists on using Y+Up instead of Z+Up (cough cough, Blender).";
    yy += el_up_axis.height + spacing;
    
    var el_reload = create_button(col3_x, yy, "Reload", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        var submesh = mesh.submeshes[ui_list_selection(button.root.el_list)];
        if (submesh) {
            submesh.Reload();
        }
        
        batch_again(false);
    }, dg);
    el_reload.tooltip = "Reload the submesh from its source file (if its source file still exists).";
    yy += el_reload.height + spacing;
    
    yy = yy_base;
    
    var el_text_all = create_text(col4_x, yy, "All Submeshes", ew, eh, fa_left, ew, dg);
    yy += el_text_all.height + spacing;
    
    var el_auto_reflect_all = create_button(col4_x, yy, "Auto-Genreate Reflection", ew, eh, fa_center, function(button) {
        button.root.mesh.GenerateReflections();
        batch_again(false);
    }, dg);
    el_auto_reflect_all.tooltip = "Generate a reflection mesh for all submeshes by flipping the model upside down over the XY plane.";
    yy += el_auto_reflect_all.height + spacing;
    
    var el_swap_reflect_all = create_button(col4_x, yy, "Swap Upright and Reflection", ew, eh, fa_center, function(button) {
        button.root.mesh.SwapReflections();
        batch_again(false);
    }, dg);
    el_swap_reflect_all.tooltip = "The upright mesh will become the reflection mesh, and vice versa.";
    yy += el_swap_reflect_all.height + spacing;
    
    var el_auto_bounds = create_button(col4_x, yy, "Auto-calculate bounds", ew, eh, fa_center, function(button) {
        var mesh = button.root.mesh;
        mesh.AutoCalculateBounds();
        ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.xmin, string(mesh.xmin));
        ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.ymin, string(mesh.ymin));
        ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.zmin, string(mesh.zmin));
        ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.xmax, string(mesh.xmax));
        ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.ymax, string(mesh.ymax));
        ui_input_set_value(Stuff.map.ui.t_p_mesh_editor.zmax, string(mesh.zmax));
    }, dg);
    el_auto_bounds.tooltip = "Automatically calculate the bounds of a mesh. Rounds to the nearest 32, i.e. [0, 0, 0] to [28, 36, 32] would be assigned bounds of [0, 0, 0] to [1, 1, 1].";
    yy += el_auto_bounds.height + spacing;
    
    var el_all_normal_flat = create_button(col4_x, yy, "Normals: Flat", ew, eh, fa_center, function(button) {
        button.root.mesh.SetNormalsFlat();
        batch_again(false);
    }, dg);
    el_all_normal_flat.tooltip = "Flattens all normals in every mesh in the data file.";
    yy += el_all_normal_flat.height + spacing;
    
    var el_all_normal_smooth = create_button(col4_x, yy, "Normals: Smooth", ew, eh, fa_center, function(button) {
        button.root.mesh.SetNormalsSmooth(Settings.config.normal_threshold);
        batch_again(false);
    }, dg);
    el_all_normal_smooth.tooltip = "Smooths all normals in every mesh in the data file. Note that this will have no effect until I finally go and implement smooth shading in a shader.";
    yy += el_all_normal_smooth.height + spacing;
    
    var el_all_reload = create_button(col4_x, yy, "Reload", ew, eh, fa_center, function(button) {
        button.root.mesh.Reload();
        batch_again(false);
    }, dg);
    el_all_reload.tooltip = "Reload all submeshes from their source file (if their source file exists).";
    yy += el_all_reload.height + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_delete,
        el_replace,
        el_name,
        el_text_submesh_path,
        el_text_submesh,
        el_import_reflect,
        el_auto_reflect,
        el_swap_reflect,
        el_auto_bounds,
        el_normal_flat,
        el_normal_smooth,
        el_up_axis,
        el_reload,
        el_markers,
        el_text_all,
        el_auto_reflect_all,
        el_swap_reflect_all,
        el_all_normal_flat,
        el_all_normal_smooth,
        el_all_reload,
        el_confirm
    );
    
    return dg;
}