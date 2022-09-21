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
    
    container.GetMeshType = method(container, function() {
        return (self.GetChild("LIST TYPE").value == 0) ? Game.meshes : Game.mesh_terrain;
    });
    
    container.AddContent([
        new EmuFileDropperListener(function(files) {
            debug_timer_start();
            var filter_array = [".d3d", ".gmmod", ".obj", ".mtl", ".png", ".bmp", ".jpg", ".jpeg"];
            // we can add these back in later when they're working
            if (!IS_MESH_MODE) {
                array_push(filter_array, ".dae", ".smf");
            }
            var filtered_list = self.Filter(files, filter_array);
            if (array_length(filtered_list) > 0) {
                self.GetSibling("MESH LIST").Deselect();
            }
            // if you drag an obj and the mtl that it belongs to into the
            // editor, you usually don't want to load it twice
            var obj_cache = { };
            for (var i = array_length(filtered_list) - 1; i >= 0; i--) {
                if (filename_ext(filtered_list[i]) == ".mtl" || filename_ext(filtered_list[i]) == ".obj") {
                    if (obj_cache[$ filename_change_ext(filtered_list[i], "")]) {
                        array_delete(filtered_list, i, 1);
                        continue;
                    }
                    obj_cache[$ filename_change_ext(filtered_list[i], "")] = true;
                }
            }
            var n = 0;
            for (var i = 0; i < array_length(filtered_list); i++) {
                // try to import the file as a 3D mesh; if that doesn't work,
                // import it as a texture instead
                switch (string_lower(filename_ext(filtered_list[i]))) {
                    case ".d3d":
                    case ".gmmod":
                    case ".obj":
                    case ".mtl":
                    case ".dae":
                    case ".smf":
                        import_mesh(filtered_list[i]);
                        n++;
                        break;
                    default:
                        import_texture(filtered_list[i]);
                        break;
                }
            }
            if (n > 0) {
                Stuff.AddStatusMessage("Importing " + string(n) + " meshes took " + debug_timer_finish());
            }
        }),
        (new EmuList(col1x, EMU_BASE, element_width, element_height, "Meshes:", element_height, (!IS_MESH_MODE) ? 22 : 24, function() {
            self.GetSibling("INFO").Refresh(self.GetAllSelectedIndices());
        }))
            .SetTooltip("All of the 3D meshes currently loaded. You can drag them from Windows Explorer into the program window to add them in bulk. Middle-click the list to alphabetize the meshes.")
            .SetMultiSelect(true)
            .SetListColors(function(index) {
                return (self.GetSibling("MESH LIST").At(index).type == MeshTypes.SMF) ? c_orange : EMU_COLOR_TEXT;
            })
            .SetCallbackMiddle(function() {
                array_sort_name(self.root.GetMeshType());
            })
            .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                var mesh = self.At(index);
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
                    var bytes = 0;
                    for (var i = 0, n = array_length(mesh.submeshes); i < n; i++) {
                        if (buffer_exists(mesh.submeshes[i].buffer)) {
                            bytes += buffer_get_size(mesh.submeshes[i].buffer);
                        }
                    }
                    suffix = " (" + string(array_length(mesh.submeshes)) + " submeshes, " + string(bytes / VERTEX_SIZE / 3) + " triangles)";
                }
                return prefix + mesh.name + suffix;
            })
            .SetRefresh(function(data) {
                self.SetList(self.root.GetMeshType());
            })
            .SetListColors(emu_color_meshes)
            .SetID("MESH LIST"),
        (new EmuRadioArray(col1x, EMU_AUTO, element_width, element_height, "Type:", 0, function() {
            self.GetSibling("MESH LIST").SetList(self.root.GetMeshType());
            if (self.value == 0) {
                self.GetSibling("MESH LIST").SetListColors(emu_color_meshes);
            } else {
                self.GetSibling("MESH LIST").SetListColors(function(index) { return EMU_COLOR_TEXT; });
            }
        }))
            .AddOptions(["Standard", "Terrain"])
            .SetColumns(1, element_width / 2)
            .SetEnabled(!IS_MESH_MODE)
            .SetID("LIST TYPE"),
        (new EmuCore(0, 0, hud_width, hud_height)).AddContent([
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Essentials"),
            #region essentials
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Name:", "", "name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).name = self.value;
                }
                batch_again();
            }))
                .SetInputBoxPosition(element_width / 4)
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined);
                    self.SetValue((data != undefined && array_length(data) == 1) ? self.root.GetSibling("MESH LIST").At(data[0]).name : "");
                })
                .SetID("MESH NAME"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Add Mesh", function() {
                debug_timer_start();
                if (import_mesh(get_open_filename_mesh())) {
                    self.root.GetSibling("MESH LIST").Deselect();
                    self.root.GetSibling("MESH LIST").Select(array_length(Game.meshes) - 1, true);
                    Stuff.AddStatusMessage("Importing mesh took " + debug_timer_finish());
                }
            }))
                .SetTooltip("Add a 3D mesh. You can drag them from Windows Explorer into the program window to add them in bulk.")
                .SetID("ADD MESH"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Delete Mesh", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                
                var dg = emu_dialog_confirm(self.root, "Would you like to delete " + ((array_length(indices) == 1) ? self.root.GetSibling("MESH LIST").At(indices[0]).name : " the selected meshes") + "?", function() {
                    var selection = { };
                    
                    for (var i = 0, n = array_length(self.root.indices); i < n; i++) {
                        // this is fine
                        variable_struct_set(selection, string(ptr(self.root.type[self.root.indices[i]])), true);
                        // this errors
                        //selection[$ "!" + string(ptr(self.root.type[self.root.indices[i]]))] = true;
                    }
                    
                    for (var i = array_length(self.root.type) - 1; i >= 0; i--) {
                        // gamemaker why are you like this
                        //if (selection[$ "!" + string(ptr(self.root.type[i]))]) {
                        if (variable_struct_exists(selection, string(ptr(self.root.type[i])))) {
                            self.root.type[i].Destroy();
                        }
                    }
                    
                    batch_again();
                    self.root.Dispose();
                    //Stuff.mesh.ResetTransform();
                    Stuff.mesh.ui.GetChild("MESH LIST").Deselect();
                    batch_again();
                });
                
                dg.indices = indices;
                dg.type = Stuff.mesh.ui.GetMeshType();
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
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Export Mesh", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                
                var fn;
                if (array_length(indices) == 1) {
                    fn = get_save_filename_mesh_full(self.root.GetSibling("MESH LIST").At(indices[0]).name);
                } else {
                    fn = get_save_filename_mesh_full("save everything here");
                }
                
                if (fn == "") return;
                var folder = filename_path(fn);
                
                if (filename_ext(fn) == ".derg") {
                    var meshes = array_create(array_length(indices));
                    for (var i = 0, n = array_length(indices); i < n; i++) {
                        meshes[i] = self.root.GetSibling("MESH LIST").At(indices[i]);
                    }
                    export_derg(fn, meshes, IS_MESH_MODE ? Game.meta.export.vertex_format : Stuff.mesh.vertex_format);
                } else {
                    for (var i = 0, n = array_length(indices); i < n; i++) {
                        var mesh = self.root.GetSibling("MESH LIST").At(indices[i]);
                        var name = (array_length(indices) == 1) ? fn : (folder + mesh.name + filename_ext(fn));
                        switch (mesh.type) {
                            case MeshTypes.RAW:
                                switch (filename_ext(fn)) {
                                    case ".obj": export_obj(name, mesh); break;
                                    case ".d3d": case ".gmmod": export_d3d(name, mesh); break;
                                    case ".vbuff": export_vb(name, mesh, Stuff.mesh.vertex_format); break;
                                }
                                break;
                            case MeshTypes.SMF:
                                break;
                        }
                    }
                }
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive((data != undefined) && (array_length(data) > 0));
                    if (array_length(data) == 1) {
                        self.text = "Export Mesh";
                    } else {
                        self.text = "Export Meshes";
                    }
                })
                .SetTooltip(@"Export the selected 3D meshes to the specified format. You can use this to convert from one 3D model format to another.
        
    You may convert to several different types of 3D model files.
    - [c_aqua]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
    - [c_aqua]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
    - [c_aqua]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing. (You can define a vertex format to export the model with.)")
                .SetID("EXPORT MESH"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Vertex Format", function() {
                emu_dialog_vertex_format(IS_MESH_MODE ? Game.meta.export.vertex_format : Stuff.mesh.vertex_format, function(value) {
                    if (IS_MESH_MODE) {
                        Game.meta.export.vertex_format = value;
                    } else {
                        Stuff.mesh.vertex_format = value;
                    }
                });
            }))
                .SetTooltip("Define the vertex format used for exporting vertex buffers"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Combine Submeshes", function() {
                var meshes = self.root.GetSibling("MESH LIST").GetAllSelectedItems();
                
                var dg = emu_dialog_confirm(self.root, "Would you like to combine the submeshes in " + ((array_length(meshes) == 1) ? meshes[0].name : "the selected submeshes") + "?", function() {
                    debug_timer_start();
                    
                    for (var i = 0, n = array_length(self.root.meshes); i < n; i++) {
                        var mesh = self.root.meshes[i];
                        if (array_length(mesh.submeshes) == 1) continue;
                        
                        var old_submesh_list = mesh.submeshes;
                        mesh.submeshes = [];
                        mesh.proto_guids = { };
                        var combine_submesh = new MeshSubmesh(mesh.name + "!Combine");
                        
                        for (var j = 0, n2 = array_length(old_submesh_list); j < n2; j++) {
                            combine_submesh.AddBufferData(old_submesh_list[j].buffer);
                            old_submesh_list[j].Destroy();
                        }
                        
                        combine_submesh.proto_guid = proto_guid_set(mesh, array_length(mesh.submeshes), undefined);
                        combine_submesh.owner = mesh;
                        array_push(mesh.submeshes, combine_submesh);
                        mesh.first_proto_guid = combine_submesh.proto_guid;
                    }
                    
                    batch_again();
                    Stuff.AddStatusMessage("Combining the submesh took " + debug_timer_finish());
                    self.root.Dispose();
                    Stuff.mesh.ui.SearchID("COMBINE SUBMESHES").Refresh(Stuff.mesh.ui.SearchID("MESH LIST").GetAllSelectedIndices());
                    Stuff.mesh.ui.SearchID("SEPARATE SUBMESHES").Refresh(Stuff.mesh.ui.SearchID("MESH LIST").GetAllSelectedIndices());
                });
                
                dg.meshes = meshes;
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(false);
                    if (data == undefined) return;
                    for (var i = 0, n = array_length(data); i < n; i++) {
                        if (array_length(self.root.GetSibling("MESH LIST").At(real(data[0])).submeshes) > 1) {
                            self.SetInteractive(true);
                            return;
                        }
                    }
                })
                .SetTooltip("Combine the submeshes of the selected 3D meshes.")
                .SetID("COMBINE SUBMESHES"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Separate Submeshes", function() {
                var meshes = self.root.GetSibling("MESH LIST").GetAllSelectedItems();
                
                var dg = emu_dialog_confirm(self.root, "Would you like to separate the submeshes in " + ((array_length(meshes) == 1) ? meshes[0].name : "the selected submeshes") + "?", function() {
                    for (var i = 0, n = array_length(self.root.meshes); i < n; i++) {
                        var mesh = self.root.meshes[i];
                        if (array_length(mesh.submeshes) == 1) continue;
                        // if you wanted to separate the submeshes without
                        // keeping the original you could literally just
                        // move the submesh objects around, but i'd like to
                        // keep the originals
                        for (var j = 0, n2 = array_length(mesh.submeshes); j < n2; j++) {
                            var new_mesh = new DataMesh(mesh.name + "!Separated" + string_pad(j, " ", 3));
                            var submesh = new_mesh.AddSubmesh(mesh.submeshes[j].Clone());
                            new_mesh.CopyPropertiesFrom(mesh);
                            array_push(Stuff.mesh.ui.GetMeshType(), new_mesh);
                        }
                    }
                    
                    self.root.Dispose();
                    Stuff.mesh.ui.SearchID("COMBINE SUBMESHES").Refresh(Stuff.mesh.ui.SearchID("MESH LIST").GetAllSelectedIndices());
                    Stuff.mesh.ui.SearchID("SEPARATE SUBMESHES").Refresh(Stuff.mesh.ui.SearchID("MESH LIST").GetAllSelectedIndices());
                });
                
                dg.meshes = meshes;
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(false);
                    if (data == undefined) return;
                    for (var i = 0, n = array_length(data); i < n; i++) {
                        if (array_length(self.root.GetSibling("MESH LIST").At(real(data[0])).submeshes) > 1) {
                            self.SetInteractive(true);
                            return;
                        }
                    }
                })
                .SetTooltip("Separate the selected 3D meshes into individual models.")
                .SetID("SEPARATE SUBMESHES"),
            #endregion
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Basic Transformation"),
            #region basic transformation
            (new EmuInput(col2x, EMU_AUTO, element_width / 2, element_height, "Position:", string(Settings.mesh.draw_position.x), "x", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_position.x = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_position.x));
                })
                .SetRealNumberBounds(-250, 250)
                .SetID("MESH POSITION X")
                .SetNext("MESH POSITION Y").SetPrevious("MESH SCALE Z"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 4, element_height, string(Settings.mesh.draw_position.y), "", "y", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_position.y = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_position.y));
                })
                .SetRealNumberBounds(-250, 250)
                .SetInputBoxPosition(0, 0)
                .SetID("MESH POSITION Y")
                .SetNext("MESH POSITION Z").SetPrevious("MESH POSITION X"),
            (new EmuInput(col2x + element_width * 3 / 4, EMU_INLINE, element_width / 4, element_height, string(Settings.mesh.draw_position.z), "", "z", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_position.z = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_position.z));
                })
                .SetRealNumberBounds(-250, 250)
                .SetInputBoxPosition(0, 0)
                .SetID("MESH POSITION Z")
                .SetNext("MESH ROTATE X").SetPrevious("MESH POSITION Y"),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2, element_height, "Rotation:", string(Settings.mesh.draw_rotation.x), "x", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_rotation.x = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_rotation.x));
                })
                .SetRealNumberBounds(-360, 360)
                .SetID("MESH ROTATE X")
                .SetNext("MESH ROTATE Y").SetPrevious("MESH POSITION Z"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 4, element_height, string(Settings.mesh.draw_rotation.y), "", "y", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_rotation.y = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_rotation.y));
                })
                .SetRealNumberBounds(-360, 360)
                .SetInputBoxPosition(0, 0)
                .SetID("MESH ROTATE Y")
                .SetNext("MESH ROTATE Z").SetPrevious("MESH ROTATE X"),
            (new EmuInput(col2x + element_width * 3 / 4, EMU_INLINE, element_width / 4, element_height, string(Settings.mesh.draw_rotation.z), "", "z", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_rotation.z = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_rotation.z));
                })
                .SetRealNumberBounds(-360, 360)
                .SetInputBoxPosition(0, 0)
                .SetID("MESH ROTATE Z")
                .SetNext("MESH SCALE X").SetPrevious("MESH ROTATE Y"),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2, element_height, "Scale:", string(Settings.mesh.draw_scale.x), "x", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_scale.x = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_scale.x));
                })
                .SetID("MESH SCALE X")
                .SetNext("MESH SCALE Y").SetPrevious("MESH ROTATE Z"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 4, element_height, string(Settings.mesh.draw_scale.y), "", "y", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_scale.y = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_scale.y));
                })
                .SetInputBoxPosition(0, 0)
                .SetID("MESH SCALE Y")
                .SetNext("MESH SCALE Z").SetPrevious("MESH SCALE X"),
            (new EmuInput(col2x + element_width * 3 / 4, EMU_INLINE, element_width / 4, element_height, string(Settings.mesh.draw_scale.z), "", "z", 10, E_InputTypes.REAL, function() {
                Settings.mesh.draw_scale.z = real(self.value);
            }))
                .SetRefresh(function(data) {
                    self.SetValue(string(Settings.mesh.draw_scale.z));
                })
                .SetInputBoxPosition(0, 0)
                .SetID("MESH SCALE Z")
                .SetNext("MESH POSITION X").SetPrevious("MESH SCALE Y"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Bake Transformation", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                
                // expensive operation, don't do unless you have to
                if (Settings.mesh.draw_position.x == 0 &&
                    Settings.mesh.draw_position.y == 0 &&
                    Settings.mesh.draw_position.z == 0 &&
                    Settings.mesh.draw_rotation.x == 0 &&
                    Settings.mesh.draw_rotation.y == 0 &&
                    Settings.mesh.draw_rotation.z == 0 &&
                    Settings.mesh.draw_scale.x == 1 &&
                    Settings.mesh.draw_scale.y == 1 &&
                    Settings.mesh.draw_scale.z == 1) return;
                
                var dg = emu_dialog_confirm(self.root, "Would you like to apply the transformation to " + (array_length(indices) == 1 ? self.root.GetSibling("MESH LIST").At(indices[0]).name : " the selected meshes") + "?", function() {
                    var indices = self.root.indices;
                    __meshops_transform_set_matrix(
                        Settings.mesh.draw_position.x, Settings.mesh.draw_position.y, Settings.mesh.draw_position.z,
                        Settings.mesh.draw_rotation.x, Settings.mesh.draw_rotation.y, Settings.mesh.draw_rotation.z,
                        Settings.mesh.draw_scale.x, Settings.mesh.draw_scale.y, Settings.mesh.draw_scale.z
                    );
                    for (var i = 0, n = array_length(indices); i < n; i++) {
                        self.root.list[real(indices[i])].ActionTransform();
                    }
                    batch_again();
                    Stuff.mesh.ResetTransform();
                    self.root.Dispose();
                });
                
                dg.indices = indices;
                dg.list = self.root.root.GetMeshType();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Apply the preview transformation to the selected meshes. Useful for converting between different world spaces.")
                .SetID("BAKE TRANSFORMATION"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Reset Transformation", function() {
                Stuff.mesh.ResetTransform();
            }))
                .SetTooltip("Reset the transform used in the preview.")
                .SetID("RESET TRANSFORMATION"),
            #endregion
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Other Operations"),
            #region other operations
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Rotate Up Axis", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionRotateUpAxis();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Rotate the \"up\" axis for the selected meshes. It would be nice if the world could standardize around either Y-up or Z-up, but that's never going to happen. https://xkcd.com/927/")
                .SetID("ROTATE UP AXIS"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Rotate (Swap Hnd.)", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionRotateUpAxis();
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionMirrorX();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Rotate the \"up\" axis for the selected meshes. It would be nice if the world could standardize around either Y-up or Z-up, but that's never going to happen. https://xkcd.com/927/")
                .SetID("ROTATE AND SWAP"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 3, element_height, "Mirror X", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionMirrorX();
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
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionMirrorY();
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
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionMirrorZ();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Mirror the selected meshes over the Z axis. Triangle vertex order will not be changed.")
                .SetID("MIRROR Z"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Flip Texture Horiz.", function() {
                var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
                for (var i = 0, n = array_length(indices); i < n; i++) {
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionFlipTexU();
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
                    self.root.GetSibling("MESH LIST").At(real(indices[i])).ActionFlipTexV();
                }
                batch_again();
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Some 3D modelling programs insist on using the bottom-left of the texture image as the (0, 0) origin. We prefer the origin to be in the top-left. Use this button to flip the texture coordinates vertically.")
                .SetID("MIRROR TEX V"),
            (new EmuButton(col2x, EMU_AUTO, element_width / 2, element_height, "Materials", function() {
                dialog_create_mesh_material_settings(self.root.root.GetMeshType(), self.root.GetSibling("MESH LIST").GetAllSelectedIndices());
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Set some material properties used by the selected meshes. Right now I've only implemented the base (diffuse) texture but I'd like to get around to the rest later.")
                .SetID("MATERIALS"),
            (new EmuButton(col2x + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Submeshes", function() {
                dialog_create_mesh_submesh(self.root.GetSibling("MESH LIST").GetSelectedItem());
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data)  == 1);
                })
                .SetTooltip("View and manage mesh submeshes.")
                .SetID("SUBMESHES"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "More...", function() {
                dialog_create_mesh_other_settings(self.root.root.GetMeshType(), self.root.GetSibling("MESH LIST").GetAllSelectedIndices());
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data != undefined && array_length(data) > 0);
                })
                .SetTooltip("Other misc operations you amy want to do on a mesh.")
                .SetID("OTHER TOOLS"),
            #endregion
            #region viewer
            (new EmuRenderSurface(col3x, EMU_BASE, room_width - col3x - 16, room_width - col3x - 64, ui_render_surface_render_mesh_ed, function(mx, my) {
                if (!is_clamped(mx, 0, self.width) || !is_clamped(my, 0, self.height)) return;
                Stuff.mesh.camera.Update();
                if (self.isActiveElement() && keyboard_check_pressed(vk_mesh_editor_overlay_text_toggle)) {
                    Settings.mesh.draw_3d_view_overlay_text = !Settings.mesh.draw_3d_view_overlay_text;
                }
                if (keyboard_check(ord("Q"))) Settings.mesh.draw_light_direction++;
                if (keyboard_check(ord("E"))) Settings.mesh.draw_light_direction--;
            }, emu_null, emu_null))
                .SetID("3D VIEW"),
            (new EmuButton(col3x, EMU_AUTO, element_width, element_height, "Viewer Settings", function() {
                var dialog = new EmuDialog(32 + 320 + 32, 608, "Mesh viewer settings");
                dialog.root = self;
                dialog.active_shade = 0;
                dialog.x = 320;
                dialog.y = 120;
                
                var col1x = 32;
                var col_width = 320;
                
                dialog.AddContent([
                    #region column 1
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw textures?", Settings.mesh.draw_textures, function() {
                        Settings.mesh.draw_textures = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the meshes in the preview window using a texture.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_textures;
                        }),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw vertex colors?", Settings.mesh.draw_vertex_colors, function() {
                        Settings.mesh.draw_vertex_colors = self.value;
                    }))
                        .SetTooltip("Whether or not to colorize the verties of meshes.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_vertex_colors;
                        }),
                    new EmuText(col1x, EMU_AUTO, col_width, 32, "Wireframe alpha:"),
                    (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 1, true, Settings.mesh.wireframe_alpha, function() {
                        Settings.mesh.wireframe_alpha = self.value;
                    }))
                        .SetTooltip("Draw a wireframe over the 3D mesh. Turn this off if it gets annoying.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.wireframe_alpha;
                        }),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw lighting?", Settings.mesh.draw_lighting, function() {
                        Settings.mesh.draw_lighting = self.value;
                    }))
                        .SetTooltip("Whether or not to lighting should be enabled.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_lighting;
                        }),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw backfaces?", Settings.mesh.draw_back_faces, function() {
                        Settings.mesh.draw_back_faces = self.value;
                    }))
                        .SetTooltip("For backface culling.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_back_faces;
                        }),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw 3D axes?", Settings.mesh.draw_axes, function() {
                        Settings.mesh.draw_axes = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the red, green, and blue axes in the 3D view.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_axes;
                        }),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw grid?", Settings.mesh.draw_grid, function() {
                        Settings.mesh.draw_grid = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the tile grid on the Z = 0 plane.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_grid;
                        }),
                    (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw physical bounds?", Settings.mesh.draw_physical_bounds, function() {
                        Settings.mesh.draw_physical_bounds = self.value;
                    }))
                        .SetTooltip("Whether or not to draw the tile grid on the Z = 0 plane.")
                        .SetRefresh(function() {
                            self.value = Settings.mesh.draw_physical_bounds;
                        })
                ]);
                
                if (!IS_MESH_MODE) {
                    dialog.AddContent([
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw reflections?", Settings.mesh.draw_reflections, function() {
                            Settings.mesh.draw_reflections = self.value;
                        }))
                            .SetTooltip("If you have a reflection mesh set up, you may draw it, as well.")
                            .SetRefresh(function() {
                                self.value = Settings.mesh.draw_reflections;
                            }),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw collision?", Settings.mesh.draw_collision, function() {
                            Settings.mesh.draw_collision = self.value;
                        }))
                            .SetTooltip("Whether or not to show collision shapes associated with meshes.")
                            .SetRefresh(function() {
                                self.value = Settings.mesh.draw_collision;
                            }),
                    ]);
                    dialog.height += 96;
                }
                
                dialog.AddContent([
                    (new EmuButton(col1x, EMU_AUTO, col_width, 32, "[c_aqua]Reset", function() {
                        Settings.mesh.draw_position = MESH_DEF_VIEW_DRAW_POSITION;
                        Settings.mesh.draw_rotation = MESH_DEF_VIEW_DRAW_ROTATION;
                        Settings.mesh.draw_scale = MESH_DEF_VIEW_DRAW_SCALE;
                        Settings.mesh.draw_textures = MESH_DEF_VIEW_DRAW_TEXTURES;
                        Settings.mesh.draw_vertex_colors = MESH_DEF_VIEW_DRAW_VERTEX_COLORS;
                        Settings.mesh.draw_physical_bounds = MESH_DEF_VIEW_DRAW_PHYSICAL_BOUNDS;
                        Settings.mesh.draw_lighting = MESH_DEF_VIEW_DRAW_LIGHTING; 
                        Settings.mesh.draw_back_faces = MESH_DEF_VIEW_DRAW_BACK_FACES;
                        Settings.mesh.draw_reflections = MESH_DEF_VIEW_DRAW_REFLECTIONS;
                        Settings.mesh.draw_collision = MESH_DEF_VIEW_DRAW_COLLISION;
                        Settings.mesh.draw_axes = MESH_DEF_VIEW_DRAW_AXES;
                        Settings.mesh.draw_light_direction = MESH_DEF_VIEW_DRAW_LIGHT_DIRECTION;
                        Settings.mesh.draw_grid = MESH_DEF_VIEW_DRAW_GRID;
                        Settings.mesh.wireframe_alpha = MESH_DEF_VIEW_WIREFRAME_ALPHA;
                        self.root.Refresh();
                    }))
                    #endregion
                ]).AddDefaultCloseButton();
            }))
                .SetTooltip("Some options relating to the 3D view above.")
                .SetID("VIEWER SETTINGS"),
            #endregion
        ])
            .SetID("INFO")
    ]);
    
    return container.Refresh();
}