function dialog_create_entity_move_route(route) {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32 + 320 + 32, 704, "Edit Movement Route");
    dialog.route = route;
    
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    var col4 = 32 + 320 + 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        #region main stuff
        (new EmuInput(col1, EMU_BASE, element_width, element_height, "Name:", route.name, "Movement route name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.root.route.name = self.value;
        })),
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Steps:", element_height, 10, function() {
            if (!self.root) return;
            self.root.Refresh();
        }))
            .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                return self.At(index).toString();
            })
            .SetList(route.steps)
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Move Up", function() {
            var selection = self.GetSibling("LIST").GetSelection();
            var t = self.root.route.steps[selection];
            self.root.route.steps[selection] = self.root.route.steps[selection - 1];
            self.root.route.steps[selection - 1] = t;
            self.GetSibling("LIST").Deselect();
            self.GetSibling("LIST").Select(selection - 1, true);
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(self.GetSibling("LIST").GetSelection() >= 1);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Move Down", function() {
            var selection = self.GetSibling("LIST").GetSelection();
            var t = self.root.route.steps[selection];
            self.root.route.steps[selection] = self.root.route.steps[selection + 1];
            self.root.route.steps[selection + 1] = t;
            self.GetSibling("LIST").Deselect();
            self.GetSibling("LIST").Select(selection + 1, true);
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(self.GetSibling("LIST").GetSelection() != -1 && self.GetSibling("LIST").GetSelection() < array_length(self.root.route.steps) - 1);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Edit Step", function() {
            self.GetSibling("LIST").GetSelectedItem().Edit();
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(self.GetSibling("LIST").GetSelection() != -1);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Delete Step", function() {
            var index = self.GetSibling("LIST").GetSelection();
            array_delete(self.root.route.steps, index, 1);
            if (index >= array_length(self.root.route.steps)) {
                self.GetSibling("LIST").Deselect();
            }
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(self.GetSibling("LIST").GetSelection() != -1);
            }),
        #endregion
    ])
        .SetDefaultSpacingY(0)
        .AddContent([
        #region column 2
        (new EmuCheckbox(col2, 16, element_width, element_height, "Loop Route", route.repeat_action, function() {
            self.root.route.repeat_action = self.value;
        })),
        new EmuButton(col2, 16 + 16 + element_height, element_width, element_height, "Move Down", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveDown());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Left", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveLeft());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Right", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveRight());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Up", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveUp());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Lower Left", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveLowerLeft());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Lower Right", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveLowerRight());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Upper Left", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveUpperLeft());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Upper Right", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveUpperRight());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Randomly", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveRandom());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Towards Player", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveTowardsPlayer());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Away From Player", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveAwayFromPlayer());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Forward", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveForward());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Back", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveBackward());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move to...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_MoveTo());
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Jump in Place...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_Jump());
        }),
        #endregion
        #region column 3
        (new EmuCheckbox(col3, 16, element_width, element_height, "Skip if Blocked", route.skip, function() {
            self.root.route.skip = self.value;
        })),
        new EmuButton(col3, 16 + 16 + element_height, element_width, element_height, "Turn Down", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnDown());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Left", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnLeft());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Right", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnRight());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Up", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnUp());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 90° Left", function() {
            array_push(self.root.route.steps, new MoveRouteAction_Turn90Left());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 90° Right", function() {
            array_push(self.root.route.steps, new MoveRouteAction_Turn90Right());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 180°", function() {
            array_push(self.root.route.steps, new MoveRouteAction_Turn180());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 90° Left Or Right", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnLeftOrRight());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Randomly", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnRandom());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Towards Player", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnTowardsPlayer());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Away From Player", function() {
            array_push(self.root.route.steps, new MoveRouteAction_TurnAwayFromPlayer());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Self Switch...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SelfSwitch());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Self Variable...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SelfVariable());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Change Move Speed...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetSpeed());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Change Move Frequency...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetFrequency());
        }),
        #endregion
        #region column 4
        (new EmuCheckbox(col4, 16, element_width, element_height, "Wait for Completion", route.wait, function() {
            self.root.route.wait = self.value;
        })),
        new EmuButton(col4, 16 + 16 + element_height, element_width, element_height, "Set Walk Animation...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetWalking());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set Step Animation...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetStepping());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set Direction Fix...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetDirectionFix());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set SpriteRenderer...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetSprite());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set ModelRenderer...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetMesh());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set alpha...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetOpacity());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set tint...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_SetTint());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Play sound effect...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_PlaySound());
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Execute event...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_Event());
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Wait...", function() {
            array_push(self.root.route.steps, new MoveRouteAction_Wait());
        }),
        #endregion
    ]).AddDefaultCloseButton();
}