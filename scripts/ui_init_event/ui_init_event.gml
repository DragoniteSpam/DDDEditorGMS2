function ui_init_event(mode) {
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
        var list_entry_height = 24;
        var legal_x = 32;
        var legal_y = 128;
        var element_width = view_hud_width_event - 112;
        // element_height is an object variable that's already been defined
        
        #region event list
        var yy = legal_y;
        
        element = create_list(legal_x + spacing, yy, "All Events", "No events!", element_width, list_entry_height, 24, uivc_list_selection_event, false, t_events, Game.events.events);
        element.tooltip = "All of the event graphs currently defined. Middle-click the list to sort it alphabetically.";
        element.entries_are = ListEntries.INSTANCES;
        element.onmiddleclick = omu_event_list_alphabetize;
        ui_list_select(element, 0);
        ds_list_add(t_events.contents, element);
        
        t_events.el_event_list = element;
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(legal_x + spacing, yy, "Add Event", element_width, element_height, fa_center, function(button) {
            array_push(Game.events.events, new DataEvent("Event$" + string(array_length(Game.events.events))));
        }, t_events);
        element.tooltip = "Add a new event graph. Sequences can link to nodes on other graphs if you need to, but for organizational purposes you most likely want to keep them separate.";
        ds_list_add(t_events.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Rename", element_width, element_height, fa_center, omu_event_rename_event, t_events);
        element.tooltip = "Rename this event. Names do not have to be unique, but if you give more than one event the same name things will probably become confusing very quickly.";
        ds_list_add(t_events.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Delete", element_width, element_height, fa_center, omu_event_remove_event, t_events);
        element.tooltip = "Delete this event graph. Anything referencing any of the nodes on the graph will no longer work.";
        ds_list_add(t_events.contents, element);
        
        yy += element_height + spacing;
        #endregion
        
        #region node list
        var yy = legal_y;
        
        element = create_list(legal_x + spacing, yy, "Event Nodes", "No nodes available!", element_width, list_entry_height, 22, uivc_list_selection_event_node, false, t_list, noone);
        element.tooltip = "This is a list of all of the nodes on this event graph. Click on one to jump to its position. Middle-click the list to sort it alphabetically.";
        element.entries_are = ListEntries.INSTANCES;
        element.render = ui_render_list_event_node;
        element.onmiddleclick = omu_event_node_list_alphabetize;
        ds_list_add(t_list.contents, element);
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(legal_x + spacing, yy, "Entrypoint", element_width, element_height, fa_center, omu_event_add_entrypoint, t_list);
        element.tooltip = "Add an entrypoint node.";
        ds_list_add(t_list.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Text Node", element_width, element_height, fa_center, omu_event_add_text, t_list);
        element.tooltip = "Add a message text node.";
        ds_list_add(t_list.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Custom", element_width, element_height, fa_center, omu_event_custom_dialog, t_list);
        element.tooltip = "Add a custom-defined node.";
        ds_list_add(t_list.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Prefab", element_width, element_height, fa_center, omu_event_prefab_dialog, t_list);
        element.tooltip = "Add a prefab node.";
        ds_list_add(t_list.contents, element);
        #endregion
        
        #region custom nodes
        var yy = legal_y;
        
        el_list_custom = create_list(legal_x + spacing, yy, "Custom Nodes", "<none>", element_width, list_entry_height, 10, null, false, t_custom, Game.events.custom);
        el_list_custom.tooltip = "Any event you want that's specific to your game's data (for example, anything pertaining to Inventory) can be made from a custom event.\n\nYou can attach your own data types and even outbound nodes to custom events.";
        el_list_custom.entries_are = ListEntries.INSTANCES;
        el_list_custom.colorized = false;
        el_list_custom.ondoubleclick = omu_event_edit_custom_event;
        el_list_custom.onmiddleclick = omu_event_custom_list_alphabetize;
        ds_list_add(t_custom.contents, el_list_custom);
        
        yy += ui_get_list_height(el_list_custom) + spacing;
        
        element = create_button(legal_x + spacing, yy, "Add", element_width, element_height, fa_center, omu_event_add_custom_event, t_custom);
        element.tooltip = "Create a new custom event node.";
        ds_list_add(t_custom.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Delete", element_width, element_height, fa_center, omu_event_remove_custom_event, t_custom);
        element.tooltip = "Delete the selected custom event node. Any existing nodes based on the node you delete will also be deleted, and may leave gaps in the sequences that use them.";
        ds_list_add(t_custom.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Edit", element_width, element_height, fa_center, omu_event_edit_custom_event, t_custom);
        element.tooltip = "Edit the properties of the selected custom event node.";
        ds_list_add(t_custom.contents, element);
        
        yy += element_height + spacing;
        
        el_list_prefabs = create_list(legal_x + spacing, yy, "Node Prefabs", "<none>", element_width, list_entry_height, 8, null, false, t_custom, Game.events.prefabs);
        el_list_prefabs.tooltip = "If you have a particular event with particular data you invoke often, such as a certain line of text or custom event node, you may wish to save it as a prefab so you can add it with all of its attributes already defined.\n\nTo create one, click the Save Prefab icon on the top of an existing event node.";
        el_list_prefabs.entries_are = ListEntries.INSTANCES;
        el_list_prefabs.colorized = false;
        el_list_prefabs.onmiddleclick = omu_event_prefab_list_alphabetize;
        ds_list_add(t_custom.contents, el_list_prefabs);
        
        yy += ui_get_list_height(el_list_prefabs) + spacing;
        
        element = create_button(legal_x + spacing, yy, "Rename", element_width, element_height, fa_center, not_yet_implemented, t_custom);
        element.tooltip = "Rename the selected prefab.";
        ds_list_add(t_custom.contents, element);
        
        yy += element_height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Delete", element_width, element_height, fa_center, not_yet_implemented, t_custom);
        element.tooltip = "Delete the selected prefab. Existing nodes derived from it will still exist, but the prefab link will be broken.";
        ds_list_add(t_custom.contents, element);
        #endregion
        
        #region event list 1
        yy = legal_y;
        
        element = create_button(legal_x + spacing, yy, "Entrypoint", element_width, element_height, fa_left, omu_event_add_entrypoint, t_action1);
        element.tooltip = "A cutscene entrypoint. Entrypoints are for marking the beginning of cutscene sequences.";
        ds_list_add(t_action1.contents, element);
        yy += element_height + spacing;
        
        element = create_text(legal_x + spacing, yy, "Message", element_width, element_height, fa_left, element_width, t_action1);
        ds_list_add(t_action1.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Show Text", element_width, element_height, fa_left, omu_event_add_text, t_action1);
        element.tooltip = "Display text to the user. You may wish to format the text using Scribble.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element.tooltip = "Show a list of choices. The player may select one, or optionally cancel. Each choice may have its own outbound node.";
        element = create_button(legal_x + spacing, yy, "Show Choices", element_width, element_height, fa_left, omu_event_add_choices, t_action1);
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Input Text", element_width, element_height, fa_left, omu_event_add_input_text, t_action1);
        element.tooltip = "Prompt the player to enter text via the keyboard.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Show Scrolling Text", element_width, element_height, fa_left, omu_event_add_scrolling_text, t_action1);
        element.tooltip = "Show a text crawl. I don't expect anyone to use this, but I wanted to include it anyway.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Data", element_width, element_height, fa_left, element_width, t_action1);
        ds_list_add(t_action1.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Control Switches", element_width, element_height, fa_left, omu_event_add_global_switch, t_action1);
        element.tooltip = "Set the value of one of the game's global boolean variables. Useful if you need a quick-and-easy way to enable or disable things.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Control Variables", element_width, element_height, fa_left, omu_event_add_global_variable, t_action1);
        element.tooltip = "Set the value of one of the game's global variables.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Control Self Switches", element_width, element_height, fa_left, omu_event_add_self_switch, t_action1);
        element.tooltip = "Set the value of an entity's instance boolean variables.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Control Self Variables", element_width, element_height, fa_left, omu_event_add_self_variable, t_action1);
        element.tooltip = "Set the value of an entity's instance variables.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Control Timer", element_width, element_height, fa_left, omu_event_add_timer, t_action1);
        element.tooltip = "Control a timer. The timer may count down until zero, or count up like a stopwatch.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Deactivate This Event Page", element_width, element_height, fa_left, omu_event_add_deactivate_event, t_action1);
        element.tooltip = "Disable the calling event page (if the cutscene sequence was initiated by one) so that it will no longer activate.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Flow Control", element_width, element_height, fa_left, element_width, t_action1);
        ds_list_add(t_action1.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Conditional Branch", element_width, element_height, fa_left, omu_event_add_conditional, t_action1);
        element.tooltip = "Continue to a different outbound node based on some criteria.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Comment", element_width, element_height, fa_left, omu_event_add_comment, t_action1);
        element.tooltip = "Show a comment on the event graph. Comments have no affect on game logic and are only there for the developer's benefit.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Timing", element_width, element_height, fa_left, element_width, t_action1);
        ds_list_add(t_action1.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Wait", element_width, element_height, fa_left, omu_event_add_wait, t_action1);
        element.tooltip = "Wait for a specified amount of time, and then continue.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Schedule Event", element_width, element_height, fa_left, omu_event_add_schedule_event, t_action1);
        element.tooltip = "Schedule another event to happen after a certain amount of time. (The current event will not be interrupted.)";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Movement", element_width, element_height, fa_left, element_width, t_action1);
        ds_list_add(t_action1.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Transfer Player", element_width, element_height, fa_left, omu_event_add_transfer_player, t_action1);
        element.tooltip = "Move the player to another location on the map (or on a different map).";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Set Entity Location", element_width, element_height, fa_left, not_yet_implemented, t_action1);
        element.tooltip = "Move an entity who isn't the player to another location on the map.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Scroll Map", element_width, element_height, fa_left, not_yet_implemented, t_action1);
        element.tooltip = "Move the game camera to focus on another area of the map.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Set Movement Route", element_width, element_height, fa_left, not_yet_implemented, t_action1);
        element.tooltip = "Define a movement sequence for the player or another entity on the map.";
        ds_list_add(t_action1.contents, element);
        yy += element_height;
        #endregion
        
        #region event list 2
        yy = legal_y;
        
        element = create_text(legal_x + spacing, yy, "Entity", element_width, element_height, fa_left, element_width, t_action2);
        ds_list_add(t_action2.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Set Entity Sprite", element_width, element_height, fa_left, omu_event_add_set_entity_sprite, t_action2);
        element.tooltip = "Change a Pawn entity's sprite.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Set Entity Mesh", element_width, element_height, fa_left, omu_event_add_set_entity_mesh, t_action2);
        element.tooltip = "Change a Mesh entity's mesh.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Set Mesh Animation Data", element_width, element_height, fa_left, omu_event_add_set_entity_mesh_animation, t_action2);
        element.tooltip = "Change a Mesh entity's animation data.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Screen", element_width, element_height, fa_left, element_width, t_action2);
        ds_list_add(t_action2.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Tint Screen", element_width, element_height, fa_left, omu_event_add_tint_screen, t_action2);
        element.tooltip = "Change the tinting applied to the screen.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Shake Screen", element_width, element_height, fa_left, omu_event_add_shake_screen, t_action2);
        element.tooltip = "Cause the game camera to shake.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Audio", element_width, element_height, fa_left, element_width, t_action2);
        ds_list_add(t_action2.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Play BGM", element_width, element_height, fa_left, omu_event_add_play_bgm, t_action2);
        element.tooltip = "Set a piece of background music to play. Music already playing will be suspended.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Fade BGM", element_width, element_height, fa_left, omu_event_add_fade_bgm, t_action2);
        element.tooltip = "Set a piece of background music to change its volume over time.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Resume Automatic BGM", element_width, element_height, fa_left, omu_event_add_resume_bgm, t_action2);
        element.tooltip = "Resume the suspended background music. Other music will be stopped.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Play SE", element_width, element_height, fa_left, omu_event_add_play_se, t_action2);
        element.tooltip = "Play a sound effect.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Stop All SE", element_width, element_height, fa_left, omu_event_add_stop_se, t_action2);
        element.tooltip = "Cancel all currently playing sound effects.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Scene", element_width, element_height, fa_left, element_width, t_action2);
        ds_list_add(t_action2.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Return to Title Screen", element_width, element_height, fa_left, not_yet_implemented, t_action2);
        element.tooltip = "Exit the game to the title screen.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Map", element_width, element_height, fa_left, element_width, t_action2);
        ds_list_add(t_action2.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Change Map Display Name", element_width, element_height, fa_left, omu_event_add_change_map_name, t_action2);
        element.tooltip = "Change the name of the map, as visible to the player. (This will not affect the map's internal name.)";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Change Map Tileset", element_width, element_height, fa_left, not_yet_implemented, t_action2);
        element.tooltip = "Change the tileset used by the map. This may cause a temporary hiccup if large images need to be loaded or unloaded from memory.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Change Map Battle Scene", element_width, element_height, fa_left, not_yet_implemented, t_action2);
        element.tooltip = "Change the battle scene associated with the map.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Change Map Skybox", element_width, element_height, fa_left, not_yet_implemented, t_action2);
        element.tooltip = "Change the skybox used by the map.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        
        yy += spacing;
        
        element = create_text(legal_x + spacing, yy, "Advanced", element_width, element_height, fa_left, element_width, t_action2);
        ds_list_add(t_action2.contents, element);
        yy += element_height + spacing / 2;
        element = create_button(legal_x + spacing, yy, "Script", element_width, element_height, fa_left, omu_event_add_script, t_action2);
        element.tooltip = "Invoke a piece of Lua code. Errors in Lua code may cause unpredictable behavior, or crash the game; use carefully.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Audio Controls", element_width, element_height, fa_left, not_yet_implemented, t_action2);
        element.tooltip = "Advanced audio controls (using the FMOD audio interface).";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Custom", element_width, element_height, fa_left, omu_event_custom_dialog, t_action2);
        element.tooltip = "Insert a custom-defined event node.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        element = create_button(legal_x + spacing, yy, "Prefab", element_width, element_height, fa_left, omu_event_prefab_dialog, t_action2);
        element.tooltip = "Insert a prefab event node.";
        ds_list_add(t_action2.contents, element);
        yy += element_height;
        #endregion
        
        return id;
    }
}