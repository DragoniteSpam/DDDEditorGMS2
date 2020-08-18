/// @param Dialog
/// @param DataMoveRoute
function dialog_create_entity_move_route(argument0, argument1) {

	var dialog = argument0;
	var route = argument1;

	var dw = 1024;
	var dh = 560;

	// you can assume that this is valid data because this won't be called otherwise
	var list = Stuff.map.selected_entities;
	var entity = list[| 0];
	var dg = dialog_create(dw, dh, "Edit Move Route", dialog_default, dc_close_no_questions_asked, dialog);
	dg.route = route;

	var columns = 4;
	var spacing = 16;
	var spacing2 = 0;
	var ew = dw / columns - spacing * 2;
	var eh = 24;
	var eh2 = 20;

	var c2 = dw / columns;
	var c3 = dw * 2 / columns;
	var c4 = dw * 3 / columns;

	var vx1 = ew / 2;
	var vy1 = 0;
	var vx2 = ew;
	var vy2 = eh;

	var yy = 64;

	var n = 10;

	var el_name = create_input(16, yy, "Name:", ew * 2, eh, uivc_entity_move_route_name, route.name, "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2 + c2, vy2, dg);

	yy += el_name.height + spacing;

	var yy_grid = yy;

	var el_steps = create_list(16, yy, "Steps: ", "<No move route steps>", ew, eh2, n, null, false, dg);
	el_steps.numbered = true;
	el_steps.render = ui_render_list_move_route_steps;
	yy += ui_get_list_height(el_steps) + spacing;
	dg.el_steps = el_steps;

	var el_step_edit = create_button(16, yy, "Edit Step", ew, eh, fa_center, null, dg);
	yy += el_step_edit.height + spacing;

	var el_step_remove = create_button(16, yy, "Delete Step", ew, eh, fa_center, omu_entity_remove_move_route_step, dg);
	yy += el_step_remove.height + spacing;

	var el_repeat = create_checkbox(16, yy, "Loop Route", ew, eh, uivc_entity_move_route_loop, route.repeat_action, dg);
	yy += el_repeat.height + spacing;

	var el_skip = create_checkbox(16, yy, "Skip If Blocked", ew, eh, uivc_entity_move_route_skip, route.skip, dg);
	yy += el_skip.height + spacing;

	var el_wait = create_checkbox(16, yy, "Wait For Completion", ew, eh, uivc_entity_move_route_wait, route.wait, dg);
	yy += el_wait.height + spacing;

	yy = yy_grid;

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

	var b_width = 128;
	var b_height = 32;
	var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents,
	    el_name, el_steps, el_step_edit, el_step_remove, el_repeat, el_skip, el_wait,
	    // first column of commands
	    el_cmd_move_down, el_cmd_move_left, el_cmd_move_right, el_cmd_move_up, el_cmd_move_ll, el_cmd_move_lr,
	    el_cmd_move_ul, el_cmd_move_ur, el_cmd_move_random, el_cmd_move_towards, el_cmd_move_away, el_cmd_move_forward,
	    el_cmd_move_backward, el_cmd_move_exactly, el_cmd_move_jump, el_cmd_move_hop,
	    // second column of commands
	    el_cmd_turn_down, el_cmd_turn_left, el_cmd_turn_right, el_cmd_turn_up, el_cmd_turn_90_right, el_cmd_turn_90_left,
	    el_cmd_turn_180, el_cmd_turn_90_random, el_cmd_turn_random, el_cmd_turn_towards, el_cmd_turn_away, el_cmd_switch_on,
	    el_cmd_switch_off, el_cmd_change_speed,
	    // third column of commands
	    el_cmd_walk_anim_on, el_cmd_walk_anim_off, el_cmd_step_anim_on, el_cmd_step_anim_off, el_cmd_direction_fix_on,
	    el_cmd_direction_fix_off, el_cmd_solid_on, el_cmd_solid_off, el_cmd_transparent_on, el_cmd_transparent_off,
	    el_cmd_change_graphic, el_cmd_change_alpha, el_cmd_change_tint, el_cmd_play_se, el_cmd_event,
	    // return to normal
	    el_confirm
	);

	return dg;


}
