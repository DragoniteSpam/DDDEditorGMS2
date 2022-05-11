function dialog_create_entity_move_route(route) {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 704, "Edit Movement Route");
    dialog.route = route;
    
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
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
    ]).AddDefaultCloseButton();
    
    
    
    
    
    
    
    var el_cmd_move_down = create_button(c2 + 16, yy, "Move Down", ew, eh, fa_center, omu_mr_move_down, dg);
    yy += el_cmd_move_down.height + spacing2;
    var el_cmd_move_left = create_button(c2 + 16, yy, "Move Left", ew, eh, fa_center, omu_mr_move_left, dg);
    yy += el_cmd_move_left.height + spacing2;
    var el_cmd_move_right = create_button(c2 + 16, yy, "Move Right", ew, eh, fa_center, omu_mr_move_right, dg);
    yy += el_cmd_move_right.height + spacing2;
    var el_cmd_move_up = create_button(c2 + 16, yy, "Move Up", ew, eh, fa_center, omu_mr_move_up, dg);
    yy += el_cmd_move_up.height + spacing2;
    var el_cmd_move_ll = create_button(c2 + 16, yy, "Move Lower Left", ew, eh, fa_center, omu_mr_move_lower_left, dg);
    yy += el_cmd_move_ll.height + spacing2;
    var el_cmd_move_lr = create_button(c2 + 16, yy, "Move Lower Right", ew, eh, fa_center, omu_mr_move_lower_right, dg);
    yy += el_cmd_move_lr.height + spacing2;
    var el_cmd_move_ul = create_button(c2 + 16, yy, "Move Upper Left", ew, eh, fa_center, omu_mr_move_upper_left, dg);
    yy += el_cmd_move_ul.height + spacing2;
    var el_cmd_move_ur = create_button(c2 + 16, yy, "Move Upper Right", ew, eh, fa_center, omu_mr_move_upper_right, dg);
    yy += el_cmd_move_ur.height + spacing2;
    var el_cmd_move_random = create_button(c2 + 16, yy, "Move Randomly", ew, eh, fa_center, omu_mr_move_random, dg);                // break visible route
    yy += el_cmd_move_random.height + spacing2;
    var el_cmd_move_towards = create_button(c2 + 16, yy, "Move Towards Player", ew, eh, fa_center, omu_mr_move_towards_player, dg); // break visible route
    yy += el_cmd_move_towards.height + spacing2;
    var el_cmd_move_away = create_button(c2 + 16, yy, "Move Away from Player", ew, eh, fa_center, omu_mr_move_away_player, dg);     // break visible route
    yy += el_cmd_move_away.height + spacing2;
    var el_cmd_move_forward = create_button(c2 + 16, yy, "Move Forward", ew, eh, fa_center, omu_mr_move_forward, dg);               // break visible route
    yy += el_cmd_move_forward.height + spacing2;
    var el_cmd_move_backward = create_button(c2 + 16, yy, "Move Back", ew, eh, fa_center, omu_mr_move_backward, dg);                // break visible route
    yy += el_cmd_move_backward.height + spacing2;
    // open the form to edit these properties - store as relative coordinates
    var el_cmd_move_exactly = create_button(c2 + 16, yy, "Move To Exactly", ew, eh, fa_center, omu_mr_move_to_exactly, dg);
    yy += el_cmd_move_exactly.height + spacing2;
    // open the form to edit these properties
    var el_cmd_move_jump = create_button(c2 + 16, yy, "Jump (Position)", ew, eh, fa_center, omu_mr_move_jump, dg);
    yy += el_cmd_move_jump.height + spacing2;
    // open the form to edit these properties
    var el_cmd_move_hop = create_button(c2 + 16, yy, "Jump (in the air)", ew, eh, fa_center, omu_mr_move_actually_jump, dg);

    yy = yy_grid;

    var el_cmd_turn_down = create_button(c3 + 16, yy, "Turn Down", ew, eh, fa_center, omu_mr_turn_down, dg);
    yy += el_cmd_turn_down.height + spacing2;
    var el_cmd_turn_left = create_button(c3 + 16, yy, "Turn Left", ew, eh, fa_center, omu_mr_turn_left, dg);
    yy += el_cmd_turn_left.height + spacing2;
    var el_cmd_turn_right = create_button(c3 + 16, yy, "Turn Right", ew, eh, fa_center, omu_mr_turn_right, dg);
    yy += el_cmd_turn_right.height + spacing2;
    var el_cmd_turn_up = create_button(c3 + 16, yy, "Turn Up", ew, eh, fa_center, omu_mr_turn_up, dg);
    yy += el_cmd_turn_up.height + spacing2;
    var el_cmd_turn_90_right = create_button(c3 + 16, yy, "Turn 90° Right", ew, eh, fa_center, omu_mr_turn_90_right, dg);
    yy += el_cmd_turn_90_right.height + spacing2;
    var el_cmd_turn_90_left = create_button(c3 + 16, yy, "Turn 90° Left", ew, eh, fa_center, omu_mr_turn_90_left, dg);
    yy += el_cmd_turn_90_left.height + spacing2;
    var el_cmd_turn_180 = create_button(c3 + 16, yy, "Turn 180°", ew, eh, fa_center, omu_mr_turn_180, dg);
    yy += el_cmd_turn_180.height + spacing2;
    var el_cmd_turn_90_random = create_button(c3 + 16, yy, "Turn 90° Left or Right", ew, eh, fa_center, omu_mr_turn_90_random, dg);
    yy += el_cmd_turn_90_random.height + spacing2;
    var el_cmd_turn_random = create_button(c3 + 16, yy, "Turn Randomly", ew, eh, fa_center, omu_mr_turn_random, dg);
    yy += el_cmd_turn_random.height + spacing2;
    var el_cmd_turn_towards = create_button(c3 + 16, yy, "Turn Towards Player", ew, eh, fa_center, omu_mr_turn_toward_player, dg);
    yy += el_cmd_turn_towards.height + spacing2;
    var el_cmd_turn_away = create_button(c3 + 16, yy, "Turn Away from Player", ew, eh, fa_center, omu_mr_turn_away_player, dg);
    yy += el_cmd_turn_away.height + spacing2;
    // this
    var el_cmd_switch_on = create_button(c3 + 16, yy, "Self Switch: On", ew, eh, fa_center, omu_mr_switch_on, dg);
    yy += el_cmd_switch_on.height + spacing2;
    // this
    var el_cmd_switch_off = create_button(c3 + 16, yy, "Self Switch: Off", ew, eh, fa_center, omu_mr_switch_off, dg);
    yy += el_cmd_switch_off.height + spacing2;
    // this
    var el_cmd_change_speed = create_button(c3 + 16, yy, "Change Move Speed", ew, eh, fa_center, omu_mr_change_speed, dg);
    yy += el_cmd_change_speed.height + spacing2;
    // this
    var el_cmd_change_frequency = create_button(c3 + 16, yy, "Change Move Frequency", ew, eh, fa_center, omu_mr_change_frequency, dg);

    yy=yy_grid;

    var el_cmd_walk_anim_on = create_button(c4 + 16, yy, "Walk Animation: On", ew, eh, fa_center, omu_mr_walking_on, dg);
    yy += el_cmd_walk_anim_on.height + spacing2;
    var el_cmd_walk_anim_off = create_button(c4 + 16, yy, "Walk Animation: Off", ew, eh, fa_center, omu_mr_walking_off, dg);
    yy += el_cmd_walk_anim_off.height + spacing2;
    var el_cmd_step_anim_on = create_button(c4 + 16, yy, "Step Animation: On", ew, eh, fa_center, omu_mr_stepping_on, dg);
    yy += el_cmd_step_anim_on.height + spacing2;
    var el_cmd_step_anim_off = create_button(c4 + 16, yy, "Step Animation: Off", ew, eh, fa_center, omu_mr_stepping_off, dg);
    yy += el_cmd_step_anim_off.height + spacing2;
    var el_cmd_direction_fix_on = create_button(c4 + 16, yy, "Direction Fix: On", ew, eh, fa_center, omu_mr_direction_fix_on, dg);
    yy += el_cmd_direction_fix_on.height + spacing2;
    var el_cmd_direction_fix_off = create_button(c4 + 16, yy, "Direction Fix: Off", ew, eh, fa_center, omu_mr_direction_fix_off, dg);
    yy += el_cmd_direction_fix_off.height + spacing2;
    var el_cmd_solid_on = create_button(c4 + 16, yy, "Solid: On", ew, eh, fa_center, omu_mr_solid_on, dg);
    yy += el_cmd_solid_on.height + spacing2;
    var el_cmd_solid_off = create_button(c4 + 16, yy, "Solid: Off", ew, eh, fa_center, omu_mr_solid_off, dg);
    yy += el_cmd_solid_off.height + spacing2;
    var el_cmd_transparent_on = create_button(c4 + 16, yy, "Transparent: On", ew, eh, fa_center, omu_mr_transparent_on, dg);
    yy += el_cmd_transparent_on.height + spacing2;
    var el_cmd_transparent_off = create_button(c4 + 16, yy, "Transparent: Off", ew, eh, fa_center, omu_mr_transparent_off, dg);
    yy += el_cmd_transparent_off.height + spacing2;
    // this
    var el_cmd_change_graphic = create_button(c4 + 16, yy, "Change Graphic", ew, eh, fa_center, omu_mr_change_graphic, dg);
    yy += el_cmd_change_graphic.height + spacing2;
    // this
    var el_cmd_change_alpha = create_button(c4 + 16, yy, "Change Alpha", ew, eh, fa_center, omu_mr_change_alpha, dg);
    yy += el_cmd_change_alpha.height + spacing2;
    // this
    var el_cmd_change_tint = create_button(c4 + 16, yy, "Change Tint", ew, eh, fa_center, omu_mr_change_color, dg);
    yy += el_cmd_change_tint.height + spacing2;
    // this
    var el_cmd_play_se = create_button(c4 + 16, yy, "Play Sound Effect", ew, eh, fa_center, omu_mr_play_se, dg);
    yy += el_cmd_play_se.height + spacing2;
    // this
    var el_cmd_event = create_button(c4 + 16, yy, "Execute Event", ew, eh, fa_center, omu_mr_event, dg);
}