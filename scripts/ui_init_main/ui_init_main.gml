function ui_init_main(mode) {
    var hud_width = view_get_wport(view_hud);
    var hud_height = window_get_height();
    var col1x = 32;
    var col2x = hud_width / 2;
    var element_width = hud_width / 2 - 64;
    var element_height = 32;
    
    var container = new EmuCore(0, 0, hud_width, hud_height);
    var tab_group = new EmuTabGroup(0, EMU_AUTO, hud_width, hud_height, 3, element_height - 4);
    
    var f_map_open = function() {
        var index = self.GetSibling("MAP LIST").GetSelection();
        if (index < 0) return;
        var map = Game.maps[index];
        if (map == Stuff.map.active_map) return;
        
        emu_dialog_confirm(undefined, "Would you like to load the map " + map.name + "? Any unsaved changes will be lost!", function() {
            selection_clear();
            self.root.map.Load();
            self.root.Dispose();
        }).map = map;
    };
    
    var f_event_page_open = function() {
        if (self.GetSibling("ENTITY EVENT PAGES").GetSelection() + 1) {
            dialog_create_entity_event_page(noone);
        }
    };
    
    #region general
    tab_group.AddTabs(0, [
        (new EmuTab("General")).AddContent([
            #region column 1
            (new EmuRadioArray(col1x, EMU_AUTO, element_width, element_height, "Selection mode:", Settings.selection.mode, function() {
                Settings.selection.mode = self.value;
            }))
                .AddOptions(["Single", "Rectangle", "Circle"])
                .SetID("SELECTION MODE"),
            (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Additive selection?", Settings.selection.addition, function() {
                Settings.selection.addition = self.value;
            }))
                .SetID("SELECTION ADDITIVE"),
            (new EmuRadioArray(col1x, EMU_AUTO, element_width, element_height, "Fill type:", Settings.selection.fill_type, function() {
                Settings.selection.fill_type = self.value;
            }))
                .AddOptions(["Tile", "Animated tile", "Mesh", "Pawn", "Effect", "Mesh autotile", "Zone"])
                .SetID("SELECTION FILL"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Fill selection...", function() {
                sa_fill();
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Delete selection...", function() {
                sa_delete();
            })),
            new EmuText(col1x, EMU_AUTO, element_width, element_height, "Selection mask:"),
            (new EmuBitfield(col1x, EMU_AUTO, element_width, element_height, Settings.selection.mask, function() {
                Settings.selection.mask = self.value;
            }))
                .AddOptions([
                    "Tile", "Mesh", "Pawn", "Effect",
                    new EmuBitfieldOption("All", 0xf, function() {
                        self.root.value = self.value;
                    }, function() { return self.root.value == self.value; }),
                    new EmuBitfieldOption("None", 0x0, function() {
                        self.root.value = self.value;
                    }, function() { return self.root.value == self.value; }),
                ])
                .SetOrientation(E_BitfieldOrientations.VERTICAL)
                .SetFixedSpacing(24)
                .SetID("SELECTION MASK"),
            #endregion
            #region column 2
            new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]Viewer settings:"),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "3D View", Settings.view.threed, function() {
                Settings.view.threed = self.value;
            }))
                .SetTooltip("View the map in 2D, or in 3D."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Wireframes", Settings.view.wireframe, function() {
                Settings.view.wireframe = self.value;
            }))
                .SetTooltip("Whether or not you want to view the wireframes to go with visual data."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Grid and Markers", Settings.view.grid, function() {
                Settings.view.grid = self.value;
            }))
                .SetTooltip("Whether or not you want to view the cell grid and grid axes."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Texture", Settings.view.texture, function() {
                Settings.view.texture = self.value;
            }))
                .SetTooltip("Whether or not to texture the visuals (to use the tilesets, in common terms). If off, a flat orange texture will be used instead. Most of the time you want this on."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Entities", Settings.view.entities, function() {
                Settings.view.entities = self.value;
            }))
                .SetTooltip("Whether or not entites should be visible. This is almost everything in the map, and turning it off is quite pointless."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Backfaces", Settings.view.backface, function() {
                Settings.view.backface = self.value;
            }))
                .SetTooltip("Whether the backs of triangles should be visible. There is a very small performance cost to turning them on. Generally, this is not needed."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Zones", Settings.view.zones, function() {
                Settings.view.zones = self.value;
            }))
                .SetTooltip("Map zones for things like camera and lighting controls. If you have a lot of them, it can become hard to see through them. Zones can only be blicked on when this is turned on."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Lighting", Settings.view.lighting, function() {
                Settings.view.lighting = self.value;
            }))
                .SetTooltip("See how the scene looks with lighting. This also affects fog. You may wish to turn this off if you find yourself having a hard time seeing with the lights enabled."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Gizmos", Settings.view.gizmos, function() {
                Settings.view.gizmos = self.value;
            }))
                .SetTooltip("The helpful frames you see around light sources and other effects and that sort of thing."),
            #endregion
        ])
            .SetID("GENERAL"),
        (new EmuTab("Stats")).AddContent([
            #region column 1
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "All Entities:", element_height, 22, function() {
                selection_clear();
                
                Settings.selection.mask = 0;
                self.ForEachSelection(function(entity) {
                    Settings.selection.mask |= entity.etype_flags;
                    var selection = new SelectionSingle(entity.xx, entity.yy, entity.zz);
                });
                
                sa_process_selection();
            }))
                .SetUpdate(function() {
                    self.list = Stuff.map.active_map.contents.all_entities;
                })
                .SetVacantText("no entities in this map")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("ALL ENTITIES"),
            #endregion
            #region column 2
            (new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]Entity Stats")),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Entities:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Entities:  " + string(Stuff.map.active_map.contents.stats.GetEntityCount());
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Static:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Static:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Solid:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Solid:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Tiles:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Tiles:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Autotiles:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Autotiles:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Meshes:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Meshes:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Pawns:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Pawns:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Effects:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Effects:  N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Vertex Data")),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Storage:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    var size = Stuff.map.active_map.contents.stats.GetVertexByteCount();
                    return "    Triangles:  " + ((size < 1024) ? (string(size) + " bytes") : (string(size >> 10) + " kilobytes"));
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Vertices:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Vertices:  " + string(Stuff.map.active_map.contents.stats.GetVertexCount());
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "    Triangles:"))
                .SetDefaultSpacingY(8)
                .SetTextUpdate(function() {
                    return "    Triangles:  " + string(Stuff.map.active_map.contents.stats.GetVertexByteCount());
                }),
            #endregion
        ])
            .SetID("STATS"),
        (new EmuTab("Map")).AddContent([
            #region column 1
            (new EmuList(col1x, EMU_BASE, element_width, element_height, "Maps:", element_height, 15, function() {
            }))
                .SetVacantText("no maps (how?!)")
                .SetTooltip("This is a list of all the maps currently in the game")
                .SetList(Game.maps)
                .SetListColors(function(index) {
                    return (Game.meta.start.map == list.entries[index].GUID) ? c_aqua : EMU_COLOR_LIST_TEXT;
                })
                .SetCallbackDouble(f_map_open)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("MAP LIST"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "New Map", function() {
                var dialog = new EmuDialog(640, 480, "New Map");
                
                var col1x = 32;
                var col2x = dialog.width / 2 + 32;
                var element_width = 256;
                var element_height = 32;
                
                dialog.AddContent([
                    (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "Name:", "Map " + string(array_length(Game.maps) + 1), "The name of the map", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() { }))
                        .SetID("NAME"),
                    (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "    Width (X):", "160", "The width of the map", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(1, MAP_AXIS_LIMIT)
                        .SetID("X"),
                    (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "    Height (Y):", "160", "The height of the map", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(1, MAP_AXIS_LIMIT)
                        .SetID("Y"),
                    (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "    Depth (Z):", "8", "The depth of the map", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(1, MAP_AXIS_LIMIT)
                        .SetID("Z"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Aligned to grid?", true, function() { }))
                        .SetID("GRID")
                    (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "Chunk size:", string(Game.meta.grid.chunk_size), "The size of each chunk of the map; chunks outside of the camera's view will not be updated or rendered (although their contents will continue to exist).", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(6, MAP_AXIS_LIMIT)
                        .SetID("CHUNK"),
                ]).AddDefaultConfirmCancelButtons("Create", function() {
                    // automatically pushed onto the list
                    var map = new DataMap(self.GetSibling("NAME").value, "");
                    array_push(Game.maps, map);
                    map.SetSize(real(self.GetSibling("X").value), real(self.GetSibling("Y").value), real(self.GetSibling("Z").value));
                    map.on_grid = self.GetSibling("GRID").value;
                    map.light_ambient_colour = Game.meta.lighting.ambient;
                    map.chunk_size = real(self.GetSibling("CHUNK").value);
                    self.root.Dispose();
                }, "Cancel", emu_dialog_close_auto);
            }))
                .SetTooltip("Add a map"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Delete Map", function() {
                var index = self.GetSibling("MAP LIST").GetSelection();
                if (index < 0) return;
                
                var map = Game.maps[index];
                if (map == Stuff.map.active_map) {
                    emu_dialog_notice("Please don't delete a map that you currently have loaded. If you want to delete this map, load a different one first.");
                } else {
                    map.Destroy();
                    ui_list_deselect(button.root.el_map_list);
                    ui_list_select(button.root.el_map_list, array_search(Game.maps, Stuff.map.active_map));
                }
            }))
                .SetTooltip("Delete the currently selected map. Any existing references to it will no longer work. You should only use this if you're absolutely sure; once you delete a map, you're not getting it back."),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Open Map", f_map_open))
                .SetTooltip("Open the currently selected map for editing. Alternatively, you can double-click on a list entry to open it."),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Make Starting Map", function() {
                var index = self.GetSibling("MAP LIST").GetSelection();
                if (index < 0) return;
                Game.meta.start.map = Game.maps[index].GUID;
            }))
                .SetTooltip("Designate the currently selected map as the first one entered when the game starts. (What this means to your game is up to you.)"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Import Tiled", function() {
                import_map_tiled();
            }))
                .SetTooltip("Import a Tiled map editor file (json version). Tile data will be imported as frozen terrain; the editor will attempt to convert other data to Entities."),
            #endregion
            #region column 2
            new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]This Map"),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "Name"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "", "", "map name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                Stuff.map.active_map.name = self.value;
            }))
                .SetTooltip("The name of the map, as it appears to the player.")
                .SetID("MAP DATA NAME")
                .SetInputBoxPosition(0, 0),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "Internal name"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "", "", "map internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
                internal_name_set(Stuff.map.active_map, self.value);
            }))
                .SetTooltip("The internal name of the map, as it appears to the developer. Standard restrictions on internal names apply.")
                .SetID("MAP DATA INTERNAL NAME")
                .SetInputBoxPosition(0, 0),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "Summary"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "", "", "map summary", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                Stuff.map.active_map.summary = self.value;
            }))
                .SetTooltip("A description of the map. Try not to make this too long. You may wish to use Scribble formatting tags.")
                .SetID("MAP DATA SUMMARY")
                .SetInputBoxPosition(0, 0),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Width (X):", "64", "map width", 10, E_InputTypes.INT, emu_null))
                .SetTooltip("The width of the map, in tiles.")
                .SetID("MAP DATA SIZE X")
                .SetRealNumberBounds(1, MAP_AXIS_LIMIT),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Width (Y):", "64", "map height", 10, E_InputTypes.INT, emu_null))
                .SetTooltip("The height of the map, in tiles.")
                .SetID("MAP DATA SIZE Y")
                .SetRealNumberBounds(1, MAP_AXIS_LIMIT),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Width (Z):", "8", "map depth", 10, E_InputTypes.INT, emu_null))
                .SetTooltip("The depth of the map, in tiles.")
                .SetID("MAP DATA SIZE Z")
                .SetRealNumberBounds(1, MAP_AXIS_LIMIT),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Resize...", function() {
                var xnew = real(self.GetNeighbor("MAP DATA SIZE X"));
                var ynew = real(self.GetNeighbor("MAP DATA SIZE Y"));
                var znew = real(self.GetNeighbor("MAP DATA SIZE Z"));
                var map = Stuff.map.active_map;
                if (xnew == map.xx && ynew == map.yy && znew == map.zz) return;
                if (xnew * ynew * znew >= MAP_VOLUME_LIMIT) {
                    emu_dialog_notice("maps aren't allowed to be larger than " + string(MAP_VOLUME_LIMIT) + " in total volume");
                }
                
                var clear = true;
                for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
                    var entity = map.contents.all_entities[| i];
                    clear &= (entity.xx >= xnew) || (entity.yy >= ynew) || (entity.zz >= znew);
                }
                
                if (clear) {
                    map.SetSize(xnew, ynew, znew);
                } else {
                    var dialog = emu_dialog_confirm(input, "If you do this, entities will be deleted and you will not be able to get them back. Is this okay?", function() {
                        self.root.map.SetSize(self.root.xx, self.root.yy, self.root.zz);
                        self.root.Dispose();
                    });
                    dialog.map = map;
                    dialog.xx = xnew;
                    dialog.yy = ynew;
                    dialog.zz = znew;
                }
            }))
                .SetTooltip("Shrinking a map may result in entities being deleted."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Generic Data", function() {
                dialog_create_map_generic_data();
            }))
                .SetTooltip("You can attach generic data properties to each map, to give the game extra information about it. How you use this is up to you. These properties aren't guaranteed to exist, so the game should always check first before trying to access them."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Advanced", function() {
                dialog_create_settings_map();
            }))
                .SetTooltip("I put the more important settings out here on the main UI, but there are plenty of other things you may need to specify about maps."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Freeze Selected Objects", function() {
                emu_dialog_notice("This has not yet been implemented!");
            }))
                .SetTooltip("Selected objects will be converted to a frozen vertex buffer and will no longer be editable. This means they will be significantly faster to process and render, but they will otherwise be effectively permanently removed. Use with caution."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Clear Frozen Data", function() {
                emu_dialog_confirm(button, "This will permanently delete the frozen vertex buffer data. If you want to get it back, you will have to re-create it (e.g. by re-importing the Tiled map). Are you sure you want to do this?", function() {
                    Stuff.map.active_map.contents.ClearFrozenData();
                    self.root.Dispose();
                });
            }))
                .SetTooltip("Clear the frozen vertex buffer data. There is no way to get it back. Use with caution."),
            #endregion
        ])
            .SetID("MAP")
    ]);
    #endregion
    
    #region inspector
    tab_group.AddTabs(1, [
        (new EmuTab("Entity")).AddContent([
            #region column 1
            new EmuText(col1x, EMU_BASE, element_width, element_height, "[c_aqua]Entity Properties"),
            (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "Name:", "", "entity name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                map_foreach_selected(function(entity, data) {
                    entity.name = data.value;
                }, { value: self.value });
            }))
                .SetTooltip("It can be helpful for the entity names to be unique, although they don't have to be.")
                .SetID("ENTITY NAME")
                .SetInputBoxPosition(0, 0),
            (new EmuText(col1x, EMU_AUTO, element_width, element_height, "Type: N/A"))
                .SetID("ENTITY TYPE"),
            (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Static?", false, function() {
                map_foreach_selected(function(entity, data) {
                    entity.SetStatic(data.value);
                }, { value: self.value });
            })),
            new EmuText(col1x, EMU_AUTO, element_width, element_height, "[c_aqua]Events"),
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Event Pages", element_height, 4, emu_null))
                .SetVacantText("no events")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetCallbackDouble(f_event_page_open)
                .SetID("ENTITY EVENT PAGES"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Add", function() {
                var list = Stuff.map.selected_entities;
                if (ds_list_size(list) != 1) return;
                array_push(list[| 0].object_events, new InstantiatedEvent("Event Page " + string(array_length(list[| 0].object_events))));
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Delete", function() {
                var list = Stuff.map.selected_entities;
                if (ds_list_size(list) != 1) return;
                
                var index = self.GetSibling("ENTITY EVENT PAGES").GetSelection();
                if (index + 1) {
                    var dialog = emu_dialog_confirm(self, "Are you sure you want to delete the event page \"" + list[| 0].object_events[index].name + "?\"", function() {
                        array_delete(self.root.entity.object_events, self.root.index, 1);
                        self.root.list.Deselect();
                        self.root.Dispose();
                    });
                    dialog.entity = list[| 0];
                    dialog.index = index;
                    dialog.list = self.GetSibling("ENTITY EVENT PAGES");
                }
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Edit", f_event_page_open)),
            new EmuText(col1x, EMU_AUTO, element_width, element_height, "[c_aqua]Other Stuff"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Generic Data", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_generic_data();
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Autonomous Movement", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_autonomous_movement();
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Options", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                
                var col1x = 32;
                var col2x = hud_width / 2;
                var element_width = hud_width / 2 - 64;
                var element_height = 32;
                
                var dialog = new EmuDialog(320, 480, "Entity Options");
                dialog.AddContent([
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Direction Fix", false, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.direction_fix = data.value;
                        }, { value: self.value });
                    }))
                        .SetID("ENTITY OPTION DIRECTION FIX"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Always Update", false, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.always_update = data.value;
                        }, { value: self.value });
                    }))
                        .SetID("ENTITY OPTION ALWAYS UPDATE"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Preserve", false, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.preserve_on_save = data.value;
                        }, { value: self.value });
                    }))
                        .SetTooltip("Whether or not the state of the entity is saved when the map is exited, the game is closed, etc.")
                        .SetID("ENTITY OPTION PRESERVE"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Cast Reflection", false, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.reflect = data.value;
                        }, { value: self.value });
                    }))
                        .SetTooltip("Whether or not the entity should show a reflection in water.")
                        .SetID("ENTITY OPTION REFLECT"),
                ])
                    .AddDefaultCloseButton();
            })),
            #endregion
            #region column 2
            new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]Transform"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Position X:", "0", "cell", 10, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.translateable) {
                        Stuff.map.active_map.Move(entity, data.value, entity.yy, entity.zz);
                    }
                }, { value: string(self.value) });
            }))
                .SetRequireConfirm(true)
                .SetID("ENTITY POSITION X"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "0", "cell", 10, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.translateable) {
                        Stuff.map.active_map.Move(entity, entity.xx, data.value, entity.zz);
                    }
                }, { value: string(self.value) });
            }))
                .SetRequireConfirm(true)
                .SetID("ENTITY POSITION Y"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "0", "cell", 10, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.translateable) {
                        Stuff.map.active_map.Move(entity, entity.xx, entity.yy, data.value);
                    }
                }, { value: string(self.value) });
            }))
                .SetRequireConfirm(true)
                .SetID("ENTITY POSITION Z"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Offset X:", "0", "cell", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_xx = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0, 1)
                .SetRequireConfirm(true)
                .SetID("ENTITY OFFSET X"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "0", "cell", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_yy = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0, 1)
                .SetRequireConfirm(true)
                .SetID("ENTITY OFFSET Y"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "0", "cell", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_zz = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0, 1)
                .SetRequireConfirm(true)
                .SetID("ENTITY OFFSET Z"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Rotation X:", "0", "degrees", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.rotateable) {
                        entity.rot_xx = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0, 360)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION X"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "0", "degrees", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_yy = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0, 360)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION Y"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "0", "degrees", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_zz = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0, 360)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION Z"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Scale X:", "1", "x", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.scalable) {
                        entity.scale_xx = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0.01, 100)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION X"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "1", "x", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.scalable) {
                        entity.scale_yy = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0.01, 100)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION Y"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "1", "x", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.scalable) {
                        entity.scale_zz = real(input.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: string(self.value) });
            }))
                .SetRealNumberBounds(0.01, 100)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION Z"),
            #endregion
        ])
            .SetID("ENTITY"),
        (new EmuTab("Mesh")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Meshes", element_height, 22, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                
                var closure = { value: Game.meshes[index] , changed: false, };
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_MESH) return;
                    closure.changed |= entity.mesh.GUID != data.value;
                    entity.SetMesh(mesh, changed ? mesh.first_proto_guid : entity.mesh_submesh);
                }, closure);
                
                if (closure.changed)
                    batch_again();
                
                var submesh_list = self.GetSibling("ENTITY MESH SUBMESH");
                submesh_list.Deselect();
                submesh_list.SetList(mesh.submeshes);
                submesh_list.Select(proto_guid_get(mesh, mesh.first_proto_guid), true);
            }))
                .SetVacantText("no meshes")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetList(Game.meshes)
                .SetID("ENTITY MESH MESH"),
            (new EmuList(col2x, EMU_BASE, element_width, element_height, "Submeshes", element_height, 8, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                
                var submesh = guid_get(entities[| 0].mesh).submeshes[index].proto_guid;
                var closure = { value: submesh, changed: false };
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_MESH) return;
                    closure.changed |= entity.mesh_submesh != data.value;
                    entity.mesh_submesh = data.value;
                }, closure);
                
                if (closure.changed)
                    batch_again();
            }))
                .SetVacantText("no meshes")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetList(Game.meshes)
                .SetID("ENTITY MESH SUBMESH"),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Animation"),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "Animated", false, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_MESH) return;
                    entity.animated = data.value;
                }, { value: self.value });
            }))
                .SetID("ENTITY MESH ANIMATED"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Anim. Speed:", "0", "frames per second", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_MESH) return;
                    entity.animation_speed = data.value;
                }, { value: real(self.value) });
            }))
                .SetID("ENTITY MESH ANIMATION SPEED")
                .SetTooltip("The number of complete animation frames per second. (Animations will not be previewed in the editor.)"),
            (new EmuRadioArray(col2x, EMU_AUTO, element_width, element_height, "End action:", 0, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_MESH) return;
                    entity.animation_end_action = data.value;
                }, { value: self.value });
            }))
                .AddOptions(["Stop", "Loop", "Reverse"])
                .SetID("ENTITY MESH ANIMATION END ACTION")
                .SetTooltip("What do at the end of an animation cycle."),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Other Stuff"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Mesh Autotile Data", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_mesh_autotile_properties();
            })),
        ])
            .SetID("ENTITY MESH"),
        (new EmuTab("Pawn")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Overworld Sprite", element_height, 22, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_PAWN) return;
                    entity.overworld_sprite = data.value;
                }, { value: Game.graphics.overworlds[index].GUID });
            }))
                .SetList(Game.graphics.overworlds)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("ENTITY PAWN SPRITE"),
            (new EmuInput(col2x, EMU_BASE, element_width, element_height, "Frame", "0", "of animation", 4, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_PAWN) return;
                    entity.frame = real(data.value);
                }, { value: real(self.value) });
            }))
                .SetID("ENTITY PAWN FRAME")
                .SetTooltip("The frame of the pawn's animation to show."),
            (new EmuRadioArray(col2x, EMU_AUTO, element_width, element_height, "Direction:", 0, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_PAWN) return;
                    entity.map_direction = data.value;
                }, { value: self.value });
            }))
                .AddOptions(["Down", "Left", "Right", "Up"])
                .SetID("ENTITY PAWN DIRECTION")
                .SetTooltip("The direction you want this pawn to face on the map."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "Animating", false, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.etype != ETypes.ENTITY_PAWN) return;
                    entity.is_animating = data.value;
                }, { value: self.value });
            }))
                .SetID("ENTITY PAWN ANIMATING"),
        ])
            .SetID("ENTITY PAWN"),
        (new EmuTab("Effect")).AddContent([
            new EmuText(col1x, EMU_AUTO, element_width, element_height, "[c_aqua]Effect Components"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Light", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_effect_com_lighting();
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Particle", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                // later
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Audio", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                // later
            })),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Markers", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_effect_com_markers();
            })),
        ])
            .SetID("ENTITY EFFECT"),
        (new EmuTab("Other")).AddContent([
        ])
            .SetID("ENTITY OTHER"),
    ]);
    #endregion
    
    #region world
    tab_group.AddTabs(2, [
        
    ]);
    #endregion
    
    tab_group.RequestActivateTab(tab_group.GetTabByID("GENERAL"));
    
    container.AddContent(tab_group);
    
    return container;
    
        
    with (instance_create_depth(0, 0, 0, UIMain)) {
        #region tab: entity: other
        yy = legal_y + spacing;
        
        element = create_text(col1_x, yy, "These are settings that don't really fit anywhere else", col_width, element_height, fa_left, legal_width, t_p_other);
        ds_list_add(t_p_other.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Zone Data", col_width, element_height, fa_center, null, t_p_other);
        element.tooltip = "If you click on a map zone (camera, weather, audio, encounters, etc), you can edit the parameters of it here.";
        element.interactive = false;
        ds_list_add(t_p_other.contents, element);
        t_p_other.el_zone_data = element;
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: general: tiles
        
        yy = legal_y + spacing;
        
        element = create_button(col1_x, yy, "Change Tileset", 128, element_height, fa_center, function(button) {
            var dg = dialog_create_manager_graphic_tileset(button);
            dg.el_confirm.onmouseup = function(button) {
                var selection = ui_list_selection(button.root.el_list);
                if(selection + 1) {
                    Stuff.map.active_map.tileset = Game.graphics.tilesets[selection].GUID;
                }
                dmu_dialog_commit(button);
            };
        }, t_p_tile_editor);
        ds_list_add(t_p_tile_editor.contents, element);
        
        element = create_button(col1_x + (spacing + 128), yy, "Import Main", 128, element_height, fa_center, function(button) {
            var fn = get_open_filename_image();
            if (file_exists(fn)) {
                var picture = sprite_add(fn, 0, false, false, 0, 0);
                var ts = get_active_tileset();
                sprite_delete(ts.picture);
                ts.picture = picture;
            }
        }, t_p_tile_editor);
        ds_list_add(t_p_tile_editor.contents, element);
        
        element = create_button(col1_x + (spacing + 128) * 2, yy, "Export Main", 128, element_height, fa_center, function(button) {
            var fn = get_save_filename_image("output.png");
            if (fn != "") {
                sprite_save(get_active_tileset().picture, 0, fn);
            }
        }, t_p_tile_editor);
        ds_list_add(t_p_tile_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_tile_selector(col1_x, yy, legal_width - spacing * 2, (legal_width div Stuff.tile_width) * Stuff.tile_width - element_height, function(selector, tx, ty) {
            Stuff.map.selection_fill_tile_x = tx;
            Stuff.map.selection_fill_tile_y = ty;
            selector.tile_x = tx;
            selector.tile_y = ty;
        }, function(selector, tx, ty) {
            var ts = get_active_tileset();
        }, t_p_tile_editor);
        element.tile_x = mode.selection_fill_tile_x;
        element.tile_y = mode.selection_fill_tile_y;
        ds_list_add(t_p_tile_editor.contents, element);
        
        yy += element.height + spacing;
        var yy_aftergrid = yy;
        
        element = create_text(col1_x, yy, "Tile Properties: x, y", col_width, element_height, fa_left, col_width, t_p_tile_editor);
        element.render = method(element, function(text, x, y) {
            text.text = "Tile Properties: " + string(Stuff.map.selection_fill_tile_x) + ", " + string(Stuff.map.selection_fill_tile_y);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_p_tile_editor.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: general: meshes
        yy = legal_y + spacing;
        
        // this is an object variable
        element_mesh_list = create_list(col1_x, yy, "Available meshes: ", "<no meshes>", col_width, element_height, 25, function(list) {
            Stuff.map.selection_fill_mesh = ui_list_selection(list);
            uivc_select_mesh_refresh(Stuff.map.selection_fill_mesh);
        }, false, t_p_mesh_editor, Game.meshes);
        element_mesh_list.entries_are = ListEntries.SCRIPT;
        element_mesh_list.colorize = true;
        element_mesh_list.render = method(element_mesh_list, function(list, x, y) {
            var oldtext = list.text;
            list.text = list.text + string(array_length(list.entries));
            ui_render_list(list, x, y);
            list.text = oldtext;
        });
        element_mesh_list.render_colors = method(element_mesh_list, function(list, index) {
            var mesh = list.entries[index];
            for (var i = 0; i < array_length(mesh.submeshes); i++) {
                if (!mesh.submeshes[i].buffer) return c_red;
            }
            switch (mesh.type) {
                case MeshTypes.RAW: return c_black;
                case MeshTypes.SMF: return c_blue;
            }
            return c_black;
        });
        element_mesh_list.ondoubleclick = method(element_mesh_list, function(list) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) dialog_create_mesh_advanced(undefined, data);
        });
        element_mesh_list.evaluate_text = method(element_mesh_list, function(list, index) {
            var mesh = list.entries[index];
            var prefix = "";
            if (mesh.flags & MeshFlags.PARTICLE) {
                prefix += "p";
            }
            if (mesh.flags & MeshFlags.SILHOUETTE) {
                prefix += "s";
            }
            for (var i = 0; i < array_length(mesh.submeshes); i++) {
                if (mesh.submeshes[i].reflect_buffer) {
                    prefix += "r";
                    break;
                }
            }
            if (string_length(prefix) > 0) {
                prefix = "(" + prefix + ")";
            }
            return prefix + mesh.name;
        });
        element_mesh_list.tooltip = "All meshes available. Legend:\n - RED meshes have one or more submeshes with no vertex buffer associated with it\n - BLUE meshes are SMF meshes, and may have special animations or materials\n - Meshes marked with \"p\" represent particles\n - Meshes marked with \"r\" have one or more reflection meshes associated with them";
        ds_list_add(t_p_mesh_editor.contents, element_mesh_list);
        
        yy += element_mesh_list.GetHeight() + spacing;
        
        element = create_button(col1_x, yy, "Import", col_width, element_height, fa_center, function(button) {
            var fn = get_open_filename_mesh();
            if (file_exists(fn)) {
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, undefined); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, undefined); break;
                    case ".smf": break;
                    case ".dae": import_dae(fn); break;
                }
            }
        }, t_p_mesh_editor);
        element.file_dropper_action = function(element, files) {
            var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".smf", ".dae"]);
            for (var i = 0; i < array_length(filtered_list); i++) {
                var fn = filtered_list[i];
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, true); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, true); break;
                    case ".smf": break;
                    case ".dae": import_dae(fn); break;
                }
            }
        };
        element.tooltip = "Imports a 3D model. The texture coordinates will automatically be scaled on importing; to override this, press the Control key.";
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Delete", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) data.Destroy();
            batch_again();
        }, t_p_mesh_editor);
        element.color = c_red;
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy = legal_y + spacing;
        
        element = create_text(col2_x, yy, "Mesh Properties", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        element.color = c_blue;
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Name:", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "", col_width, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                data.name = input.value;
            }
        }, "", "Name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, 0, vy1, vx2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        t_p_mesh_editor.mesh_name = element;
        
        yy += t_p_mesh_editor.mesh_name.height + spacing;
        
        element = create_text(col2_x, yy, "Internal Name:", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "", col_width, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                internal_name_set(data, input.value);
            }
        }, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, 0, vy1, vx2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        t_p_mesh_editor.mesh_name_internal = element;
        
        yy += t_p_mesh_editor.mesh_name_internal.height + spacing;
        
        s = 10;
        
        var bounds_x = col2_x;
        var bounds_x_2 = bounds_x + col_width / 2;
        
        element = create_text(bounds_x, yy, "Bounds", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        element.color = c_blue;
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(bounds_x, yy, "xmin:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var old_value = data.xmin;
                data.xmin = real(input.value);
                if (old_value != data.xmin) {
                    data_mesh_recalculate_bounds(data);
                }
            }
        }, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        t_p_mesh_editor.xmin = element;
        
        element = create_input(bounds_x_2, yy, "xmax:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var old_value = data.xmax;
                data.xmax = real(input.value);
                if (old_value != data.xmax) {
                    data_mesh_recalculate_bounds(data);
                }
            }
        }, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        t_p_mesh_editor.xmax = element;
        
        yy += element.height + spacing;
        
        element = create_input(bounds_x, yy, "ymin:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var old_value = data.ymin;
                data.ymin = real(input.value);
                if (old_value != data.ymin) {
                    data_mesh_recalculate_bounds(data);
                }
            }
        }, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        t_p_mesh_editor.ymin = element;
        
        element = create_input(bounds_x_2, yy, "ymax:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var old_value = data.ymax;
                data.ymax = real(input.value);
                if (old_value != data.ymax) {
                    data_mesh_recalculate_bounds(data);
                }
            }
        }, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        t_p_mesh_editor.ymax = element;
        
        yy += element.height + spacing;
        
        element = create_input(bounds_x, yy, "zmin:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var old_value = data.zmin;
                data.zmin = real(input.value);
                if (old_value != data.zmin) {
                    data_mesh_recalculate_bounds(data);
                }
            }
        }, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        t_p_mesh_editor.zmin = element;
        
        element = create_input(bounds_x_2, yy, "zmax:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var old_value = data.zmax;
                data.zmax = real(input.value);
                if (old_value != data.zmax) {
                    data_mesh_recalculate_bounds(data);
                }
            }
        }, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        t_p_mesh_editor.zmax = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Flag Data", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                dialog_create_mesh_collision_data(noone, data);
            }
        }, t_p_tile_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Advanced", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) dialog_create_mesh_advanced(undefined, data);
        }, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "General Mesh Things", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        element.color = c_blue;
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Export Selected", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[Stuff.map.selection_fill_mesh];
            if (data) {
                var fn = get_save_filename_mesh("");
                if (string_length(fn) > 0) {
                    switch (filename_ext(fn)) {
                        case ".obj": export_obj(fn, data); break;
                        case ".d3d": case ".gmmod": export_d3d(fn, data); break;
                    }
                }
            }
        }, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        #endregion
    
        #region tab: general: tile animation
        yy = legal_y + spacing;
        
        element = create_list(col1_x, yy, "Animated Tiles: ", "<something is wrong>", col_width, element_height, 28, null, false, t_p_tile_animation_editor);
        element.entries_are = ListEntries.GUIDS;
        element.numbered = true;
        ds_list_add(t_p_tile_animation_editor.contents, element);
        
        t_p_tile_animation_editor.element_list = element;
        
        element = create_text(col2_x, yy, "Animated Tile Properties", col_width, element_height, fa_left, col_width, t_p_tile_animation_editor);
        element.color = c_blue;
        ds_list_add(t_p_tile_animation_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_image_button(col2_x, yy, "Select", noone, col_width, element_height, fa_center, null, t_p_tile_animation_editor);
        ds_list_add(t_p_tile_animation_editor.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: general: other
        yy = legal_y + spacing;
        
        element = create_list(col1_x, yy, "Zone type", "<no zone types>", col_width, element_height, 8, function(list) {
            Settings.selection.zone_type = ui_list_selection(list);
        }, false, t_p_other_editor);
        element.colorize = false;
        element.allow_deselect = false;
        ui_list_select(element, Settings.selection.zone_type);
        create_list_entries(element, ["Camera Zone"], ["Light Zone"], ["Flag Zone"]);
        ds_list_add(t_p_other_editor.contents, element);
        t_p_other_editor.el_zone_type = element;
        
        yy += element.GetHeight() + spacing;
        
        element = create_list(col1_x, yy, "Mesh Autotile type", "<no mesh autotiles types>", col_width, element_height, 8, function(list) {
            var selection = ui_list_selection(list);
            if (selection + 1) {
                Settings.selection.mesh_autotile_type = list.entries[selection].GUID;
            } else {
                Settings.selection.mesh_autotile_type = NULL;
            }
        }, false, t_p_other_editor, Game.mesh_autotiles);
        element.entries_are = ListEntries.INSTANCES;
        ds_list_add(t_p_other_editor.contents, element);
        t_p_other_editor.el_mesh_autotile_type = element;
        
        yy += element.GetHeight() + spacing;
        
        element = create_checkbox(col1_x, yy, "Click to Drag", col_width, element_height, null, false, t_p_other_editor);
        // if this is ever implemented properly, reactivate this
        element.interactive = false;
        t_p_other_editor.el_click_to_drag = element;
        ds_list_add(t_p_other_editor.contents, element);
        #endregion
        
        return id;
    }
}