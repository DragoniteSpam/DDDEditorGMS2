function dialog_create_manager_mesh_autotile() {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 720, "Data: Mesh Autotile");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    dialog.AddContent([
        #region column 1
        (new EmuList(col1, EMU_BASE, element_width, element_height, "All Mesh Autotiles:", element_height, 16, function() {
            if (!self.root) return;
            self.root.Refresh();
        }))
            .SetList(Game.mesh_autotiles)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Mesh Autotile", function() {
            array_push(Game.mesh_autotiles, new DataMeshAutotile("MeshAutotile" + string(array_length(Game.mesh_autotiles))));
            if (self.GetSibling("LIST").GetSelection() == -1)
                self.GetSibling("LIST").Select(array_length(Game.mesh_autotiles) - 1, true);
        })),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Remove Mesh Autotile", function() {
            var selection = self.GetSibling("LIST").GetSelection();
            Game.mesh_autotiles[selection].Destroy();
            array_delete(Game.mesh_autotiles, selection, 1);
            self.root.Refresh();
        }))
            .SetRefresh(function() {
                self.SetInteractive(self.GetSibling("LIST").GetSelection() != -1);
            }),
        #endregion
        #region column 2
        (new EmuInput(col2, EMU_BASE, element_width, element_height, "Name:", "", "autotile name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.GetSibling("LIST").GetSelectedItem().name = self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (selection) {
                    self.SetValue(selection.name);
                }
            }),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Internal name:", "", "autotile internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITSANDUNDERSCORES, function() {
            var selection = self.GetSibling("LIST").GetSelectedItem();
            if (!internal_name_get(self.value)) {
                internal_name_set(selection, self.value);
            }
        }))
            .SetColorText(function() {
                var internal_name_value = internal_name_get(self.value);
                return internal_name_value ? (internal_name_value == self.GetSibling("LIST").GetSelectedItem() ? EMU_COLOR_TEXT : EMU_COLOR_INPUT_WARN) : EMU_COLOR_INPUT_WARN;
            })
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (selection) {
                    self.SetValue(selection.internal_name);
                }
            }),
        (new EmuRadioArray(col2, EMU_AUTO, element_width, element_height, "Layer:", 0, function() {
            self.root.Refresh();
        }))
            .AddOptions(["Top", "Middle", "Base", "Slope"])
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            })
            .SetID("LAYER"),
        (new EmuRadioArray(col2, EMU_AUTO, element_width, element_height, "Type:", 0, function() {
            self.root.Refresh();
        }))
            .AddOptions(["Upright", "Reflected"])
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            })
            .SetID("TYPE"),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Import Layer", function() {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            var type = self.GetSibling("TYPE").value
            
            var root = filename_dir(get_open_filename_mesh_d3d()) + "/";
            var at_layer = autotile.layers[layer_index];
            var failures = 0;
            var file_count = 0;
            var changes = { };
            var change_prefix = autotile.GUID + ":" + string(layer_index) + ":";
            
            for (var i = 0; i < AUTOTILE_COUNT; i++) {
                var filename = root + string(i) + ".d3d";
                if (!file_exists(filename)) filename = filename_change_ext(filename, ".obj");
                if (!file_exists(filename)) continue;
                
                file_count++;
                
                var data = import_3d_model_generic(filename);
                if (data == undefined) {
                    failures++;
                } else {
                    if (type == 0) {
                        at_layer.tiles[i].Set(data[0]);
                    } else {
                        at_layer.tiles[i].SetReflect(data[0]]);
                    }
                    /// @todo add an optional "mesh count" parameter to
                    // import_3d_model_generic which eliminates the need
                    // to discoard additional returned buffers
                    for (var i = 1, n = array_length(data); i < n; i++) {
                        buffer_delete(data[i]);
                    }
                    changes[$ change_prefix + string(i)] = true;
                }
            }
            
            entity_mesh_autotile_check_changes(changes);
            if (failures > 0) {
                emu_dialog_notice("Unable to import " + string(failures) + " of " + string(file_count) + " attempted files.");
            }
            self.root.Refresh();
        }))
            .SetTooltip("Import autotile meshes in batch. If you want to load an entire series at once you should probably choose this option, because selecting them one-by-one would be very slow.")
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            }),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Export Layer", function() {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            if (!autotiles) return;
            
            var folder = filename_path(get_save_filename_mesh("save destination", "Game Maker model files|*.d3d;*.gmmod"));
            if (folder != "") {
                for (var i = 0; i < AUTOTILE_COUNT; i++) {
                    if (autotile.layers[layer_index].tiles[i].buffer) {
                        meshops_export_d3d(folder + string(i) + ".d3d", autotile.layers[layer_index].tiles[i].buffer);
                    }
                    if (autotile.layers[layer_index].tiles[i].reflect_buffer) {
                        meshops_export_d3d(folder + string(i) + "r.d3d", autotile.layers[layer_index].tiles[i].reflect_buffer);
                    }
                }
            }
        }))
            .SetTooltip("Export the selected layer of mesh autotiles.")
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            }),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Auto Reflections (Layer)", function() {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            if (!autotiles) return;
            
            var changes = { };
            var change_prefix = autotile.GUID + ":" + string(layer_index) + ":";
            
            for (var i = 0; i < AUTOTILE_COUNT; i++) {
                if (autotile.layers[layer_index].tiles[i].AutoReflect()) {
                    changes[$ change_prefix + string(i)] = true;
                }
            }
            
            entity_mesh_autotile_check_changes(changes);
            self.root.Refresh();
        }))
            .SetTooltip("Automatically generate Reflection meshes for each of the autotiles by flipping the base ones upside-down.")
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            }),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Auto Reflections (All)", function() {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            if (!autotiles) return;
            
            var changes = { };
            for (var i = 0; i < array_length(autotile.layers); i++) {
                var change_prefix = autotile.GUID + ":" + string(i) + ":";
                for (var j = 0; j < AUTOTILE_COUNT; j++) {
                    if (autotile.layers[i].tiles[j].AutoReflect()) {
                        changes[$ change_prefix + string(j)] = true;
                    }
                }
            }
            
            entity_mesh_autotile_check_changes(changes);
            self.root.Refresh();
        }))
            .SetTooltip("Automatically generate Reflection meshes for each of the autotiles by flipping the base ones upside-down.")
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            }),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Clear Layer", function() {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            if (!autotiles) return;
            
            var changes = { };
            var change_prefix = autotile.GUID + ":" + string(layer_index) + ":";
            
            for (var i = 0; i < AUTOTILE_COUNT; i++) {
                if (autotile.layers[layer_index].tiles[i].Destroy()) {
                    changes[$ change_prefix + string(i)] = true;
                }
            }
            
            entity_mesh_autotile_check_changes(changes);
            self.root.Refresh();
        }))
            .SetTooltip("Deletes all imported mesh autotiles. Entities which use them will continue to exist, but will be invisible. (Both upright and reflection meshes will be deleted.)")
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            }),
        #endregion
    ]);
    
    var columns = 6;
    for (var i = 0; i < AUTOTILE_COUNT; i++) {
        var button = new EmuButtonImage(col3 + (i % columns) * (element_width / columns), (i == 0) ? EMU_BASE : ((i % columns == 0) ? EMU_AUTO : EMU_INLINE),
                 element_width / columns, element_width / columns, spr_autotile_blueprint, i, c_white, 1, true, string(i), function() {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            var type = self.GetSibling("TYPE").value;
            var tile_data = autotile.layers[layer_index].tiles[self.index];
            
            var fn = get_open_filename_mesh_d3d();
            
            var data = import_3d_model_generic(fn);
            if (data == undefined) {
                emu_dialog_notice("Unable to load file: " + fn);
            } else {
                if (type == 0) {
                    tile_data.Set(data[1], data[0]);
                } else {
                    tile_data.SetReflect(data[1], data[0]);
                }
                /// @todo add an optional "mesh count" parameter to
                // import_3d_model_generic which eliminates the need
                // to discoard additional returned buffers
                for (var i = 1, n = array_length(data); i < n; i++) {
                    buffer_delete(data[i]);
                }
            }
            
            var changes = { };
            changes[$ autotile.GUID + ":" + string(layer_index) + ":" + string(self.index)] = true;
            entity_mesh_autotile_check_changes(changes);
            self.Refresh();
        });
        
        button.color_back = method(button, function() {
            return c_white;
        });
        
        button.SetTooltip("Import a mesh for top mesh autotile #" + string(i) + ". It should take the shape of the icon below, with green representing the outer part and brown representing the inner part.")
            .SetInteractive(false)
            .SetImageAlignment(fa_left, fa_top)
            .SetRefresh(function() {
                var autotile = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!autotile);
                if (autotile) {
                    var layer_index = self.GetSibling("LAYER").value;
                    var type = self.GetSibling("TYPE").value;
                    var at_layer = autotile.layers[layer_index];
                    if (type == 0) {
                        self.text = (!!at_layer.tiles[self.index].buffer) ? string(self.index) : "[c_red]" + string(self.index);
                    } else {
                        self.text = (!!at_layer.tiles[self.index].reflect_buffer) ? string(self.index) : "[c_red]" + string(self.index);
                    }
                }
            });
        
        button.index = i;
        dialog.AddContent([button]);
    }
    
    return dialog.AddContent([
        (new EmuFileDropperListener(function(files) {
            var autotile = self.GetSibling("LIST").GetSelectedItem();
            var layer_index = self.GetSibling("LAYER").value;
            var type = self.GetSibling("TYPE").value;
            if (!autotile) return;
            
            var at_layer = autotile.layers[layer_index];
            var failures = 0;
            var changes = { };
            var change_prefix = autotile.GUID + ":" + string(layer_index) + ":";
            var filtered = self.Filter(files, [".d3d", ".gmmod", ".obj"]);
            for (var i = 0, n = array_length(filtered); i < n; i++) {
                var filename = filtered_list[i];
                var name = filename_change_ext(filename_name(filename), "");
                if (validate_int(name) && is_clamped(string(name), 0, AUTOTILE_COUNT - 1)) {
                    var index = string(name);
                    var data = import_3d_model_generic(filename);
                    
                    if (data == undefined) {
                        failures++;
                    } else {
                        if (type == 0) {
                            at_layer.tiles[index].Set(data[0]);
                        } else {
                            at_layer.tiles[index].SetReflect(data[0]);
                        }
                        /// @todo add an optional "mesh count" parameter to
                        // import_3d_model_generic which eliminates the need
                        // to discoard additional returned buffers
                        for (var i = 1, n = array_length(data); i < n; i++) {
                            buffer_delete(data[i]);
                        }
                        changes[$ change_prefix + name] = true;
                    }
                }
            }
            
            entity_mesh_autotile_check_changes(changes);
            if (failures) {
                emu_dialog_notice("Unable to import " + string(failures) + " of the " + string(ds_list_size(files)) + " files.");
            }
            self.root.Refresh();
        })),
    ]).AddDefaultCloseButton();
}