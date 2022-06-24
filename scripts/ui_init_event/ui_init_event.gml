function ui_init_event(mode) {
    var hud_width = 320;
    var hud_height = window_get_height();
    var col1x = 16;
    var col_width = hud_width - 32;
    var col_height = 32;
    
    var container = new EmuCore(window_get_width() - hud_width, 0, hud_width, hud_height);
    var tab_group = new EmuTabGroup(0, EMU_AUTO, hud_width, hud_height, 2, col_height);
    
    tab_group.AddTabs(0, [
        (new EmuTab("Events")).AddContent([
            (new EmuList(col1x, EMU_AUTO, col_width, col_height, "Events:", col_height, 19, function() {
                if (self.GetSelection() + 1) {
                    Stuff.event.active = Game.events.events[self.GetSelection()];
                    self.root.root.SearchID("NODE LIST").SetList(Game.events.events[self.GetSelection()].nodes);
                    self.GetSibling("EVENT RENAME").SetValue(Stuff.event.active.name);
                }
            }))
                .SetTooltip("All of the event graphs currently defined. Middle-click the list to sort it alphabetically.")
                .SetList(Game.events.events)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetCallbackMiddle(function() {
                    self.Deselect();
                    array_sort_name(Game.events.events);
                    for (var i = 0; i < array_length(Game.events.events); i++) {
                        if (Game.events.events[i] == Stuff.event.active) {
                            self.Select(i, true);
                            break;
                        }
                    }
                })
                .SetID("EVENT LIST"),
            (new EmuInput(col1x, EMU_AUTO, col_width, col_height, "Name: ", "", "event name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                var index = self.GetSibling("EVENT LIST").GetSelection();
                if (index + 1 && string_length(self.value) > 0) {
                    Game.events.events[index].name = self.value;
                }
            }))
                .SetTooltip("Rename this event. Names do not have to be unique, but if you give more than one event the same name things will probably become confusing very quickly.")
                .SetID("EVENT RENAME"),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Add Event", function() {
                array_push(Game.events.events, new DataEvent("Event$" + string(array_length(Game.events.events))));
            }))
                .SetTooltip("Add a new event graph. Sequences can link to nodes on other graphs if you need to, but for organizational purposes you most likely want to keep them separate.")
                .SetID("EVENT ADD"),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Delete Event", function() {
                var index = self.GetSibling("EVENT LIST").GetSelection();
                if (index + 1 && array_length(Game.events.events) > 1) {
                    if (array_length(Game.events.events) == 1) {
                        emu_dialog_notice("Can't delete the only event!");
                    } else {
                        var dialog = emu_dialog_confirm(self, "Are you sure you want to delete " + Game.events.events[index].name + "?", function() {
                            Stuff.event.active.Destroy();
                            var event_list = self.root.root.GetSibling("EVENT LIST");
                            array_delete(Game.events.events, self.root.event_index, 1);
                            var selection = event_list.GetSelection();
                            event_list.Deselect();
                            event_list.Select(max(0, self.root.event_index - 1), true);
                            emu_dialog_close_auto();
                        });
                        dialog.event_index = index;
                    }
                }
            }))
                .SetTooltip("Delete this event graph. Anything referencing any of the nodes on the graph will no longer work.")
                .SetID("EVENT DELETE"),
            
        
        
        ])
            .SetID("EVENTS"),
        (new EmuTab("Nodes")).AddContent([
            (new EmuList(col1x, EMU_AUTO, col_width, col_height, "Event nodes:", col_height, 20, function() {
                if (self.GetSelection() + 1) {
                    event_view_node(Stuff.event.active.nodes[self.GetSelection()]);
                }
            }))
                .SetVacantText("No nodes in this graph!")
                .SetTooltip("This is a list of all of the nodes on this event graph. Click on one to jump to its position. Middle-click the list to sort it alphabetically.")
                .SetList(Game.events.events[0].nodes)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetCallbackMiddle(function() {
                    var selection = self.GetSelection();
                    self.Deselect();
                    var event = Stuff.event.active;
                    var selected_node = (selection + 1) ? event.nodes[selection] : undefined;
                    array_sort_name(event.nodes);
                
                    for (var i = 0, n = array_length(event.nodes); i < n; i++) {
                        if (event.nodes[i] == selected_node) {
                            self.Select(i, true);
                            break;
                        }
                    }
                })
                .SetID("NODE LIST"),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Add Entrypoint", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.ENTRYPOINT);
            }))
                .SetTooltip("Add an entrypoint node."),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Add Text Node", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.TEXT);
            }))
                .SetTooltip("Add a text node."),
        ])
            .SetID("NODES"),
    ]);
    
    tab_group.AddTabs(1, [
        (new EmuTab("Custom")).AddContent([
            (new EmuList(col1x, EMU_AUTO, col_width, col_height, "Custom Nodes", col_height, 8, function() {
                
            }))
                .SetList(Game.events.custom)
                .SetID("CUSTOM NODES LIST")
                .SetVacantText("no custom nodes")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetCallbackDouble(function() {
                    var selection = self.GetSelection();
                    if (selection + 1) {
                        show_message("todo");
                    }
                })
                .SetCallbackMiddle(function() {
                    var selection = Game.events.custom[self.GetSelection()];
                    ui_list_deselect(list);
                    array_sort_name(Game.events.custom);
                
                    for (var i = 0; i < array_length(Game.events.custom); i++) {
                        if (Game.events.custom[i] == selection) {
                            self.Select(i, true);
                            break;
                        }
                    }
                })
                .SetTooltip("Any event you want that's specific to your game's data (for example, anything pertaining to Inventory) can be made from a custom event.\n\nYou can attach your own data types and even outbound nodes to custom events."),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Add", function() {
                array_push(Game.events.custom, new DataEventNodeCustom("CustomNode" + string(array_length(Game.events.custom))));
            }))
                .SetTooltip("Create a new custom event node."),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Delete", function() {
                var index = self.GetSibling("CUSTOM NODES LIST").GetSelection();
                if (index + 1) {
                    var custom = Game.events.custom[index];
                    // count the number of nodes to be deleted
                    var n_events = 0;
                    var n_nodes = 0;
                    for (var i = 0; i < array_length(Game.events.events); i++) {
                        var event = Game.events.events[i];
                        var this_event = false;
                        for (var j = 0; j < array_length(event.nodes); j++) {
                            if (event.nodes[j].custom_guid == custom.GUID) {
                                n_nodes++;
                                if (!this_event) {
                                    this_event = true;
                                    n_events++;
                                }
                            }
                        }
                    }
                    
                    var text = "Are you sure you want to delete " + custom.name + "?";
                    if (n_nodes > 0) {
                        text += " This will also delete " + string(n_nodes) + " " + ((n_nodes > 1) ? "nodes" : "node") + " in " + string(n_events) + " " + ((n_events > 1) ? "events" : "event") + " and may cause event logic to no longer work properly.";
                    }
                    
                    emu_dialog_confirm(self.GetSibling("CUSTOM NODES LIST"), text, function() {
                        var custom = Game.events.custom[self.root.GetSelection()];
                        array_delete(Game.events.custom, self.root.GetSelection(), 1);
                        self.root.Deselect();
                    
                        for (var i = 0, n = array_length(Game.events.events); i < n; i++) {
                            var event = Game.events.events[i];
                            for (var j = array_length(event.nodes) - 1; j >= 0; j--) {
                                if (event.nodes[j].custom_guid == custom.GUID) {
                                    event.nodes[j].Destroy();
                                }
                            }
                        }
                        
                        custom.Destroy();
                        self.root.Dispose();
                    });
                }
            }))
                .SetTooltip("Delete the selected custom event node. Any existing nodes based on the node you delete will also be deleted, and may leave gaps in the sequences that use them."),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Edit", function() {
                var index = self.GetSibling("CUSTOM NODES LIST").GetSelection();
                if (index + 1) {
                    dialog_create_event_custom(self.root);
                }
            }))
                .SetTooltip("Edit the properties of the selected custom event node."),
            
            
            (new EmuList(col1x, EMU_AUTO, col_width, col_height, "Prefab Nodes", col_height, 6, function() {
                var selection = self.GetSelection();
                if (selection + 1) {
                    self.GetSibling("PREFAB RENAME").SetValue(Game.events.prefabs[selection].name);
                }
            }))
                .SetList(Game.events.prefabs)
                .SetID("PREFAB LIST")
                .SetVacantText("no prefab nodes")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetCallbackMiddle(function() {
                    var selection = Game.events.prefabs[self.GetSelection()];
                    ui_list_deselect(list);
                    array_sort_name(Game.events.prefabs);
                
                    for (var i = 0; i < array_length(Game.events.prefabs); i++) {
                        if (Game.events.prefabs[i] == selection) {
                            self.Select(i, true);
                            break;
                        }
                    }
                })
                .SetTooltip("Prefab events which can be used as templates for other events."),
            (new EmuInput(col1x, EMU_AUTO, col_width, col_height, "Name: ", "", "prefab name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                var index = self.GetSibling("PREFAB LIST").GetSelection();
                if (index + 1 && string_length(self.value) > 0) {
                    Game.events.prefabs[index].name = self.value;
                }
            }))
                .SetTooltip("Rename this event. Names do not have to be unique, but if you give more than one event the same name things will probably become confusing very quickly.")
                .SetID("PREFAB RENAME"),
            (new EmuButton(col1x, EMU_AUTO, col_width, col_height, "Delete", function() {
                var index = self.GetSibling("PREFAB LIST").GetSelection();
                if (index + 1) {
                    var prefab = Game.events.prefabs[index];
                    // count the number of nodes to be deleted
                    var n_events = 0;
                    var n_nodes = 0;
                    for (var i = 0; i < array_length(Game.events.events); i++) {
                        var event = Game.events.events[i];
                        var this_event = false;
                        for (var j = 0; j < array_length(event.nodes); j++) {
                            if (event.nodes[j].prefab_guid == prefab.GUID) {
                                n_nodes++;
                                if (!this_event) {
                                    this_event = true;
                                    n_events++;
                                }
                            }
                        }
                    }
                    
                    var text = "Are you sure you want to delete " + prefab.name + "?";
                    if (n_nodes > 0) {
                        text += " This will also detach " + string(n_nodes) + " " + ((n_nodes > 1) ? "prefab nodes" : "prefab node") + " in " + string(n_events) + " " + ((n_events > 1) ? "events" : "event") + ".";
                    }
                    
                    emu_dialog_confirm(self.GetSibling("PREFAB LIST"), text, function() {
                        var prefab = Game.events.prefabs[self.root.GetSelection()];
                        array_delete(Game.events.prefabs, self.root.GetSelection(), 1);
                        self.root.Deselect();
                    
                        for (var i = 0, n = array_length(Game.events.events); i < n; i++) {
                            var event = Game.events.events[i];
                            for (var j = array_length(event.nodes) - 1; j >= 0; j--) {
                                if (event.nodes[j].prefab_guid == prefab.GUID) {
                                    event.nodes[j].prefab_guid = NULL;
                                }
                            }
                        }
                        
                        self.root.Dispose();
                    });
                }
            }))
                .SetTooltip("Delete the selected prefab node. Any existing nodes based on the prefab will still exist, but will no longer be tied to the prefab."),
        ])
            .SetID("CUSTOM"),
        (new EmuTab("Actions A")).AddContent([
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]General"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Entrypoint", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.ENTRYPOINT);
            }))
                .SetTooltip("A cutscene entrypoint. Entrypoints are for marking the beginning of cutscene sequences."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Message", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.TEXT);
            }))
                .SetTooltip("Display text to the user. You may wish to format the text using Scribble."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Show Choices", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SHOW_CHOICES);
            }))
                .SetTooltip("Show a list of choices. The player may select one, or optionally cancel. Each choice may have its own outbound node"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Input Text", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.INPUT_TEXT);
            }))
                .SetTooltip("Prompt the player to enter text via the keyboard."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Show Scrolling Text", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SHOW_SCROLLING_TEXT);
            }))
                .SetTooltip("Show a text crawl. I don't expect anyone to use this, but I wanted to include it anyway because it's part of the RPG Maker event library."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Data"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Control Switches", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CONTROL_VARIABLES);
            }))
                .SetTooltip("Set the value of one of the game's global variables. Useful if you need a quick-and-easy way to control game data."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Control Switches", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CONTROL_SWITCHES);
            }))
                .SetTooltip("Set the value of one of the game's global boolean variables. Useful if you need a quick-and-easy way to enable or disable things."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Control Self Variable", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CONTROL_SELF_VARIABLES);
            }))
                .SetTooltip("Set the value of an entity's instance boolean variables."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Control Self Switch", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CONTROL_SELF_SWITCHES);
            }))
                .SetTooltip("Set the value of an entity's instance variables."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Control Timer", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CONTROL_TIME);
            }))
                .SetTooltip("Control a timer. The timer may count down until zero, or count up like a stopwatch."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Deactivate Event Page", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.DEACTIVATE_EVENT);
            }))
                .SetTooltip("Disable the calling event page (if the cutscene sequence was initiated by one) so that it will no longer activate."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Flow Control"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Conditional Branch", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CONDITIONAL);
            }))
                .SetTooltip("Continue to a different outbound node based on some criteria."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Comment", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.COMMENT);
            }))
                .SetTooltip("Show a comment on the event graph. Comments have no affect on game logic and are only there for the developer's benefit."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Timing"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Wait", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.WAIT);
            }))
                .SetTooltip("Wait for a specified amount of time, and then continue."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Schedule Event", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SCHEDULE_EVENT);
            }))
                .SetTooltip("Schedule another event to happen after a certain amount of time. (The current event will not be interrupted.)"),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Movement"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Transfer Player", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.TRANSFER_PLAYER);
            }))
                .SetTooltip("Move the player to another location on the map (or on a different map)."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Set Entity Location", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SET_ENTITY_LOCATION);
            }))
                .SetTooltip("Move an entity who isn't the player to another location on the map."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Scroll Map", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SCROLL_MAP);
            }))
                .SetTooltip("Move the game camera to focus on another area of the map."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Set Movement Route", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SET_MOVEMENT_ROUTE);
            }))
                .SetTooltip("Define a movement sequence for the player or another entity on the map."),
        ])
            .SetID("ACTIONS A"),
        (new EmuTab("Actions B")).AddContent([
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Entity"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Set Entity Sprite", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SET_ENTITY_SPRITE);
            }))
                .SetTooltip("Change a Pawn entity's sprite."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Set Entity Mesh", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SET_ENTITY_MESH);
            }))
                .SetTooltip("Change a Mesh entity's mesh."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Set Mesh Animation Data", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SET_MESH_ANIMATION);
            }))
                .SetTooltip("Change a Mesh entity's animation data."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Screen"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Tint Screen", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.TINT_SCREEN);
            }))
                .SetTooltip("Change the tinting applied to the screen."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Shake Screen", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SHAKE_SCREEN);
            }))
                .SetTooltip("Cause the game camera to shake."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Audio"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Play BGM", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.PLAY_BGM);
            }))
                .SetTooltip("Set a piece of background music to play. Music already playing will be suspended."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Fade/Stop BGM", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.FADE_BGM);
            }))
                .SetTooltip("Set a piece of background music to change its volume over time, and/or stop."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Resume Automatic BGM", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.RESUME_BGM);
            }))
                .SetTooltip("Resume the suspended background music. Other music will be stopped."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Play Effect", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.PLAY_SE);
            }))
                .SetTooltip("Play a sound effect."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Stop All Effects", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.STOP_SE);
            }))
                .SetTooltip("Cancel all currently playing sound effects."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Scene and Map"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Return to Title Screen", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.RETURN_TO_TITLE);
            }))
                .SetTooltip("Exit the game to the title screen."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Change Map Display Name", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CHANGE_MAP_DISPLAY_NAME);
            }))
                .SetTooltip("Change the name of the map, as visible to the player. (This will not affect the map's internal name.)"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Change Map Tileset", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CHANGE_MAP_TILESET);
            }))
                .SetTooltip("Change the tileset used by the map. This may cause a temporary hiccup if large images need to be loaded or unloaded from memory."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Change Map Battle Scene", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CHANGE_MAP_BATTLE_SCENE);
            }))
                .SetTooltip("Change the battle scene associated with the map."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Change Map Skybox", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.CHANGE_MAP_SKYBOX);
            }))
                .SetTooltip("Change the skybox used by the map."),
            new EmuText(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "[c_aqua]Advanced"),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Script", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.SCRIPT);
            }))
                .SetTooltip("Invoke a piece of custom code. Errors in the code code may cause unpredictable behavior, or crash the game; use carefully."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Audio Controls", function() {
                event_create_node(Stuff.event.active, EventNodeTypes.AUDIO_CONTORLS);
            }))
                .SetTooltip("Advanced audio controls (using the FMOD audio interface)."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Custom", function() {
                var dialog = new EmuDialog(400, 640, "Add Custom Event Node");
                
                dialog.AddContent([
                    (new EmuList(32, EMU_AUTO, 336, 32, "Available nodes:", 32, 16, function() {
                        
                    }))
                        .SetCallbackDouble(function() {
                            var selection = self.GetSelection();
                            if (selection + 1) {
                                event_create_node(Stuff.event.active, EventNodeTypes.CUSTOM, undefined, undefined, Game.events.custom[selection].GUID);
                                self.root.Dispose();
                            }
                        })
                        .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                        .SetList(Game.events.custom)
                        .SetID("LIST")
                ]).AddDefaultConfirmCancelButtons("Add", function() {
                    self.GetSibling("LIST").callback_double();
                    self.root.Dispose();
                }, "Cancel", emu_dialog_close_auto);
            }))
                .SetTooltip("Insert a custom event node."),
            (new EmuButton(col1x, EMU_AUTO_NO_SPACING, col_width, col_height, "Prefab", function() {
                var dialog = new EmuDialog(400, 640, "Add Prefab Node");
                
                dialog.AddContent([
                    (new EmuList(32, EMU_AUTO, 336, 32, "Available prefabs:", 32, 16, function() {
                        
                    }))
                        .SetCallbackDouble(function() {
                            var selection = self.GetSelection();
                            
                            if (selection + 1) {
                                var prefab = Game.events.prefabs[selection];
                                var instantiated = event_create_node(Stuff.event.active, prefab.type, undefined, undefined, prefab.custom_guid);
                                // when the node is named normally the $number is appended before the event is added to the
                                // list; in this case it's already in the list and you're renaming it, so the number you want
                                // is length minus one
                                instantiated.Rename(prefab.name + "$" + string(array_length(Stuff.event.active.nodes) - 1));
                                instantiated.prefab_guid = prefab.GUID;
                                instantiated.data = array_clone(prefab.data);
                                instantiated.custom_data = json_parse(json_stringify(prefab.custom_data));
                                self.root.Dispose();
                            }
                        })
                        .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                        .SetList(Game.events.prefabs)
                        .SetID("LIST")
                ]).AddDefaultConfirmCancelButtons("Add", function() {
                    self.GetSibling("LIST").callback_double();
                    self.root.Dispose();
                }, "Cancel", emu_dialog_close_auto);
            }))
                .SetTooltip("Insert a prefab event node."),
        ])
            .SetID("ACTIONS B"),
    ]);
    
    tab_group.RequestActivateTab(tab_group.GetTabByID("NODES"));
    
    container.AddContent(tab_group);
    
    return container;
}