function ui_init_mesh(mode) {
    with (instance_create_depth(0, 0, 0, UIThing)) {
        var columns = 4;
        var spacing = 16;
        
        var cw = (room_width - columns * 32) / columns;
        var ew = cw - spacing * 2;
        var ew0 = cw + spacing * 2;
        var eh = 24;
        
        var c1x = cw * 0 + spacing;
        // the first column is a bit wider
        var c2x = cw * 1 + spacing + spacing * 4;
        var c3x = cw * 2 + spacing + spacing * 4;
        var c4x = cw * 3 + spacing + spacing * 4;
        
        var vx1 = ew / 2;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy_header = 64;
        var yy = 64 + eh;
        var yy_base = yy;
        
        var this_column = 0;
        var xx = this_column * cw + spacing;
        
        var create_vertex_format_editor = function(element) {
            var mode = Stuff.mesh_ed;
            var format_index = ui_list_selection(element.root.format_list);
            
            var dw = 720;
            var dh = 480;
            
            var dg = dialog_create(dw, dh, "Vertex Format Settings", dialog_default, dc_close_no_questions_asked, element);
            dg.format_index = format_index;
            
            var columns = 2;
            var ew = dw / columns - 64;
            var eh = 24;
            
            var vx1 = ew / 2;
            var vy1 = 0;
            var vx2 = ew;
            var vy2 = eh;
            
            var c1x = 0 * dw / columns + 32;
            var c2x = 1 * dw / columns + 32;
            var spacing = 16;
            
            var yy = 64;
            var yy_start = 64;
            
            var el_name = create_input(c1x, yy, "Name: ", ew, eh, function(input) {
                Stuff.mesh_ed.format_names[| input.root.format_index] = input.value;
            }, mode.format_names[| format_index], "string", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
            yy += el_name.height + spacing;
            
            var el_list = create_list(c1x, yy, "Attributes: ", "no attributes", ew, eh, 8, function(list) {
                var format = Stuff.mesh_ed.formats[| list.root.format_index];
                var index = ui_list_selection(list);
                if (!(index + 1)) return;
                ui_input_set_value(list.root.el_attribute_name, list.entries[| index]);
                var attribute = format[? "attributes"][| index];
                list.root.el_attribute_type.value = attribute[? "type"];
            }, false, dg);
            el_list.tooltip = "The vertex attributes to be included when you export meshes as vertex buffers. Each of the first 3D position, normal, texture coordinate and color will contain the values of the imported meshes; others will be initialized to zero.";
            dg.el_list = el_list;
            yy += ui_get_list_height(el_list) + spacing;
            
            var el_add = create_button(c1x, yy, "Add Attribute", ew, eh, fa_center, function(button) {
                var format = Stuff.mesh_ed.formats[| button.root.format_index];
                var attribute_name = "Attribute" + string(ds_list_size(button.root.el_list.entries));
                ds_list_add(button.root.el_list.entries, attribute_name);
                var attributes = format[? "attributes"];
                var new_attribute = ds_map_create();
                new_attribute[? "name"] = attribute_name;
                new_attribute[? "type"] = VertexFormatData.POSITION_3D;
                ds_list_add(attributes, new_attribute);
                ds_list_mark_as_map(attributes, ds_list_size(attributes) - 1);
            }, dg);
            el_list.tooltip = "Add a vertex attribute";
            yy += el_add.height + spacing;
            
            var el_remove = create_button(c1x, yy, "Remove Attribute", ew, eh, fa_center, function(button) {
                var format = Stuff.mesh_ed.formats[| button.root.format_index];
                var index = ui_list_selection(button.root.el_list);
                if (!(index + 1)) return;
                ds_list_delete(button.root.el_list.entries, index);
                var attributes = format[? "attributes"];
                ds_list_delete(attributes, index);
            }, dg);
            el_list.tooltip = "Remove a vertex attribute";
            yy += el_remove.height + spacing;
            
            yy = yy_start;
            
            var el_attribute_label = create_text(c2x, yy, "[c_blue]Attributes", ew, eh, fa_left, ew, dg);
            yy += el_name.height + spacing;
            
            var el_attribute_name = create_input(c2x, yy, "Name: ", ew, eh, function(input) {
                var list = input.root.el_list;
                var format = Stuff.mesh_ed.formats[| input.root.format_index];
                var index = ui_list_selection(list);
                if (!(index + 1)) return;
                list.entries[| index] = input.value;
                format[? "attributes"][| index][? "name"] = input.value;
            }, "", "string", validate_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
            el_list.tooltip = "The name of the vertex attribute (this is for your benefit and has no impact on how the mesh is exported)";
            dg.el_attribute_name = el_attribute_name;
            yy += el_attribute_name.height + spacing;
            
            var el_attribute_type = create_radio_array(c2x, yy, "Type:", ew, eh, function(radio) {
                var list = radio.root.root.el_list;
                var format = Stuff.mesh_ed.formats[| radio.root.root.format_index];
                var index = ui_list_selection(list);
                if (!(index + 1)) return;
                format[? "attributes"][| index][? "type"] = radio.value;
            }, -1, dg);
            el_attribute_type.tooltip = "The data type of the vertex attribute";
            create_radio_array_options(el_attribute_type, ["Position (2D)", "Position (3D)", "Normal", "Texture Coordinate", "Color", "Tangent", "Bitangent"]);
            dg.el_attribute_type = el_attribute_type;
            yy += ui_get_radio_array_height(el_attribute_type) + spacing;
            
            var format = mode.formats[| format_index];
            var attributes = format[? "attributes"];
            for (var i = 0; i < ds_list_size(attributes); i++) {
                var att = attributes[| i];
                ds_list_add(el_list.entries, att[? "name"]);
            }
            
            var b_width = 128;
            var b_height = 32;
            var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
            
            ds_list_add(dg.contents,
                el_name,
                el_list,
                el_add,
                el_remove,
                el_attribute_label,
                el_attribute_name,
                el_attribute_type,
                el_confirm
            );
            
            return dg;
        }
        
        var element = create_list(c1x, yy, "Meshes:", "no meshes", ew0, eh, 24, null, true, id, Stuff.all_meshes);
        element.tooltip = "All of the 3D meshes currently loaded. You can drag them from Windows Explorer into the program window to add them in bulk. Middle-click the list to alphabetize the meshes.";
        element.render_colors = function(list, index) {
            return (Stuff.all_meshes[| index].type == MeshTypes.SMF) ? c_red : c_black;
        };
        element.onmiddleclick = function(list) {
            ds_list_sort_name(Stuff.all_meshes);
        }
        element.evaluate_text = function(list, index) {
            var mesh = list.entries[| index];
            var prefix = "";
            if (mesh.flags & MeshFlags.PARTICLE) {
                prefix = "(p)" + prefix;
            }
            if (ds_list_size(mesh.submeshes) == 1) {
                var buffer = mesh.submeshes[| 0].buffer;
                var reflect_buffer = mesh.submeshes[| 0].reflect_buffer;
                var buffer_size = (buffer ? buffer_get_size(buffer) : 0) / VERTEX_SIZE / 3;
                var reflect_buffer_size = (reflect_buffer ? buffer_get_size(reflect_buffer) : 0) / VERTEX_SIZE / 3;
                if (buffer_size == reflect_buffer_size || reflect_buffer_size == 0) {
                    var suffix = " (" + string(buffer_size) + " triangles)";
                } else {
                    var suffix = " (" + string(buffer_size) + " / " + string(reflect_buffer_size) + " triangles)";
                }
            } else {
                var suffix = " (" + string(ds_list_size(mesh.submeshes)) + " submeshes)";
            }
            return prefix + mesh.name + suffix;
        };
        element.entries_are = ListEntries.SCRIPT;
        mesh_list = element;
        ds_list_add(contents, element);
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(c1x, yy, "Add Mesh", ew0, eh, fa_center, function(button) {
            var fn = get_open_filename_mesh();
            if (file_exists(fn)) {
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, undefined); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, undefined); break;
                    case ".vrax": import_vrax(fn); break;
                    case ".smf": import_smf(fn); break;
                    case ".qma": import_qma(fn); break;
                    case ".dae": import_dae(fn); break;
                }
            }
        }, id);
        element.tooltip = "Add a 3D mesh. You can drag them from Windows Explorer into the program window to add them in bulk.";
        element.file_dropper_action = function(thing, files) {
            var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".smf", ".png", ".bmp", ".jpg", ".jpeg"]);
            for (var i = 0; i < array_length(filtered_list); i++) {
                var fn = filtered_list[i];
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, true); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, true); break;
                    case ".smf": import_smf(fn);
                    case ".png": case ".bmp": case ".jpg": case ".jpeg": import_texture(fn); break;
                }
            }
        };
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Remove Mesh", ew0, eh, fa_center, function(button) {
            var list = button.root.mesh_list;
            var selection = list.selected_entries;
            // because mesh deleting is spaghetti
            var to_delete = ds_list_create();
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                ds_list_add(to_delete, Stuff.all_meshes[| index]);
            }
            
            for (var i = 0; i < ds_list_size(to_delete); i++) {
                instance_activate_object(to_delete[| i]);
                instance_destroy(to_delete[| i]);
            }
            
            ds_list_destroy(to_delete);
            ui_list_deselect(list);
            batch_again();
        }, id);
        element.tooltip = "Remove the selected 3D meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Combine Submeshes", ew0, eh, fa_center, function(button) {
            var list = button.root.mesh_list;
            var selection = list.selected_entries;
            var valid_count = 0;
            var first_mesh = undefined;
            
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                if (!first_mesh) first_mesh = Stuff.all_meshes[| index];
                if (ds_list_size(Stuff.all_meshes[| index].submeshes) > 1) {
                    valid_count++;
                }
            }
            
            if (valid_count == 0) return;
            
            var dg = dialog_create_yes_or_no(button.root, "Would you like to combine the submeshes in " + ((valid_count == 1) ? first_mesh.name : (string(valid_count) + " meshes")) + "?", function(button) {
                var selection = button.root.selection;
                for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                    var mesh = Stuff.all_meshes[| index];
                    if (ds_list_size(mesh.submeshes) > 1) {
                        var old_submesh_list = mesh.submeshes;
                        mesh.submeshes = ds_list_create();
                        mesh.proto_guids = { };
                        var combine_submesh = new MeshSubmesh(mesh.name + "!Combine");
                        
                        for (var i = 0, n = ds_list_size(old_submesh_list); i < n; i++) {
                            combine_submesh.AddBufferData(old_submesh_list[| i].buffer);
                            old_submesh_list[| i]._destructor();
                        }
                        
                        ds_list_destroy(old_submesh_list);
                        
                        combine_submesh.proto_guid = proto_guid_set(mesh, ds_list_size(mesh.submeshes), undefined);
                        combine_submesh.owner = mesh;
                        ds_list_add(mesh.submeshes, combine_submesh);
                        mesh.first_proto_guid = combine_submesh.proto_guid;
                    }
                }
                
                batch_again();
            });
            
            dg.selection = selection;
            
            dg.height -= 64;
            dg.el_confirm.y -= 64;
            dg.el_cancel.y -= 64;
            dg.el_text.y -= 32;
        }, id);
        element.tooltip = "Remove the selected 3D meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Export Selected", ew0, eh, fa_center, function(button) {
            var list = button.root.mesh_list;
            var selection = list.selected_entries;
            var format_index = ui_list_selection(button.root.format_list);
            var format = (format_index + 1) ? Stuff.mesh_ed.formats[| format_index] : undefined;

            var export_count = ds_map_size(selection);
            if (export_count == 0) return;

            if (export_count == 1) {
                var mesh = Stuff.all_meshes[| ds_map_find_first(selection)];
                var fn = get_save_filename_mesh(mesh.name);
            } else {
                var fn = get_save_filename_mesh("save everything here");
            }

            if (fn == "") return;
            var folder = filename_path(fn);
    
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                var name = (export_count == 1) ? fn : (folder + mesh.name + filename_ext(fn));
                switch (mesh.type) {
                    case MeshTypes.RAW:
                        switch (filename_ext(fn)) {
                            case ".obj": export_obj(name, mesh, false); break;
                            case ".d3d": case ".gmmod": export_d3d(name, mesh); break;
                            case ".vbuff": export_vb(name, mesh, format); break;
                        }
                        break;
                    case MeshTypes.SMF:
                        export_smf(name, mesh);
                        break;
                }
            }
        }, id);
        element.tooltip = @"Export the selected 3D meshes to the specified format. You can use this to convert from one 3D model format to another.
        
    You may convert to several different types of 3D model files.
    - [c_blue]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
    - [c_blue]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
    - [c_blue]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing. (You can define a vertex format to export the model with.)
    If you loaded a model containing SMF data, it will be saved as is without conversion.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        element = create_text(c2x, yy, "[c_blue]Vertex Formats", ew, eh, fa_left, ew, id);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_list(c2x, yy, "Available Vertex Formats", "no vertex formats", ew, eh, 6, null, false, id, mode.format_names);
        element.tooltip = "Vertex formats available to be exported to. Extra fields beyond the original position / normal / texture / color will be set to zero.";
        element.ondoubleclick = create_vertex_format_editor;
        ds_list_add(contents, element);
        format_list = element;
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(c2x, yy, "Add Vertex Format", ew, eh, fa_center, function(button) {
            var mode = Stuff.mesh_ed;
            ds_list_add(mode.format_names, "Format" + string(ds_list_size(mode.format_names)));
            var abuffer = buffer_load("data\\vertex-format-attributes.json");
            ds_list_add(mode.formats, json_decode(buffer_read(abuffer, buffer_text)));
            buffer_delete(abuffer);
            ds_list_mark_as_map(mode.formats, ds_list_size(mode.formats) - 1);
        }, id);
        element.tooltip = "Mirror the selected meshes over the Z axis.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Edit Vertex Format", ew, eh, fa_center, create_vertex_format_editor, id);
        element.tooltip = "Mirror the selected meshes over the Z axis.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Remove Vertex Format", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.format_list);
            ds_list_delete(Stuff.mesh_ed.formats, selection);
            ds_list_delete(Stuff.mesh_ed.format_names, selection);
        }, id);
        element.tooltip = "Mirror the selected meshes over the Z axis.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_text(c2x, yy, "[c_blue]Editing", ew, eh, fa_left, ew, id);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_input(c2x, yy, "Scale:", ew, eh, function(input) {
            Stuff.mesh_ed.draw_scale = real(input.value);
        }, mode.draw_scale, "float", validate_double, 0.01, 100, 5, vx1, vy1, vx2, vy2, id);
        element.tooltip = "Set the scale used by the preview on the right. If you want to apply the scale to the selected meshes permanently, click the button below.";
        ds_list_add(contents, element);
        mesh_scale = element;
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Apply Scale", ew, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                mesh_set_all_scale(mesh, Stuff.mesh_ed.draw_scale);
            }
            Stuff.mesh_ed.draw_scale = 1;
            ui_input_set_value(button.root.mesh_scale, string(Stuff.mesh_ed.draw_scale));
            batch_again();
        }, id);
        element.tooltip = "Apply the preview scale to the selected meshes. Useful for converting between different scale systems (1 unit = 1 meter vs 32 units = 1 meter, etc).";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_input(c2x, yy, "Rotation (X):", ew, eh, function(input) {
            Stuff.mesh_ed.draw_rot_x = real(input.value);
        }, mode.draw_rot_x, "float", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, id);
        element.tooltip = "Rotate the model(s) drawn in the preview window around the X axis.";
        ds_list_add(contents, element);
        mesh_rot_x = element;
        yy += element.height + spacing;
        
        element = create_input(c2x, yy, "Rotation (Y):", ew, eh, function(input) {
            Stuff.mesh_ed.draw_rot_y = real(input.value);
        }, mode.draw_rot_y, "float", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, id);
        element.tooltip = "Rotate the model(s) drawn in the preview window around the Y axis.";
        ds_list_add(contents, element);
        mesh_rot_y = element;
        yy += element.height + spacing;
        
        element = create_input(c2x, yy, "Rotation (Z):", ew, eh, function(input) {
            Stuff.mesh_ed.draw_rot_z = real(input.value);
        }, mode.draw_rot_z, "float", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, id);
        element.tooltip = "Rotate the model(s) drawn in the preview window around the Z axis.";
        ds_list_add(contents, element);
        mesh_rot_z = element;
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Reset Transform", ew, eh, fa_center, function(button) {
            Stuff.mesh_ed.draw_scale = 1;
            ui_input_set_value(button.root.mesh_scale, string(Stuff.mesh_ed.draw_scale));
            Stuff.mesh_ed.draw_rot_x = 0;
            ui_input_set_value(button.root.mesh_rot_x, string(Stuff.mesh_ed.draw_rot_x));
            Stuff.mesh_ed.draw_rot_y = 0;
            ui_input_set_value(button.root.mesh_rot_y, string(Stuff.mesh_ed.draw_rot_y));
            Stuff.mesh_ed.draw_rot_z = 0;
            ui_input_set_value(button.root.mesh_rot_z, string(Stuff.mesh_ed.draw_rot_z));
        }, id);
        element.tooltip = "Reset the transform used in the preview.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Rotate Up Axis", ew / 2, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                mesh_rotate_all_up_axis(mesh);
            }
            batch_again();
        }, id);
        element.tooltip = "Rotate the \"up\" axis for the selected meshes. It would be nice if the world could standardize around either Y-up or Z-up, but that's never going to happen.";
        ds_list_add(contents, element);
        element = create_button(c2x + ew / 2, yy, "Invert Transparency", ew / 2, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                mesh_all_invert_alpha(mesh);
            }
            batch_again();
        }, id);
        element.tooltip = "Because literally nothing is standard with the OBJ file format, sometimes the \"Tr\" material attribute is \"transparency,\" and sometimes it's \"opacity.\" Click here to toggle between them.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Mirror X Axis", ew / 3, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                mesh_mirror_all_x(mesh);
            }
            batch_again();
        }, id);
        element.tooltip = "Mirror the selected meshes over the X axis. Triangle vertex order will not be changed.";
        ds_list_add(contents, element);
        element = create_button(c2x + ew / 3, yy, "Mirror Y Axis", ew / 3, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                mesh_mirror_all_y(mesh);
            }
            batch_again();
        }, id);
        element.tooltip = "Mirror the selected meshes over the Y axis. Triangle vertex order will not be changed.";
        ds_list_add(contents, element);
        element = create_button(c2x + 2 * ew / 3, yy, "Mirror Z Axis", ew / 3, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Stuff.all_meshes[| index];
                mesh_mirror_all_z(mesh);
            }
            batch_again();
        }, id);
        element.tooltip = "Mirror the selected meshes over the Z axis. Triangle vertex order will not be changed.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Flip Texture U", ew / 2, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                mesh_set_all_flip_tex_h(Stuff.all_meshes[| index]);
            }
            batch_again();
        }, id);
        element.tooltip = "I don't actually know why you would need to do this, but it's here.";
        ds_list_add(contents, element);
        element = create_button(c2x + ew / 2, yy, "Flip Texture V", ew / 2, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                mesh_set_all_flip_tex_v(Stuff.all_meshes[| index]);
            }
            batch_again();
        }, id);
        element.tooltip = "Some 3D modelling programs insist on using the bottom-left of the texture image as the (0, 0) origin. We prefer the origin to be in the top-left. Use this button to flip the texture coordinates vertically.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Normals", ew, eh, fa_center, function(button) {
            if (ds_map_empty(button.root.mesh_list.selected_entries)) return;
            dialog_create_mesh_normal_settings(button, button.root.mesh_list.selected_entries);
        }, id);
        element.tooltip = "Adjust the vertex normals of the selected meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        element = create_render_surface(c3x, yy, ew * 2, ew * 1.8, ui_render_surface_render_mesh_ed, ui_render_surface_control_mesh_ed, c_black, id);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        var yy_base_rs = yy;
        #region options
        element = create_checkbox(c3x, yy, "Draw filled meshes?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_meshes = checkbox.value;
        }, mode.draw_meshes, id);
        element.tooltip = "Draw the filled part of the 3D meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c3x, yy, "Draw wireframes?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_wireframes = checkbox.value;
        }, mode.draw_wireframes, id);
        element.tooltip = "Draw a wireframe over the 3D mesh. Turn this off if it gets annoying.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c3x, yy, "Draw reflections?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_reflections = checkbox.value;
        }, mode.draw_wireframes, id);
        element.tooltip = "If you have a reflection mesh set up, you may draw it, as well.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c3x, yy, "Object Materials...", ew, eh, fa_center, function(button) {
            if (ds_map_empty(button.root.mesh_list.selected_entries)) return;
            dialog_create_mesh_material_settings(button, button.root.mesh_list.selected_entries);
        }, id);
        element.tooltip = "Set the textures used by the selected meshes. Only the base texture is available for now; I may implement the others later.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base_rs;
        
        element = create_checkbox(c4x, yy, "Show Textures?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_textures = checkbox.value;
        }, mode.draw_textures, id);
        element.tooltip = "Whether or not to draw the meshes in the preview window using a texture.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c4x, yy, "Show Lighting?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_lighting = checkbox.value;
        }, mode.draw_lighting, id);
        element.tooltip = "Whether or not to lighting should be enabled.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c4x, yy, "Show Axes?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_axes = checkbox.value;
        }, mode.draw_axes, id);
        element.tooltip = "Whether or not to draw the red, green, and blue axes in the 3D view.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c4x, yy, "Show Back Faces?", ew, eh, function(checkbox) {
            Stuff.mesh_ed.draw_back_faces = checkbox.value;
        }, mode.draw_back_faces, id);
        element.tooltip = "For backface culling.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        #endregion
        return id;
    }
}