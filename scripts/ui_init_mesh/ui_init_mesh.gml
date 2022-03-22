function ui_init_mesh(mode) {
    var hud_width = room_width / 4;
    var hud_height = room_height;
    var col1x = hud_width * 0 + 16;
    var col2x = hud_width * 1 + 16;
    var col3x = hud_width * 2 + 16;
    var col4x = hud_width * 3 + 16;
    var element_width = hud_width - 32;
    var element_height = 32;
    
    var container = new EmuCore(0, 16, hud_width, hud_height);
    
    container.AddContent([
        (new EmuList(col1x, EMU_BASE, element_width, element_height, "Meshes:", element_height, 25, function() {
            self.GetSibling("INFO").Refresh(self.GetAllSelectedIndices());
        }))
            .SetTooltip("All of the 3D meshes currently loaded. You can drag them from Windows Explorer into the program window to add them in bulk. Middle-click the list to alphabetize the meshes.")
            .SetMultiSelect(true)
            .SetListColors(function(index) {
                return (Game.meshes[index].type == MeshTypes.SMF) ? c_orange : EMU_COLOR_TEXT;
            })
            .SetCallbackMiddle(function() {
                array_sort_name(Game.meshes);
            })
            .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                var mesh = Game.meshes[index];
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
            })
            .SetRefresh(function(data) {
                self.SetList(Game.meshes);
            })
            .SetID("MESH LIST"),
        (new EmuCore(0, 0, hud_width, hud_height)).AddContent([
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Essentials"),
            #region essentials
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Name:", "", "name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].name = self.value;
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined);
                })
                .SetID("MESH NAME"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Add Mesh", function() {
                var fn = get_open_filename_mesh();
                if (file_exists(fn)) {
                    switch (filename_ext(fn)) {
                        case ".obj": import_obj(fn); break;
                        case ".d3d": case ".gmmod": import_d3d(fn); break;
                        case ".smf": break;
                        case ".dae": import_dae(fn); break;
                    }
                }
            }))
                .SetTooltip("Add a 3D mesh. You can drag them from Windows Explorer into the program window to add them in bulk.")
                .SetID("ADD MESH"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Delete Mesh", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                
                var dg = emu_dialog_confirm(self.root, "Would you like to delete " + (array_length(indices) == 1 ? Game.meshes[indices[0]] : " the selected meshes") + "?", function() {
                    var indices = self.root.indices;
                    
                    for (var i = 0, n = array_length(indices); i < n; i++) {
                        indices[i] = real(indices[i]);
                    }
                    
                    array_sort(indices, false);
                    
                    for (var i = 0, n = array_length(indices); i < n; i++) {
                        Game.meshes[real(indices[i])].Destroy();
                    }
                    batch_again();
                    Stuff.mesh_ed.ResetTransform();
                    self.root.Dispose();
                });
                
                dg.indices = indices;
                
                self.root.GetSibling("MESH LIST").Deselect();
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined);
                    if (data != undefined) {
                        if (array_length(data) == 1) {
                            self.text = "Delete Mesh";
                        } else {
                            self.text = "Delete Meshes";
                        }
                    }
                })
                .SetID("DELETE MESH"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Export Mesh", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                // to do once the rest of the editor works
                /*
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
                
                dg.indices = indices;
                */
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive((data != undefined) && (array_length(data) == 1));
                    if (data != undefined) {
                        if (array_length(data) == 1) {
                            self.text = "Export Mesh";
                        } else {
                            self.text = "Export Meshes";
                        }
                    }
                })
                .SetTooltip(@"Export the selected 3D meshes to the specified format. You can use this to convert from one 3D model format to another.
        
    You may convert to several different types of 3D model files.
    - [c_aqua]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
    - [c_aqua]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
    - [c_aqua]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing. (You can define a vertex format to export the model with.)")
                .SetID("EXPORT MESH"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Combine Submeshes", function() {
                var mesh = Game.meshes[self.root.GetSibling("MESH LIST").GetSelection()];
                
                var dg = emu_dialog_confirm(self.root, "Would you like to combine the submeshes in " + mesh.name + "?", function() {
                    var mesh = self.root.mesh;
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
                    
                    batch_again();
                    self.root.Dispose();
                });
                
                dg.mesh = mesh;
            }))
                .SetRefresh(function(data) {
                    if ((data != undefined) && (array_length(data) == 1)) {
                        self.SetInteractive(array_length(Game.meshes[real(data[0])].submeshes) > 1);
                    } else {
                        self.SetInteractive(false);
                    }
                })
                .SetTooltip("Combine the submeshes of the selected 3D meshes.")
                .SetID("COMBINE SUBMESHES"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Separate Submeshes", function() {
                var mesh = Game.meshes[self.root.GetSibling("MESH LIST").GetSelection()];
                
                var dg = emu_dialog_confirm(self.root, "Would you like to combine the submeshes in " + mesh.name + "?", function() {
                    var mesh = self.root.mesh;
                    
                    for (var i = 0, n = array_length(mesh.submeshes); i < n; i++) {
                        var new_mesh = new DataMesh(mesh.name + "!Separated" + string_pad(i, " ", 3));
                        var submesh = new_mesh.AddSubmesh(mesh.submeshes[i].Clone());
                        new_mesh.CopyPropertiesFrom(mesh);
                        array_push(Game.meshes, new_mesh);
                    }
                    
                    self.root.Dispose();
                });
                
                dg.mesh = mesh;
            }))
                .SetRefresh(function(data) {
                    if ((data != undefined) && (array_length(data) == 1)) {
                        self.SetInteractive(array_length(Game.meshes[real(data[0])].submeshes) > 1);
                    } else {
                        self.SetInteractive(false);
                    }
                })
                .SetTooltip("Separate the selected 3D meshes into individual models.")
                .SetID("SEPARATE SUBMESHES"),
            #endregion
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Basic Transformation"),
            #region basic transformation
            (new EmuInput(col2x, EMU_AUTO, element_width / 2, element_height, "Position:", "", "x", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_position.x = real(self.value);
            }))
                .SetID("MESH POSITION X"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 4, element_height, "", "", "y", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_position.y = real(self.value);
            }))
                .SetInputBoxPosition(0, 0)
                .SetID("MESH POSITION Y"),
            (new EmuInput(col2x + element_width * 3 / 4, EMU_INLINE, element_width / 4, element_height, "", "", "z", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_position.z = real(self.value);
            }))
                .SetInputBoxPosition(0, 0)
                .SetID("MESH POSITION Z"),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2, element_height, "Rotation:", "", "x", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_rotation.x = real(self.value);
            }))
                .SetID("MESH ROTATE X"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 4, element_height, "", "", "y", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_rotation.y = real(self.value);
            }))
                .SetInputBoxPosition(0, 0)
                .SetID("MESH ROTATE Y"),
            (new EmuInput(col2x + element_width * 3 / 4, EMU_INLINE, element_width / 4, element_height, "", "", "z", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_rotation.z = real(self.value);
            }))
                .SetInputBoxPosition(0, 0)
                .SetID("MESH ROTATE Z"),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2, element_height, "Scale:", "", "x", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_scale.x = real(self.value);
            }))
                .SetID("MESH SCALE X"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 4, element_height, "", "", "y", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_scale.y = real(self.value);
            }))
                .SetInputBoxPosition(0, 0)
                .SetID("MESH SCALE Y"),
            (new EmuInput(col2x + element_width * 3 / 4, EMU_INLINE, element_width / 4, element_height, "", "", "z", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_scale.z = real(self.value);
            }))
                .SetInputBoxPosition(0, 0)
                .SetID("MESH SCALE Z"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Bake Transformation", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                
                var dg = emu_dialog_confirm(self.root, "Would you like to apply the transformation to " + (array_length(indices) == 1 ? Game.meshes[indices[0]] : " the selected meshes") + "?", function() {
                    var indices = self.root.indices;
                    meshops_transform_set_inputs(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
                    for (var i = 0, n = array_length(indices); i < n; i++) {
                        Game.meshes[real(indices[i])].ApplyTransform();
                    }
                    batch_again();
                    Stuff.mesh_ed.ResetTransform();
                    self.root.Dispose();
                });
                
                dg.indices = indices;
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Apply the preview transformation to the selected meshes. Useful for converting between different world spaces.")
                .SetID("BAKE TRANSFORMATION"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Reset Transformation", function() {
                Stuff.mesh_ed.ResetTransform();
            }))
                .SetTooltip("Reset the transform used in the preview.")
                .SetID("RESET TRANSFORMATION"),
            #endregion
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Other Operations"),
            #region other operations
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Rotate Up Axis", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].ActionRotateUpAxis();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Rotate the \"up\" axis for the selected meshes. It would be nice if the world could standardize around either Y-up or Z-up, but that's never going to happen. https://xkcd.com/927/")
                .SetID("ROTATE UP AXIS"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 3, element_height, "Mirror X", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].ActionMirrorX();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Mirror the selected meshes over the X axis. Triangle vertex order will not be changed.")
                .SetID("MIRROR X"),
            (new EmuButton(col2x + element_width / 3, EMU_INLINE, element_width / 3, element_height, "Mirror Y", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].ActionMirrorY();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Mirror the selected meshes over the Y axis. Triangle vertex order will not be changed.")
                .SetID("MIRROR Y"),
            (new EmuButton(col2x + element_width * 2 / 3, EMU_INLINE, element_width / 3, element_height, "Mirror Z", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].ActionMirrorZ();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Mirror the selected meshes over the Z axis. Triangle vertex order will not be changed.")
                .SetID("MIRROR Z"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Flip Texture Horizontally", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].ActionFlipTexU();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("I don't actually know why you would need to do this, but...")
                .SetID("MIRROR TEX U"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Flip Texture Vertically", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    Game.meshes[real(indices[i])].ActionFlipTexV();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Some 3D modelling programs insist on using the bottom-left of the texture image as the (0, 0) origin. We prefer the origin to be in the top-left. Use this button to flip the texture coordinates vertically.")
                .SetID("MIRROR TEX V"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Materials", function() {
                dialog_create_mesh_material_settings(self, self.root.GetSibling("MESH LIST").GetAllSelectedIndices());
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Set some material properties used by the selected meshes. Right now I've only implemented the base (diffuse) texture but I'd like to get around to the rest later.")
                .SetID("MATERIALS"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "More...", function() {
                dialog_create_mesh_other_settings(self, self.root.GetSibling("MESH LIST").GetAllSelectedIndices());
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Other misc operations you amy want to do on a mesh.")
                .SetID("OTHER TOOLS"),
            new EmuRenderSurface(col3x, EMU_BASE, room_width - col3x - 16, room_width - col3x - 64, ui_render_surface_render_mesh_ed, ui_render_surface_control_mesh_ed, emu_null, emu_null),
            // this one is for the masks and overlays
            //new EmuRenderSurface(col3x, EMU_BASE, room_width - col3x - 16, room_width - col3x - 64, ui_render_surface_render_mesh_ed, ui_render_surface_control_mesh_ed, emu_null, emu_null),
            (new EmuButton(col3x, EMU_AUTO, element_width, element_height, "Viewer Settings", function() {
                var dialog = new EmuDialog(640, 600, "Mesh viewer settings");
                dialog.active_shade = 0;
                dialog.x = 920;
                dialog.y = 120;
                
                var col1x = 32;
                var col2x = 336;
                var col_width = 288;
                
                dialog.AddContent([
                    #region column 1
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw filled meshes?", Settings.mesh.draw_meshes, function() {
                        Settings.mesh.draw_meshes = self.value;
                    }))
                        .SetTooltip("Draw the filled part of the 3D meshes."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw textures?", Settings.mesh.draw_textures, function() {
                        Settings.mesh.draw_textures = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the meshes in the preview window using a texture."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw vertex colors?", Settings.mesh.draw_vertex_colors, function() {
                        Settings.mesh.draw_vertex_colors = self.value;
                        show_message("not yet implemented");
                    }))
                        .SetTooltip("Whether or not to colorize the verties of meshes."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw wireframes?", Settings.mesh.draw_wireframes, function() {
                        Settings.mesh.draw_wireframes = self.value;
                    }))
                        .SetTooltip("Draw a wireframe over the 3D mesh. Turn this off if it gets annoying."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw lighting?", Settings.mesh.draw_lighting, function() {
                        Settings.mesh.draw_lighting = self.value;
                    }))
                        .SetTooltip("Whether or not to lighting should be enabled."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw backfaces?", Settings.mesh.draw_back_faces, function() {
                        Settings.mesh.draw_back_faces = self.value;
                    }))
                        .SetTooltip("For backface culling."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw reflections?", Settings.mesh.draw_reflections, function() {
                        Settings.mesh.draw_reflections = self.value;
                    }))
                        .SetTooltip("If you have a reflection mesh set up, you may draw it, as well."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw collision?", Settings.mesh.draw_collision, function() {
                        Settings.mesh.draw_collision = self.value;
                    }))
                        .SetTooltip("Whether or not to show collision shapes associated with meshes."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw 3D axes?", Settings.mesh.draw_axes, function() {
                        Settings.mesh.draw_axes = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the red, green, and blue axes in the 3D view."),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw grid?", Settings.mesh.draw_grid, function() {
                        Settings.mesh.draw_grid = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the tile grid on the Z = 0 plane."),
                    #endregion
                    #region column 2
                    #endregion
                ]).AddDefaultCloseButton();
            }))
                .SetTooltip("Some options relating to the 3D view above.")
                .SetID("VIEWER SETTINGS"),
            #endregion
        ])
            .SetID("INFO")
    ]);
    
    return container;
    
    with (instance_create_depth(0, 0, 0, UIThing)) {
        element = create_button(c1x, yy, "Add Mesh", ew0, eh, fa_center, function(button) {
        }, id);
        element.tooltip = "";
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
        /*
        element = create_button(c2x, yy, "Exported Vertex Format", ew, eh, fa_center, function(button) {
            emu_dialog_vertex_format(Stuff.mesh_ed.vertex_format, function(value) {
                Stuff.mesh_ed.vertex_format = value;
            });
        }, id);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        */
    }
}