function dialog_create_settings_data_asset_files() {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 752, "Data and Asset Files");
    dialog.execute_on_select = true;
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    
    return dialog.AddContent([
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Asset Files", element_height, 8, function() {
            if (self.root) self.root.Refresh(self.GetSelection());
        }))
            .SetList(Game.meta.export.files)
            .SetAllowDeselect(false)
            .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                var file_data = Game.meta.export.files[index];
                return (index ? (file_data.name + ".ddda") : "(master.dddd)") + (file_data.critical ? "" : "*");
            })
            .SetListColors(function(index) {
                return Game.meta.export.files[index].compressed ? c_aqua : EMU_COLOR_TEXT;
            })
            .SetTooltip("This is the list of data/asset files you currently have linked to the project. The master file is special, is always critical and can't be renamed as it has the same name as the project by default.\n\nCompressed files are shown in blue. Non-critical files are denoted with an asterisk*.")
            .SetID("LIST"),
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Contents", element_height, 10, function() {
            if (!self.root) return;
            if (!self.root.execute_on_select) return;
            
            
            var this_file = self.GetSibling("LIST").GetSelection();
            // reset the locations of every location that belongs in this file to the base file
            for (var i = 0, n = array_length(Game.meta.export.locations); i < n; i++) {
                if (Game.meta.export.locations[i] == this_file) {
                    Game.meta.export.locations[i] = 0;
                }
            }
            // iterate over every selected location and put it in this file
            var selection = self.GetAllSelectedIndices();
            for (var i = 0, n = array_length(selection); i < n; i++) {
                Game.meta.export.locations[selection[i]] = this_file;
            }
        }))
            .SetRefresh(function(index) {
                self.root.execute_on_select = false;
                self.Deselect();
                var this_file = self.GetSibling("LIST").GetSelection();
                for (var i = 0, n = array_length(Game.meta.export.locations); i < n; i++) {
                    if (Game.meta.export.locations[i] == this_file) self.Select(i);
                }
                self.root.execute_on_select = true;
            })
            .SetList(["Game Data", "Animations", "Data: Events", "Maps", "Terrain", "Images", "Audio", "Meshes", "Language Text"])
            .SetTooltip("This is the list of all the types of stuff you can sort into different files. I recommend putting each of the audio / visual resources (colorized) into their own files, especially if you use source control, so that changing one doesn't cause the entire wad of data to have to be updated. The main game data must be in the master data file, since other things may depend on their existence.")
            .SetMultiSelect(true, true, true)
            .SetAllowDeselect(true)
            .SetID("CONTENTS"),
        (new EmuButton(col2, EMU_BASE, element_width, element_height, "Add File", function() {
            var base_name = "data";
            var name = base_name;
            var count = 1;
            while (true) {
                var collision_found = false;
                for (var i = 0, n = array_length(Game.meta.export.files); i < n; i++) {
                    if (Game.meta.export.files[i].name == name) {
                        collision_found = true;
                        break;
                    }
                }
                if (!collision_found) break;
                name = base_name + string(count++);
            }
            array_push(Game.meta.export.files, new DataFile(name, false, false));
            self.root.Refresh(self.GetSibling("LIST").GetSelection());
        }))
            .SetRefresh(function(index) {
                self.SetInteractive(array_length(Game.meta.export.files) < 0xff);
            })
            .SetID("ADD")
            .SetTooltip("Add a data/asset file. You can have up to " + string(0xff) + ", which is realistically way the heck more than you'll need since there are only " + string(array_length(Game.meta.export.locations)) + " things you can put into them."),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Delete File", function() {
            var selection = self.GetSibling("LIST").GetSelection();
            var file_data = Game.meta.export.files[selection];
            array_delete(Game.meta.export.files, selection, 1);
            // any categories that previously lived in this file get set to the
            // master file; any that live in a succeeding file get shifted down
            for (var i = 0; i < array_length(Game.meta.export.locations); i++) {
                if (Game.meta.export.locations[i] == selection) {
                    Game.meta.export.locations[i] = 0;
                } else if (Game.meta.export.locations[i] > selection) {
                    Game.meta.export.locations[i]--;
                }
            }
            self.GetSibling("LIST").Deselect();
            if (selection < array_length(Game.meta.export.locations) - 1) {
                self.GetSibling("LIST").Select(selection);
            }
            self.root.Refresh(selection);
        }))
            .SetRefresh(function(index) {
                self.SetInteractive(index > 0);
            })
            .SetID("DELETE")
            .SetTooltip("Delete a data/asset file. You must have at least one. If you remove a data file that is still assigned to be used, anything that would have been saved to it will instead be saved to the one at the top of the list."),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "File name:", "", "filename", VISIBLE_NAME_LENGTH, E_InputTypes.LETTERSDIGITSANDUNDERSCORES, function() {
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection == -1) return;
            for (var i = 0, n = array_length(Game.meta.export.files); i < n; i++) {
                if (i == selection) continue;
                if (Game.meta.export.files[i].name == self.value) return;
            }
            Game.meta.export.files[selection].name = self.value;
        }))
            .SetUpdate(function() {
                var selection = self.GetSibling("LIST").GetSelection();
                if (selection == -1) return;
                self.color_text = function() { return EMU_COLOR_TEXT; };
                for (var i = 0, n = array_length(Game.meta.export.files); i < n; i++) {
                    if (i == selection) continue;
                    if (Game.meta.export.files[i].name == self.value) {
                        self.color_text = function() { return EMU_COLOR_INPUT_REJECT; };
                    }
                }
            })
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelection();
                self.SetInteractive(selection != -1);
                if (selection == -1) return;
                self.SetValue(Game.meta.export.files[selection].name);
            })
            .SetTooltip("The name of the data file. Names must be unique.")
            .SetID("NAME"),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "Compressed?", false, function() {
            var selection = self.GetSibling("LIST").GetSelection();
            Game.meta.export.files[selection].compressed = self.value;
        }))
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelection();
                self.SetInteractive(selection != -1);
                if (selection == -1) return;
                self.SetValue(Game.meta.export.files[selection].compressed);
            })
            .SetID("COMPRESSED"),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "Critical?", false, function() {
            var selection = self.GetSibling("LIST").GetSelection();
            Game.meta.export.files[selection].critical = self.value;
        }))
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelection();
                self.SetInteractive(selection != -1);
                if (selection == -1) return;
                self.SetValue(Game.meta.export.files[selection].critical);
            })
            .SetID("CRITICAL"),
    ]).AddDefaultCloseButton();
}