function dialog_create_mesh_advanced(mesh) {
    var dw = 960;
    var dh = 640;
    
    var columns = 3;
    var spacing = 16;
    var element_width = dw / columns - spacing * 2;
    var element_height = 32;
    
    var col1 = dw * 0 / columns + spacing;
    var col2 = dw * 1 / columns + spacing;
    var col3 = dw * 2 / columns + spacing;
    
    var replace_submesh = function() {
        var index = self.GetSibling("SUBMESHES").GetSelection();
        if (index == -1) return;
        
        try {
            var fn = get_open_filename_mesh();
            var mesh = self.root.mesh;
            switch (filename_ext(fn)) {
                case ".obj": import_obj(fn, undefined, mesh, selection); break;
                case ".d3d": case ".gmmod": import_d3d(fn, undefined, false, mesh, selection); break;
                case ".smf": break;
            }
        } catch (e) {
            emu_dialog_notice("Couldn't load the file " + (e.message) + "!");
        }
        
        batch_again();
    };
    
    var dialog = new EmuDialog(dw, dh, "Advanced Mesh Options: " + mesh.name);
    dialog.mesh = mesh;
    
    dialog.AddContent([
        #region column 1
        (new EmuList(col1, EMU_BASE, element_width, element_height, mesh.name + " submeshes", element_height, 10, function() {
            if (self.root) self.root.Refresh();
        }))
            .SetCallbackDouble(replace_submesh)
            .SetList(mesh.submeshes)
            .SetTooltip("Each mesh can have a number of different sub-meshes. This can be used to give multiple meshes different visual skins, or to imitate primitive frame-based animation.")
            .SetMultiSelect(true)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("SUBMESHES"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Submesh", function() {
            try {
                var fn = get_open_filename_mesh();
                var mesh = self.root.mesh;
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, undefined, mesh); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, undefined, false, mesh); break;
                    case ".smf": break;
                }
            } catch (e) {
                emu_dialog_notice("Couldn't load the file " + (e.message) + "!");
            }
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
                self.root.mesh.submeshes[i].name = self.value;
            }
        }))
            .SetRefresh(function() {
                if (array_length(self.GetSibling("SUBMESHES").GetAllSelectedIndices()) > 1) {
                    self.SetValue("");
                } else {
                    self.SetValue(self.root.mesh.submeshes[0].name);
                }
            })
            .SetTooltip("You don't have to, but it's generally helpful to give your submeshes names to identify them with.")
            .SetID("NAME"),
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
                    path = "<no path saved>";
                }
                
                if (string_width(path) <= self.width - self.offset) {
                    self.text = path;
                } else {
                    var prefix = string_copy(path, 1, 10) + "...   ";
                    var prefix_width = string_width(prefix);
                    self.text = "";
                    for (var i = string_length(path); i > 0; i--) {
                        self.text = string_char_at(path, i) + self.text;
                        if (string_width(self.text) > (self.width - prefix_width - self.offset)) {
                            self.text = prefix + self.text;
                            break;
                        }
                    }
                }
                
                if (!file_exists(self.text)) self.text = "[c_orange]" + self.text;
                
                self.SetTooltip(path);
        
            })
            .SetID("LOCATION"),
        #endregion
        #region column 2
        new EmuText(col2, EMU_BASE, element_width, element_height, "[c_aqua]Operations"),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Reload from Source", function() {
            var mesh = self.root.mesh;
            var selection = self.GetSibling("SUBMESHES").GetAllSelectedIndices();
            
            for (var i = 0, n = array_length(selection); i < n; i++) {
                mesh.submeshes[selection[i]].Reload();
            }
            
            batch_again();
        }))
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
                "Particle Mesh", "", "", "",
                "", "", "", ""
            ])
            .SetOrientation(E_BitfieldOrientations.VERTICAL)
            .SetTooltip("Extra attributes you can assign to meshes.")
            .SetID("ATTRIBUTES")
        #endregion
    ])
        .AddDefaultCloseButton();
    
    return dialog;
    
}