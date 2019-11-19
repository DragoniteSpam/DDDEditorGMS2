/// @param EditorModeEvent

var mode = argument0;

with (instance_create_depth(0, 0, 0, UIMain)) {
    t_events = create_tab("Events", 0, id);
    t_list = create_tab("Node List", 0, id);
    t_custom = create_tab("Custom", 0, id);
    t_action1 = create_tab("Actions1", 1, id);
    t_action2 = create_tab("Actions2", 1, id);
    
    var tr = ds_list_create();
    ds_list_add(tr, t_events, t_list, t_custom);
    
    ds_list_add(tabs, tr);
    
    var tr = ds_list_create();
    ds_list_add(tr, t_action1, t_action2);
    
    ds_list_add(tabs, tr);
    
    active_tab = t_list;
    
    // there is only enough space for one column
    
    var element;
    var spacing = 16;
    var legal_x = 32;
    var legal_y = 128;
    var element_width = view_hud_width_event - 96;
    
    var slots = 28;
    // element_height is an object variable that's already been defined
    
    #region node list
    
    var yy = legal_y;
    
    element = create_text(legal_x + spacing, yy, "<active node>", element_width, element_height, fa_left, element_width, t_list);
    element.render = ui_render_text_active_node;
    ds_list_add(t_list.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_list(legal_x + spacing, yy, "Event Nodes", "No nodes available!", element_width, spacing, slots, uivc_list_selection_event_node, false, t_list, noone);
    element.entries_are = ListEntries.INSTANCES;
    element.render = ui_render_list_event_node;
    ds_list_add(t_list.contents, element);
    
    yy = yy + element_height + spacing + element.height * element.slots;
    
    element = create_text(legal_x + spacing, yy, "Quick Add", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_list.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Entrypoint", element_width, element_height, fa_left, omu_event_add_entrypoint, t_list);
    ds_list_add(t_list.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Text Node", element_width, element_height, fa_left, omu_event_add_text, t_list);
    ds_list_add(t_list.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Custom", element_width, element_height, fa_left, omu_event_custom_dialog, t_list);
    ds_list_add(t_list.contents, element);
	
	yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Prefab", element_width, element_height, fa_left, null, t_list);
    ds_list_add(t_list.contents, element);
    
    #endregion
    
    #region custom nodes
    
    var yy = legal_y;
    var slots = 12;
    
    element = create_button(legal_x + spacing, yy, "Help?", element_width, element_height, fa_center, omu_event_custom_help, t_custom);
    ds_list_add(t_custom.contents, element);
    
    yy = yy + element_height+spacing;
    
    el_list_custom = create_list(legal_x + spacing, yy, "Custom Nodes", "<none>", element_width, spacing, slots, null, false, t_custom, Stuff.all_event_custom);
    el_list_custom.entries_are = ListEntries.INSTANCES;
    el_list_custom.colorized = false;
    ds_list_add(t_custom.contents, el_list_custom);
    
    yy = yy + ui_get_list_height(el_list_custom) + spacing;
    
    element = create_button(legal_x + spacing, yy, "Add Custom Node", element_width, element_height, fa_center, omu_event_add_custom_event, t_custom);
    ds_list_add(t_custom.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Remove Custom Node", element_width, element_height, fa_center, omu_event_remove_custom_event, t_custom);
    ds_list_add(t_custom.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Edit Custom Node", element_width, element_height, fa_center, omu_event_edit_custom_event, t_custom);
    ds_list_add(t_custom.contents, element);
    
    yy = yy + element_height + spacing;
    
    // todo all these
     el_list_prefabs = create_list(legal_x + spacing, yy, "Node Prefabs", "<none>", element_width, spacing, slots, null, false, t_custom, Stuff.all_event_prefabs);
    el_list_prefabs.entries_are = ListEntries.INSTANCES;
    el_list_prefabs.colorized = false;
    ds_list_add(t_custom.contents, el_list_prefabs);
    
    yy = yy + ui_get_list_height(el_list_prefabs) + spacing;
    
	element = create_text(legal_x + spacing, yy, "Click the button on an existing node to save it as a prefab", element_width, element_height, fa_left, element_width, t_custom);
    ds_list_add(t_custom.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Remove Prefab", element_width, element_height, fa_center, null, t_custom);
    ds_list_add(t_custom.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Rename Prefab", element_width, element_height, fa_center, null, t_custom);
    ds_list_add(t_custom.contents, element);
    
    #endregion
    
    #region event list
    
    var yy = legal_y;
    
    element = create_text(legal_x + spacing, yy, "", element_width, element_height, fa_left, element_width, t_list);
    element.render = ui_render_text_active_node;
    ds_list_add(t_events.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_list(legal_x + spacing, yy, "All Events", "No events!", element_width, spacing, 32, uivc_list_selection_event, false, t_events, Stuff.all_events);
    element.entries_are = ListEntries.INSTANCES;
    ds_list_add(t_events.contents, element);
    
    t_events.el_event_list = element;
    
    yy = yy + element_height + spacing + element.height * element.slots;
    
    element = create_button(legal_x + spacing, yy, "Add Event", element_width, element_height, fa_left, omu_event_add_event, t_events);
    ds_list_add(t_events.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Rename", element_width, element_height, fa_left, omu_event_rename_event, t_events);
    ds_list_add(t_events.contents, element);
    
    yy = yy + element_height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Delete", element_width, element_height, fa_left, omu_event_remove_event, t_events);
    ds_list_add(t_events.contents, element);
    
    yy = yy + element_height + spacing;
    
    #endregion
    
    #region event list 1
    
    yy = legal_y;
    
    element = create_text(legal_x + spacing, yy, "Message", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Show Text", element_width, element_height, fa_left, omu_event_add_text, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Show Choices", element_width, element_height, fa_left, omu_event_add_choices, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Input Text", element_width, element_height, fa_left, omu_event_add_input_text, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Show Scrolling Text", element_width, element_height, fa_left, omu_event_add_scrolling_text, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Data", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Control Switches", element_width, element_height, fa_left, omu_event_add_global_switch, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Control Variables", element_width, element_height, fa_left, omu_event_add_global_variable, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Control Self Switches", element_width, element_height, fa_left, omu_event_add_self_switch, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Control Self Variables", element_width, element_height, fa_left, omu_event_add_self_variable, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Control Timer", element_width, element_height, fa_left, omu_event_add_timer, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Deactivate This Event", element_width, element_height, fa_left, omu_event_add_deactivate_event, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Flow Control", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Conditional Branch", element_width, element_height, fa_left, omu_event_add_conditional, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Comment", element_width, element_height, fa_left, omu_event_add_comment, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Timing", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Wait", element_width, element_height, fa_left, omu_event_add_wait, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Movement", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Transfer Player", element_width, element_height, fa_left, omu_event_add_transfer_player, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Set Entity Location", element_width, element_height, fa_left, not_yet_implemented, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Scroll Map", element_width, element_height, fa_left, not_yet_implemented, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Set Movement Route", element_width, element_height, fa_left, not_yet_implemented, t_action1);
    ds_list_add(t_action1.contents, element);
    yy = yy + element_height;
    
    #endregion
    
    #region event list 2
    
    yy = legal_y;
    
    element = create_text(legal_x + spacing, yy, "Screen", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Tint Screen", element_width, element_height, fa_left, omu_event_add_tint_screen, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Shake Screen", element_width, element_height, fa_left, omu_event_add_shake_screen, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Audio", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Play BGM", element_width, element_height, fa_left, omu_event_add_play_bgm, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Fade BGM", element_width, element_height, fa_left, omu_event_add_fade_bgm, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Resume Automatic BGM", element_width, element_height, fa_left, omu_event_add_resume_bgm, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Play SE", element_width, element_height, fa_left, omu_event_add_play_se, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Stop All SE", element_width, element_height, fa_left, omu_event_add_stop_se, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Scene", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Return to Title Screen", element_width, element_height, fa_left, not_yet_implemented, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Map", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height + spacing;
    element = create_button(legal_x + spacing, yy, "Change Map Display Name", element_width, element_height, fa_left, omu_event_add_change_map_name, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Change Map Tileset", element_width, element_height, fa_left, not_yet_implemented, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Change Map Battle Scene", element_width, element_height, fa_left, not_yet_implemented, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Change Map Parallax", element_width, element_height, fa_left, not_yet_implemented, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    
    yy = yy + spacing;
    
    element = create_text(legal_x + spacing, yy, "Advanced", element_width, element_height, fa_left, element_width, t_list);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Script", element_width, element_height, fa_left, omu_event_add_script, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Audio Controls", element_width, element_height, fa_left, not_yet_implemented, t_action2);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
	// these are last
	yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Custom", element_width, element_height, fa_left, omu_event_custom_dialog, t_list);
    ds_list_add(t_action2.contents, element);
	yy = yy + element_height;
    element = create_button(legal_x + spacing, yy, "Prefab", element_width, element_height, fa_left, null, t_list);
    ds_list_add(t_action2.contents, element);
    yy = yy + element_height;
    #endregion
    
    return id;
}