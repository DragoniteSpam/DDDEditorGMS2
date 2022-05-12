function dialog_create_entity_autonomous_movement() {
    var entity = Stuff.map.selected_entities[| 0];
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Autonomous Movement");
    dialog.entity = entity;
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    
    var f_route_callback = function() {
        dialog_create_entity_move_route(self.GetSibling("LIST").GetSelectedItem());
    };
    
    return dialog.AddContent([
        (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "Movement type:", entity.autonomous_movement, function() {
            self.root.entity.autonomous_movement = self.value;
        }))
            .AddOptions(["Fixed", "Random", "Approach", "Custom"])
            .SetTooltip("The type of random movement the Pawn will have on the overworld."),
        (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "Movement speed:", entity.autonomous_movement_speed, function() {
            self.root.entity.autonomous_movement_speed = self.value;
        }))
            .AddOptions(["1/8x, 1/4x, 1/2x, 1x, 2x, 4x"])
            .SetTooltip("How fast the Pawn will move around."),
        (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "Movement frequency:", entity.autonomous_movement_frequency, function() {
            self.root.entity.autonomous_movement_frequency = self.value;
        }))
            .AddOptions(["Slowest", "Slow", "Normal", "Fast", "Fastest"])
            .SetTooltip("How frequently the Pawn will engage in random movement."),
        (new EmuList(col2, EMU_BASE, element_width, element_height, "Move Routes:", element_height, 8, function() {
            if (self.root) self.root.Refresh(self.GetSelection());
        }))
            .SetCallbackDouble(f_route_callback)
            .SetList(entity.movement_routes)
            .SetVacantText("<No movement routes>")
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST"),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Edit Movement Route", f_route_callback))
            .SetRefresh(function(index) {
                self.SetInteractive(index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Edit the selected movement route."),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Add Movement Route", function() {
            array_push(self.root.entity.movement_routes, new MoveRoute("MoveRoute " + string(array_length(self.root.entity.movement_routes))));
        }))
            .SetRefresh(function(index) {
                self.SetInteractive(array_length(self.root.entity.movement_routes) < 0xff);
            })
            .SetTooltip("Add a movement route."),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Delete Movement Route", function() {
            var route = self.root.entity.movement_routes[self.GetSibling("LIST").GetSelection()];
            var dialog = emu_dialog_confirm(self, "Delete " + route.name + "?", function() {
                array_delete(self.root.entity.movement_routes, self.root.root.GetSibling("LIST").GetSelection(), 1);
                emu_dialog_close_auto();
            });
            dialog.entity = self.root.entity;
        }))
            .SetInteractive(false)
            .SetRefresh(function(index) {
                self.SetInteractive(index != -1);
            })
            .SetTooltip("Delete the selected movement route."),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Set Auto", function() {
            var entity = self.root.entity;
            var selection = self.GetSibling("LIST").GetSelection();
            entity.autonomous_movement_route = (selection == -1) ? NULL : entity.movement_routes[selection].GUID;
        }))
            .SetInteractive(false)
            .SetRefresh(function(index) {
                self.text = (array_length(self.root.entity.movement_routes) > 0) ? "Set Auto Route" : "Remove Auto Route";
                self.SetInteractive(index != -1);
            })
            .SetTooltip("Set the selected movement route to run automatically."),
    ]).AddDefaultCloseButton();
}
