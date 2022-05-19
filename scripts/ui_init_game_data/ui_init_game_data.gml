function ui_init_game_data(mode) {
    var hud_width = room_width / 5;
    var hud_height = room_height;
    var col1 = hud_width * 0 + 16;
    var col2 = hud_width * 1 + 16;
    var col3 = hud_width * 2 + 16;
    var col4 = hud_width * 3 + 16;
    var col5 = hud_width * 4 + 16;
    var element_width = hud_width - 32;
    var element_height = 32;
    
    var container = new EmuCore(0, 16, hud_width, hud_height);
    
    container.AddContent([
        (new EmuList(col1, EMU_BASE, element_width, element_height, "All game data types:", element_height, 25, function() {
            if (self.GetSelection() == -1) return;
            
            if (array_empty(Game.data)) {
                momu_data_types();
                return;
            }
            
            var selection = self.GetSelection();
            if (selection == -1) {
                Stuff.data.ui.SearchID("PROPERTIES").destroyContent();
                Stuff.data.ui.Refresh();
            } else if (Game.data[selection] != Stuff.data.last_active_type) {
                Stuff.data.Activate(Game.data[selection]);
            }
            
            // update the active type.instance
            Stuff.data.GetActiveType();
            Stuff.data.GetActiveInstance();
        }))
            .SetList(Game.data)
            .SetVacantText("click to define...")
            .SetListColors(function(index) {
                return (Game.data[index].type == DataTypes.ENUM) ? c_aqua : EMU_COLOR_TEXT;
            })
            .SetRefresh(function() {
                if (Game.data != self.entries) self.SetList(Game.data);
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST"),
        (new EmuText(col2, EMU_BASE, element_width, element_height, "[c_aqua]Data instances"))
            .SetUpdate(function() {
                var type = Stuff.data.GetActiveType();
                self.text = "[c_aqua]" + (type ? type.name : "No data selected...");
            }),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Instances:", element_height, 16, function() {
            self.GetSibling("PROPERTIES").Refresh();
            self.GetSibling("CONTROLS").Refresh();
        }))
            .SetRefresh(function() {
                self.Deselect();
                var type = Stuff.data.GetActiveType();
                self.SetInteractive(!!type);
                
                if (!type) return;
                
                self.SetList(type.instances);
                if (!array_empty(type.instances)) {
                    self.Select(0);
                    self.GetSibling("PROPERTIES").Refresh();
                }
            })
            .SetVacantText("no instances")
            .SetListColors(emu_color_data_instances)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetNumbered(true)
            .SetCallbackMiddle(function() {
                (emu_dialog_confirm(self.root, "Do you want to alphabetize all instances of " + Stuff.data.GetActiveType().name + "?", function() {
                    var data = Stuff.data.GetActiveType();
                    var current = Stuff.data.GetActiveInstance();
                    
                    array_sort_name(data.instances);
                    self.root.Deselect();
                    for (var i = 0, n = array_length(data.instances); i < n; i++) {
                        if (data.instances[i] == current) {
                            self.root.Select(i, true);
                            break;
                        }
                    }
                    
                    emu_dialog_close_auto();
                })).contents_interactive = true;
            })
            .SetID("INSTANCES"),
        (new EmuCore(col2, EMU_AUTO, element_width, element_height)).AddContent([
            (new EmuButton(0, 0, element_width, element_height, "Move Up", function() {
                var data = Stuff.data.GetActiveType();
                var selection = self.root.GetSibling("INSTANCES").GetSelection();
                if (selection == -1) return;
                
                var t = data.instances[selection - 1];
                data.instances[selection - 1] = data.instances[selection];
                data.instances[selection] = t;
                self.root.GetSibling("INSTANCES").Deselect();
                self.root.GetSibling("INSTANCES").Select(selection - 1, true);
            }))
                .SetRefresh(function() { self.SetInteractive(Stuff.data.GetActiveType() && self.root.GetSibling("INSTANCES").GetSelection() > 0); }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Move Down", function() {
                var data = Stuff.data.GetActiveType();
                var selection = self.root.GetSibling("INSTANCES").GetSelection();
                if (selection == -1) return;
                var instance = data.instances[selection];
            
                var t = data.instances[selection + 1];
                data.instances[selection + 1] = data.instances[selection];
                data.instances[selection] = t;
                self.root.GetSibling("INSTANCES").Deselect();
                self.root.GetSibling("INSTANCES").Select(selection + 1, true);
            }))
                .SetRefresh(function() {
                    var type = Stuff.data.GetActiveType();
                    self.SetInteractive(type && self.root.GetSibling("INSTANCES").GetSelection() < array_length(type.instances) - 1);
                }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Add Instance", function() {
                var instance_list = self.root.GetSibling("INSTANCES");
                var index = instance_list.GetSelection();
                var type = Stuff.data.GetActiveType();
                var index_to_add = (index == -1) ? array_length(type.instances) : index + 1;
                type.AddInstance(undefined, index_to_add);
                instance_list.Deselect();
                instance_list.Select(index_to_add, true);
            }))
                .SetID("ADD INSTANCE")
                .SetRefresh(function() { self.SetInteractive(!!Stuff.data.GetActiveType()); }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Delete Instance", function() {
                var data = Stuff.data.GetActiveType();
                var selection = self.root.GetSibling("LIST").GetSelection();
                if (selection == -1) return;
                var instance = data.instances[selection];
            
                self.root.GetSibling("INSTANCES").Deselect();
                data.RemoveInstance(instance);
                instance.Destroy();
            }))
                .SetRefresh(function() { self.SetInteractive(!!Stuff.data.GetActiveType()); }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Duplicate Instance", function() {
                var data = Stuff.data.GetActiveType();
                var instance_list = self.root.GetSibling("INSTANCES");
                var selection = instance_list.GetSelection();
                if (selection == -1) return;
                var instance = data.instances[selection];
            
                if (instance) {
                    data.AddInstance(instance.Clone(), selection + 1);
                    instance_list.Deselect();
                    instance_list.Select(selection + 1, true);
                }
            }))
                .SetRefresh(function() { self.SetInteractive(!!Stuff.data.GetActiveType()); }),
        ])
            .SetID("CONTROLS"),
        (new EmuButton(col3 + 0 * element_width / 3, EMU_BASE, element_width / 6, element_height, "<", function() {
            // this can be inlined and probably should be updated for emu
            omu_data_previous();
        }))
            .SetRefresh(function() { self.SetInteractive(!!Stuff.data.GetActiveType()); })
            .SetID("PREVIOUS"),
        (new EmuText(col3 + 1 * element_width / 6 + 8, EMU_BASE, element_width, element_height, "[c_aqua]Page X/Y"))
            .SetRefresh(function() {
            })
            .SetID("PAGENUM"),
        (new EmuButton(col3 + 2 * element_width / 3, EMU_BASE, element_width / 6, element_height, ">", function() {
            // this can be inlined and probably should be updated for emu
            omu_data_next();
        }))
            .SetRefresh(function() { self.SetInteractive(!!Stuff.data.GetActiveType()); })
            .SetID("NEXT"),
        // we used to use ui_render_columns for this but i think we can get around that with containers now
        (new EmuCore(col3, EMU_AUTO, hud_width * 3 / 5, hud_height - 32))
            .SetID("PROPERTIES")
    ]);
    
    return container;
}