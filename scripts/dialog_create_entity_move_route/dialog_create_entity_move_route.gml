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
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Loop Route", route.repeat_action, function() {
            self.root.route.repeat_action = self.value;
        })),
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Skip if Blocked", route.skip, function() {
            self.root.route.skip = self.value;
        })),
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Wait for Completion", route.wait, function() {
            self.root.route.wait = self.value;
        })),
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Steps:", element_height, 10, emu_null))
            .SetEntryTypes(E_ListEntryTypes.SCRIPTS, function(index) {
                // formerly ui_render_list_move_route_steps
                return "implement this";
            })
            .SetList(route.steps)
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Edit Step", function() {
        }))
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
            .SetRefresh(function() {
                self.SetInteractive(self.GetSibling("LIST").GetSelection() != -1);
            }),
        #endregion
    ])
        .SetDefaultSpacingY(0)
        .AddContent([
        #region column 2
        new EmuButton(col2, 16, element_width, element_height, "Move Down", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_DOWN, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Left", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_LEFT, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Right", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_RIGHT, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Up", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_UP, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Lower Left", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_LOWER_LEFT, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Lower Right", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_LOWER_RIGHT, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Upper Left", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_UPPER_LEFT, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Upper Right", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_UPPER_RIGHT, 1]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Randomly", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_RANDOM]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Towards Player", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_TOWARDS_PLAYER]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Away From Player", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_AWAY_PLAYER]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Forward", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_FORWARD]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move Back", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_BACKWARD]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Move to Coordinates...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_TO, 0, 0]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Jump to Position...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_JUMP, "MAP", 0, 0, 0, 0]);
        }),
        new EmuButton(col2, EMU_AUTO, element_width, element_height, "Jump in Place", function() {
            array_push(self.root.route.steps, [MoveRouteActions.MOVE_ACTUALLY_JUMP, 0]);
        }),
        #endregion
        #region column 3
        new EmuButton(col3, 16, element_width, element_height, "Turn Down", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_DOWN]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Left", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_LEFT]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Right", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_RIGHT]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Up", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_UP]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 90° Left", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_90_LEFT]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 90° Right", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_90_RIGHT]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 180°", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_180]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn 90° Left Or Right", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_90_RANDOM]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Randomly", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_RANDOM]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Towards Player", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_TOWARD_PLAYER]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Turn Away From Player", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TURN_AWAY_PLAYER]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Self Switch...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.SWITCH, 0, false]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Self Variable...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.VARIABLE, 0, 0]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Change Move Speed...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.CHANGE_SPEED, 0]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Change Move Frequency...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.CHANGE_FREQUENCY, 0]);
        }),
        new EmuButton(col3, EMU_AUTO, element_width, element_height, "Wait...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.WAIT, 1]);
        }),
        #endregion
        #region column 4
        new EmuButton(col4, 16, element_width, element_height, "Walk Animation: On", function() {
            array_push(self.root.route.steps, [MoveRouteActions.WALKING_ANIM_ON]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Walk Animation: Off", function() {
            array_push(self.root.route.steps, [MoveRouteActions.WALKING_ANIM_OFF]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Step Animation: On", function() {
            array_push(self.root.route.steps, [MoveRouteActions.STEPPING_ANIM_ON]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Step Animation: Off", function() {
            array_push(self.root.route.steps, [MoveRouteActions.STEPPING_ANIM_OFF]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Direction Fix: On", function() {
            array_push(self.root.route.steps, [MoveRouteActions.DIRECTION_FIX_ON]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Direction Fix: Off", function() {
            array_push(self.root.route.steps, [MoveRouteActions.DIRECTION_FIX_OFF]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Solid: On", function() {
            array_push(self.root.route.steps, [MoveRouteActions.SOLID_ON]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Solid: Off", function() {
            array_push(self.root.route.steps, [MoveRouteActions.SOLID_OFF]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Transparent: On", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TRANSPARENT_ON]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Transparent: Off", function() {
            array_push(self.root.route.steps, [MoveRouteActions.TRANSPARENT_OFF]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set Sprite...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.CHANGE_SPRITE, NULL]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set Model...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.CHANGE_MODEL, NULL]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set alpha...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.CHANGE_OPACITY, 1]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Set tint...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.CHANGE_TINT, c_white]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Play sound effect...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.PLAY_SE, NULL]);
        }),
        new EmuButton(col4, EMU_AUTO, element_width, element_height, "Execute event...", function() {
            array_push(self.root.route.steps, [MoveRouteActions.EVENT, NULL]);
        }),
        #endregion
    ]).AddDefaultCloseButton();
}