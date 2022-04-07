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
            if (array_empty(Game.data)) {
                momu_data_types();
            } else {
                var selection = self.GetSelection();
                if (selection == -1 || Game.data[selection] != Stuff.data.GetActiveType()) {
                    ui_init_game_data_activate();
                }
            }
        }))
            .SetList(Game.data)
            .SetVacantText("click to define...")
            .SetListColors(function(index) {
                return (Game.data[index].type == DataTypes.ENUM) ? c_aqua : EMU_COLOR_TEXT;
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST"),
        (new EmuText(col2, EMU_BASE, element_width, element_height, "[c_aqua]Data instances"))
            .SetUpdate(function() {
                var type = Stuff.data.GetActiveType();
                self.text = "[c_aqua]" + (type ? type.name : "No data selected...");
            }),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Instances:", element_height, 16, function() {
            //ui_init_game_data_refresh();
        }))
            .SetVacantText("no instances")
            .SetListColors(function(index) {
                var inst = Stuff.data.GetActiveType().instances[index];
                if (string_copy(inst.name, 1, 1) == "+") return c_yellow;
                if (string_copy(inst.name, 1, 3) == "---") return c_aqua;
                return c_white;
            })
        // what was ui_render_list_data_instances used for in the past?
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetNumbered(true)
            .SetCallbackMiddle(dialog_create_data_instance_alphabetize) // this can be done inline pretty easily now with a yes/no prompt
            .SetID("INSTANCES"),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Up", function() {
            var data = Stuff.data.GetActiveType();
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection == -1) return;
            var instance = data.instances[selection];
            
            if (instance && (selection > 0)) {
                var t = data.instances[selection - 1];
                data.instances[selection - 1] = instance;
                data.instances[selection] = t;
                self.GetSibling("INSTANCES").Deselect();
                self.GetSibling("INSTANCES").Select(selection - 1);
            }
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Down", function() {
            var data = Stuff.data.GetActiveType();
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection == -1) return;
            var instance = data.instances[selection];
            
            if (instance && (selection < array_length(data.instances) - 1)) {
                var t = data.instances[selection + 1];
                data.instances[selection + 1] = instance;
                data.instances[selection] = t;
                self.GetSibling("INSTANCES").Deselect();
                self.GetSibling("INSTANCES").Select(selection + 1);
            }
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Add Instance", function() {
            // this can be inlined, and also needs to be updated for Emu
            uimu_data_add_data();
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Delete Instance", function() {
            var data = Stuff.data.GetActiveType();
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection == -1) return;
            var instance = data.instances[selection];
            
            self.GetSibling("INSTANCES").Deselect();
            data.RemoveInstance(instance);
            instance.Destroy();
            ui_init_game_data_refresh();
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Duplicate Instance", function() {
            var data = Stuff.data.GetActiveType();
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection == -1) return;
            var instance = data.instances[selection];
            
            if (instance) {
                data.AddInstance(instance.Clone(), selection + 1);
            }
        }),
        (new EmuButton(col3 + 0 * element_width / 3, EMU_BASE, element_width / 6, element_height, "<", function() {
            // this can be inlined and probably should be updated for emu
            omu_data_previous();
        })),
        (new EmuText(col3 + 1 * element_width / 6 + 8, EMU_BASE, element_width, element_height, "[c_aqua]Page X/Y"))
            .SetRefresh(function() {
            }),
        (new EmuButton(col3 + 2 * element_width / 3, EMU_BASE, element_width / 6, element_height, ">", function() {
            // this can be inlined and probably should be updated for emu
            omu_data_next();
        })),
        // we used to use ui_render_columns for this but i think we can get around that with containers now
        (new EmuCore(col3, EMU_AUTO, element_width, element_height))
            .SetID("PROPERTIES")
    ]);
    
    return container;
}