function dialog_create_mesh_submesh(mesh) {
    var replace_submesh = function() {
        var index = self.GetSibling("SUBMESHES").GetSelection();
        if (index == -1) return;
        
        self.root.mesh.submeshes[index].Reload(get_open_filename_mesh());
        
        batch_again();
    };
    
    var dialog = new EmuDialog(32 + 320 + 32 + ((EDITOR_BASE_MODE != ModeIDs.MESH) ? (320 + 32 + 320 + 32) : 0), 688, "Advanced Mesh Options: " + mesh.name);
    dialog.mesh = mesh;
    
    var element_width = 320;
    var element_height = 32;
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    dialog.AddContent([
        #region column 1
        (new EmuList(col1, EMU_BASE, element_width, element_height, mesh.name + " submeshes", element_height, 10, function() {
            if (self.root) self.root.Refresh();
        }))
            .SetCallbackDouble(replace_submesh)
            .SetList(mesh.submeshes)
            .SetTooltip("Each mesh can have a number of different sub-meshes. This can be used to give multiple meshes different visual skins, or to imitate primitive frame-based animation.")
            .SetMultiSelect(true)
            .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                var submesh = self.entries[index];
                var buffer_size = (submesh.buffer ? buffer_get_size(submesh.buffer) : 0) / VERTEX_SIZE / 3;
                var reflect_buffer_size = (submesh.reflect_buffer ? buffer_get_size(submesh.reflect_buffer) : 0) / VERTEX_SIZE / 3;
                var suffix = "";
                if (buffer_size == reflect_buffer_size || reflect_buffer_size == 0) {
                    suffix = " (" + string(buffer_size) + " triangles)";
                } else {
                    suffix = " (" + string(buffer_size) + " / " + string(reflect_buffer_size) + " triangles)";
                }
                return (submesh.editor_visible ? submesh.name : ("[c_ltgray][slant]" + submesh.name + "[]")) + suffix;
            })
            .SetID("SUBMESHES"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Submesh", function() {
            self.root.mesh.AddSubmeshFromFile(get_open_filename_mesh());
        }))
            .SetTooltip("Add a submesh")
            .SetID("ADD"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Replace Submesh", replace_submesh))
            .SetTooltip("Replace the selected submesh")
            .SetID("REPLACE"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Delete Submesh", function() {
            var mesh = self.root.mesh;
            var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
            if (array_length(selection) == array_length(mesh.submeshes)) {
                emu_dialog_notice("Please don't delete all of a mesh's submeshes");
                return;
            }
            
            for (var i = 0, n = array_length(selection); i < n; i++) {
                mesh.RemoveSubmesh(selection[i]);
            }
            
            self.GetSibling("SUBMESHES").Deselect();
            batch_again();
        }))
            .SetTooltip("Remove the selected submesh")
            .SetID("DELETE"),
        (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Name:", "", "name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.mesh.submeshes[selection[i]].name = self.value;
            }
        }))
            .SetRefresh(function() {
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                if (array_length(selection) == 0) {
                    self.SetInteractive(false);
                } else if (array_length(selection) > 1) {
                    self.SetInteractive(true);
                    self.SetValue("");
                } else {
                    self.SetInteractive(true);
                    self.SetValue(self.root.mesh.submeshes[selection[0]].name);
                }
            })
            .SetTooltip("You don't have to, but it's generally helpful to give your submeshes names to identify them with.")
            .SetID("NAME"),
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Visible in editor?", true, function() {
            var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.mesh.submeshes[selection[i]].editor_visible = self.value;
            }
        }))
            .SetRefresh(function() {
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                if (array_length(selection) == 0) {
                    self.SetInteractive(false);
                } else if (array_length(selection) > 1) {
                    self.SetInteractive(true);
                    self.SetValue(2);
                } else {
                    self.SetInteractive(true);
                    self.SetValue(self.root.mesh.submeshes[selection[0]].editor_visible);
                }
            })
            .SetTooltip("Is the submesh drawn in the mesh editor window?")
            .SetID("VISIBLE"),
        (new EmuText(col1, EMU_AUTO, element_width, element_height, ""))
            .SetRefresh(function() {
                var mesh = self.root.mesh;
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                var path = "";
                
                for (var i = 0, n = array_length(selection); i < n; i++) {
                    if (path == "") {
                        path = mesh.submeshes[selection[i]].path;
                    } else if (path != mesh.submeshes[selection[i]]) {
                        path = "<multiple>";
                        break;
                    }
                }
                
                if (path == "") {
                    self.text = "<no path saved>";
                } else {
                    self.text = filename_abbreviated(path, self.width - self.offset);
                }
                
                if (!file_exists(self.text)) self.text = "[c_orange]" + self.text;
                self.SetTooltip(path);
        
            })
            .SetID("LOCATION"),
        #endregion
    ]);
    
    if (EDITOR_BASE_MODE != ModeIDs.MESH) {
        dialog.AddContent([
            #region column 2 - additional stuff
            new EmuText(col2, EMU_BASE, element_width, element_height, "[c_aqua]Submesh Operations"),
            (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Reload from Source", function() {
                var mesh = self.root.mesh;
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                
                for (var i = 0, n = array_length(selection); i < n; i++) {
                    mesh.submeshes[selection[i]].Reload();
                }
                
                batch_again();
            }))
                .SetRefresh(function() {
                    var mesh = self.root.mesh;
                    var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                    self.SetInteractive(false);
                    for (var i = 0, n = array_length(selection); i < n; i++) {
                        if (mesh.submeshes[selection[i]].path != "") {
                            self.SetInteractive(true);
                            return;
                        }
                    }
                })
                .SetTooltip("Reload selected submeshes from their source file (if their source file exists).")
                .SetID("RELOAD"),
            (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Import Reflection...", function() {
                var mesh = self.root.mesh;
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                
                for (var i = 0, n = array_length(selection); i < n; i++) {
                    mesh.submeshes[selection[i]].ImportReflection();
                }
                
                batch_again();
            }))
                .SetTooltip("Import a reflection mesh for all selected submeshes.")
                .SetID("IMPORT REFLECTION"),
            (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Auto-Generate Reflection", function() {
                var mesh = self.root.mesh;
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                
                for (var i = 0, n = array_length(selection); i < n; i++) {
                    mesh.submeshes[selection[i]].GenerateReflections();
                }
                
                batch_again();
            }))
                .SetTooltip("Generate a reflection mesh for this submesh by flipping the model upside down over the XY plane. (See File/Preferences for reflection parameters.)")
                .SetID("AUTO REFLECTION"),
            (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Swap Reflection and Upright", function() {
                var mesh = self.root.mesh;
                var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
                
                for (var i = 0, n = array_length(selection); i < n; i++) {
                    mesh.submeshes[selection[i]].SwapReflections();
                }
                
                batch_again();
            }))
                .SetTooltip("The upright mesh will become the reflection mesh, and vice versa.")
                .SetID("SWAP REFLECTION"),
            #endregion
            #region column 3
            new EmuText(col3, EMU_BASE, element_width, element_height, "[c_aqua]Editor Attributes"),
            (new EmuBitfield(col3, EMU_AUTO, element_width, element_height * 8, mesh.flags, function() {
                self.root.mesh.flags = self.value;
            }))
                .AddOptions([
                    "Particle", "Auto Static", "", "",
                    "", "", "", ""
                ])
                .SetOrientation(E_BitfieldOrientations.VERTICAL)
                .SetTooltip("Extra attributes you can assign to meshes.")
                .SetID("ATTRIBUTES")
            #endregion
        ]);
    }
    
    return dialog.AddDefaultCloseButton();
    
}