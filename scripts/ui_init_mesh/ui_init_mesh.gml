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
        var c2x = cw * 1.00 + spacing + spacing * 4;
        var c3x = cw * 2.00 + spacing + spacing * 4;
        var c4x = cw * 2.75 + spacing + spacing * 4;
        var c5x = cw * 3.50 + spacing + spacing * 4;
        
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
        
        var element = create_list(c1x, yy, "Meshes:", "no meshes", ew0, eh, 22, function(list) {
            var selection = list.selected_entries;
            if (ds_map_size(selection) == 0) {
                ui_input_set_value(list.root.mesh_name, "");
            } else if (ds_map_size(selection) == 1) {
                ui_input_set_value(list.root.mesh_name, Game.meshes[ds_map_find_first(selection)].name);
            } else {
                ui_input_set_value(list.root.mesh_name, "(multiple)");
            }
        }, true, id, Game.meshes);
        element.tooltip = "All of the 3D meshes currently loaded. You can drag them from Windows Explorer into the program window to add them in bulk. Middle-click the list to alphabetize the meshes.";
        element.render_colors = function(list, index) {
            return (Game.meshes[index].type == MeshTypes.SMF) ? c_red : c_black;
        };
        element.onmiddleclick = function(list) {
            array_sort_name(Game.meshes);
        }
        element.evaluate_text = function(list, index) {
            var mesh = list.entries[index];
            var prefix = "", suffix = "";
            if (mesh.flags & MeshFlags.PARTICLE) {
                prefix = "(p)" + prefix;
            }
            if (array_length(mesh.submeshes) == 1) {
                var buffer = mesh.submeshes[0].buffer;
                var reflect_buffer = mesh.submeshes[0].reflect_buffer;
                var buffer_size = (buffer ? buffer_get_size(buffer) : 0) / VERTEX_SIZE / 3;
                var reflect_buffer_size = (reflect_buffer ? buffer_get_size(reflect_buffer) : 0) / VERTEX_SIZE / 3;
                if (buffer_size == reflect_buffer_size || reflect_buffer_size == 0) {
                    suffix = " (" + string(buffer_size) + " triangles)";
                } else {
                    suffix = " (" + string(buffer_size) + " / " + string(reflect_buffer_size) + " triangles)";
                }
            } else {
                suffix = " (" + string(array_length(mesh.submeshes)) + " submeshes)";
            }
            return prefix + mesh.name + suffix;
        };
        element.entries_are = ListEntries.SCRIPT;
        mesh_list = element;
        ds_list_add(contents, element);
        yy += element.GetHeight() + spacing;
        
        element = create_button(c1x, yy, "Add Mesh", ew0, eh, fa_center, function(button) {
            var fn = get_open_filename_mesh();
            if (file_exists(fn)) {
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, undefined); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, undefined); break;
                    case ".smf": break;
                    case ".dae": import_dae(fn); break;
                }
            }
        }, id);
        element.tooltip = "Add a 3D mesh. You can drag them from Windows Explorer into the program window to add them in bulk.";
        element.file_dropper_action = function(thing, files) {
            var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".dae", ".smf", ".png", ".bmp", ".jpg", ".jpeg"]);
            for (var i = 0; i < array_length(filtered_list); i++) {
                var fn = filtered_list[i];
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, true); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, true); break;
                    case ".smf": break;
                    case ".dae": import_dae(fn); break;
                    case ".png": case ".bmp": case ".jpg": case ".jpeg": import_texture(fn); break;
                }
            }
        };
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_input(c1x, yy, "Name:", ew0, eh, function(input) {
            var selection = input.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].name = input.value;
            }
        }, "", "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, ew0, vy2, id);
        element.tooltip = "The name of the selected mesh(es).";
        mesh_name = element;
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Remove Mesh", ew0, eh, fa_center, function(button) {
            var list = button.root.mesh_list;
            var selection = list.selected_entries;
            // because when you delete stuff from the mesh list, the indices may
            // change, and if the indices change while you're in the middle of
            // deleting from it, things will get ugly
            var to_delete = [];
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                array_push(to_delete, Game.meshes[index]);
            }
            
            for (var i = 0; i < array_length(to_delete); i++) {
                to_delete[i].Destroy();
            }
            
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
                if (!first_mesh) first_mesh = Game.meshes[index];
                if (array_length(Game.meshes[index].submeshes) > 1) {
                    valid_count++;
                }
            }
            
            if (valid_count == 0) return;
            
            var dg = emu_dialog_confirm(button.root, "Would you like to combine the submeshes in " + ((valid_count == 1) ? first_mesh.name : (string(valid_count) + " meshes")) + "?", function() {
                var selection = self.root.selection;
                for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                    var mesh = Game.meshes[index];
                    if (array_length(mesh.submeshes) > 1) {
                        var old_submesh_list = mesh.submeshes;
                        mesh.submeshes = [];
                        mesh.proto_guids = { };
                        var combine_submesh = new MeshSubmesh(mesh.name + "!Combine");
                        
                        for (var i = 0, n = array_length(old_submesh_list); i < n; i++) {
                            combine_submesh.AddBufferData(old_submesh_list[i].buffer);
                            old_submesh_list[i].Destroy();
                        }
                        
                        combine_submesh.proto_guid = proto_guid_set(mesh, array_length(mesh.submeshes), undefined);
                        combine_submesh.owner = mesh;
                        array_push(mesh.submeshes, combine_submesh);
                        mesh.first_proto_guid = combine_submesh.proto_guid;
                    }
                }
                
                batch_again();
                self.root.Dispose();
            });
            
            dg.selection = selection;
        }, id);
        element.tooltip = "Combine the submeshes of the selected 3D meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Separate Submeshes", ew0, eh, fa_center, function(button) {
            var list = button.root.mesh_list;
            var selection = list.selected_entries;
            
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Game.meshes[index];
                if (array_length(mesh.submeshes) > 1) {
                    for (var i = 0, n = array_length(mesh.submeshes); i < n; i++) {
                        var new_mesh = new DataMesh(mesh.name + "!Separated" + string_pad(i, " ", 3));
                        var submesh = new_mesh.AddSubmesh(mesh.submeshes[i].Clone());
                        new_mesh.CopyPropertiesFrom(mesh);
                        array_push(Game.meshes, new_mesh);
                    }
                }
            }
        }, id);
        element.tooltip = "Separate the selected 3D meshes into individual models.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Export Selected", ew0, eh, fa_center, function(button) {
            var list = button.root.mesh_list;
            var selection = list.selected_entries;
            
            var export_count = ds_map_size(selection);
            if (export_count == 0) return;
            
            var fn;
            if (export_count == 1) {
                var mesh = Game.meshes[ds_map_find_first(selection)];
                fn = get_save_filename_mesh(mesh.name);
            } else {
                fn = get_save_filename_mesh("save everything here");
            }
            
            if (fn == "") return;
            var folder = filename_path(fn);
            
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Game.meshes[index];
                var name = (export_count == 1) ? fn : (folder + mesh.name + filename_ext(fn));
                switch (mesh.type) {
                    case MeshTypes.RAW:
                        switch (filename_ext(fn)) {
                            case ".obj": export_obj(name, mesh); break;
                            case ".d3d": case ".gmmod": export_d3d(name, mesh); break;
                            case ".vbuff": export_vb(name, mesh, Stuff.mesh_ed.vertex_format); break;
                        }
                        break;
                    case MeshTypes.SMF:
                        break;
                }
            }
        }, id);
        element.tooltip = @"Export the selected 3D meshes to the specified format. You can use this to convert from one 3D model format to another.
        
    You may convert to several different types of 3D model files.
    - [c_blue]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
    - [c_blue]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
    - [c_blue]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing. (You can define a vertex format to export the model with.)";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        element = create_button(c2x, yy, "Exported Vertex Format", ew, eh, fa_center, function(button) {
            emu_dialog_vertex_format(Stuff.mesh_ed.vertex_format, function(value) {
                Stuff.mesh_ed.vertex_format = value;
            });
        }, id);
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
        
        element = create_button(c2x, yy, "Apply Scale", ew, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionScale(Stuff.mesh_ed.draw_scale);
            }
            Stuff.mesh_ed.draw_scale = 1;
            ui_input_set_value(button.root.mesh_scale, string(Stuff.mesh_ed.draw_scale));
            batch_again();
        }, id);
        element.tooltip = "Apply the preview scale to the selected meshes. Useful for converting between different scale systems (1 unit = 1 meter vs 32 units = 1 meter, etc).";
        ds_list_add(contents, element);
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
        
        element = create_button(c2x, yy, "Rotate Up Axis", ew, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionRotateUpAxis();
            }
            batch_again();
        }, id);
        element.tooltip = "Rotate the \"up\" axis for the selected meshes. It would be nice if the world could standardize around either Y-up or Z-up, but that's never going to happen. https://xkcd.com/927/";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Mirror X Axis", ew / 3, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionMirrorX();
            }
            batch_again();
        }, id);
        element.tooltip = "Mirror the selected meshes over the X axis. Triangle vertex order will not be changed.";
        ds_list_add(contents, element);
        element = create_button(c2x + ew / 3, yy, "Mirror Y Axis", ew / 3, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionMirrorY();
            }
            batch_again();
        }, id);
        element.tooltip = "Mirror the selected meshes over the Y axis. Triangle vertex order will not be changed.";
        ds_list_add(contents, element);
        element = create_button(c2x + 2 * ew / 3, yy, "Mirror Z Axis", ew / 3, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionMirrorZ();
            }
            batch_again();
        }, id);
        element.tooltip = "Mirror the selected meshes over the Z axis. Triangle vertex order will not be changed.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Flip Texture U", ew / 2, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionFlipTexU();
            }
            batch_again();
        }, id);
        element.tooltip = "I don't actually know why you would need to do this, but it's here.";
        ds_list_add(contents, element);
        element = create_button(c2x + ew / 2, yy, "Flip Texture V", ew / 2, eh, fa_center, function(button) {
            var selection = button.root.mesh_list.selected_entries;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].ActionFlipTexV();
            }
            batch_again();
        }, id);
        element.tooltip = "Some 3D modelling programs insist on using the bottom-left of the texture image as the (0, 0) origin. We prefer the origin to be in the top-left. Use this button to flip the texture coordinates vertically.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Other tools...", ew, eh, fa_center, function(button) {
            if (ds_map_empty(button.root.mesh_list.selected_entries)) return;
            dialog_create_mesh_other_settings(button, button.root.mesh_list.selected_entries);
        }, id);
        element.tooltip = "Other misc operations you amy want to do on a mesh.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        element = create_render_surface(c3x, yy, ew * 2, ew * 1.8, ui_render_surface_render_mesh_ed, ui_render_surface_control_mesh_ed, c_black, id);
        ds_list_add(contents, element);
        
        element = create_render_surface(c3x, yy, ew * 2, ew * 1.8, function(surface, x1, y1, x2, y2) {
            var mode = Stuff.mesh_ed;
            if (!mode.draw_collision) return;
            
            surface.mask_surface = surface_rebuild(surface.mask_surface, surface.width, surface.height);
            surface_set_target(surface.mask_surface);
            draw_clear_alpha(c_black, 0);
            
            var cam = camera_get_active();
            camera_set_view_mat(cam, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
            camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-mode.fov, -surface.width / surface.height, CAMERA_ZNEAR, CAMERA_ZFAR));
            camera_apply(cam);
            
            shader_set(shd_solid_color);
            shader_set_uniform_f(shader_get_uniform(shd_solid_color, "col"), 1, 1, 1, 0.1);
            
            var mesh_list = surface.root.mesh_list;
            var n = 0;
            var limit = 10;
            var tex_none = -1;
            for (var index = ds_map_find_first(mesh_list.selected_entries); index != undefined; index = ds_map_find_next(mesh_list.selected_entries, index)) {
                var mesh_data = Game.meshes[index];
                
                for (var i = 0, len = array_length(mesh_data.collision_shapes); i < len; i++) {
                    var shape = mesh_data.collision_shapes[i];
                    switch (shape.type) {
                        case MeshCollisionShapes.BOX:
                            matrix_set(matrix_world, matrix_build(shape.position.x, shape.position.y, shape.position.z, shape.rotation.x, shape.rotation.y, shape.rotation.z, shape.scale.x, shape.scale.y, shape.scale.z));
                            vertex_submit(Stuff.graphics.centered_cube, pr_trianglelist, tex_none);
                            break;
                        case MeshCollisionShapes.CAPSULE:
                            // the capsule transformation isn't perfect but honestly i dont know if i can be bothered to do it right
                            matrix_set(matrix_world, matrix_build(shape.position.x, shape.position.y, shape.position.z, shape.rotation.x, shape.rotation.y, shape.rotation.z, shape.radius, shape.radius, shape.length));
                            vertex_submit(Stuff.graphics.centered_capsule, pr_trianglelist, tex_none);
                            break;
                        case MeshCollisionShapes.SPHERE:
                            matrix_set(matrix_world, matrix_build(shape.position.x, shape.position.y, shape.position.z, 0, 0, 0, shape.radius, shape.radius, shape.radius));
                            vertex_submit(Stuff.graphics.centered_sphere, pr_trianglelist, tex_none);
                            break;
                    }
                }
                
                if (++n > limit) break;
            }
            
            surface_reset_target();
            matrix_set(matrix_world, matrix_build_identity());
            shader_set(shd_outline);
            shader_set_uniform_f(shader_get_uniform(shd_outline, "outline_color"), colour_get_red(c_lime) / 0xff, colour_get_green(c_lime) / 0xff, colour_get_blue(c_lime) / 0xff);
            draw_clear_alpha(c_black, 0);
            draw_surface(surface.mask_surface, 0, 0);
            shader_reset();
        }, function() { }, c_black, id);
        element.mask_surface = surface_create(element.width, element.height);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        var yy_base_rs = yy;
        #region options
        element = create_checkbox(c3x, yy, "Draw filled meshes?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_meshes = checkbox.value;
        }, mode.draw_meshes, id);
        element.tooltip = "Draw the filled part of the 3D meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c3x, yy, "Draw wireframes?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_wireframes = checkbox.value;
        }, mode.draw_wireframes, id);
        element.tooltip = "Draw a wireframe over the 3D mesh. Turn this off if it gets annoying.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c3x, yy, "Draw reflections?", ew * 0.75, eh, function(checkbox) {
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
        
        element = create_checkbox(c4x, yy, "Show Textures?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_textures = checkbox.value;
        }, mode.draw_textures, id);
        element.tooltip = "Whether or not to draw the meshes in the preview window using a texture.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c4x, yy, "Show Lighting?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_lighting = checkbox.value;
        }, mode.draw_lighting, id);
        element.tooltip = "Whether or not to lighting should be enabled.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c4x, yy, "Show Back Faces?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_back_faces = checkbox.value;
        }, mode.draw_back_faces, id);
        element.tooltip = "For backface culling.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base_rs;
        
        element = create_checkbox(c5x, yy, "Show Grid?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_grid = checkbox.value;
        }, mode.draw_grid, id);
        element.tooltip = "Whether or not to draw the tile grid on the Z = 0 plane.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c5x, yy, "Show Axes?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_axes = checkbox.value;
        }, mode.draw_axes, id);
        element.tooltip = "Whether or not to draw the red, green, and blue axes in the 3D view.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_checkbox(c5x, yy, "Show collision?", ew * 0.75, eh, function(checkbox) {
            Stuff.mesh_ed.draw_collision = checkbox.value;
        }, mode.draw_collision, id);
        element.tooltip = "Whether or not to show collision shapes associated with meshes.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        #endregion
        return id;
    }
}