function ui_init_main(mode) {
    var hud_start_x = 1080;
    var hud_start_y = 0;
    var hud_width = room_width - hud_start_x;
    var hud_height = room_height;
    var col1x = 16;
    var col2x = hud_width / 2 + 16;
    var element_width = hud_width / 2 - 32;
    var element_height = 32;
    
    var container = new EmuCore(0, 0, hud_width, hud_height);
    var tab_group = new EmuTabGroup(hud_start_x, EMU_BASE, hud_width, hud_height, 3, element_height - 4);
    
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
        var selection = self.GetSibling("ENTITY EVENT PAGES").GetSelection();
        if (selection == -1) return;
        dialog_create_entity_event_page(Stuff.map.selected_entities[| 0].object_events[selection]);
    };
    
    #region general
    tab_group.AddTabs(0, [
        (new EmuTab("General")).AddContent([
            #region column 1
            (new EmuRadioArray(col1x, EMU_AUTO, element_width, element_height, "Selection mode:", Settings.selection.mode, function() {
                Settings.selection.mode = self.value;
            }))
                .AddOptions(["Single", "Rectangle"])
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
                    new EmuBitfieldOption("Tile", ETypeFlags.ENTITY_TILE_ANIMATED & ~ETypeFlags.ENTITY, emu_bitfield_option_callback_toggle, emu_bitfield_option_eval_includes),
                    new EmuBitfieldOption("Mesh", ETypeFlags.ENTITY_MESH & ~ETypeFlags.ENTITY, emu_bitfield_option_callback_toggle, emu_bitfield_option_eval_includes),
                    new EmuBitfieldOption("Pawn", ETypeFlags.ENTITY_PAWN & ~ETypeFlags.ENTITY, emu_bitfield_option_callback_toggle, emu_bitfield_option_eval_includes),
                    new EmuBitfieldOption("Effect", ETypeFlags.ENTITY_EFFECT & ~ETypeFlags.ENTITY, emu_bitfield_option_callback_toggle, emu_bitfield_option_eval_includes),
                    new EmuBitfieldOption("All", (ETypeFlags.ENTITY_TILE_ANIMATED | ETypeFlags.ENTITY_MESH | ETypeFlags.ENTITY_PAWN | ETypeFlags.ENTITY_EFFECT) & ~ETypeFlags.ENTITY, emu_bitfield_option_callback_exact, emu_bitfield_option_eval_exact),
                    new EmuBitfieldOption("None", 0x0, emu_bitfield_option_callback_exact, emu_bitfield_option_eval_exact),
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
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "Wireframe alpha:"),
            (new EmuProgressBar(col2x, EMU_AUTO, element_width, element_height, 8, 0, 1, true, Settings.view.wireframe, function() {
                Settings.view.wireframe = self.value;
            }))
                .SetTooltip("The transparency of the wireframes drawn over objects in the world."),
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
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Frozen Data", Settings.view.frozen, function() {
                Settings.view.frozen = self.value;
            }))
                .SetTooltip("Whether or not frozen vertex data (static level geometry) should be visible."),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "View Water", Settings.view.water, function() {
                Settings.view.water = self.value;
            }))
                .SetTooltip("Whether or not water should be visible."),
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
                self.ForEachSelection(function(index) {
                    var entity = Stuff.map.active_map.contents.all_entities[| index];
                    Settings.selection.mask |= entity.etype_flags;
                    var selection = new SelectionSingle(entity.xx, entity.yy, entity.zz);
                });
                
                sa_process_selection();
            }))
                .SetUpdate(function() {
                    self.SetList(Stuff.map.active_map.contents.all_entities);
                })
                .SetVacantText("no entities in this map")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("ALL ENTITIES"),
            #endregion
            #region column 2
            (new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]Entity Stats")),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height * 5, "    Entities:"))
                .SetTextUpdate(function() {
                    var stats = Stuff.map.active_map.contents.stats;
                    return "    Entities:  " + string(stats.GetEntityCount()) + "\n" +
                        "    Static: N/A" + "\n" +
                        "    Solid: N/A" + "\n" +
                        "    Tiles: N/A" + "\n" +
                        "    Autotiles: N/A" + "\n" +
                        "    Meshes: N/A" + "\n" +
                        "    Pawns: N/A" + "\n" +
                        "    Effects: N/A";
                }),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Vertex Data")),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height * 2, "    Storage:\n    Vertices:\n    Triangles:"))
                .SetTextUpdate(function() {
                    var stats = Stuff.map.active_map.contents.stats;
                    var size = stats.GetVertexByteCount();
                    return "    Storage: " + ((size < 1024) ? (string_comma(size) + " bytes") : (string_comma(size >> 10) + " kilobytes")) + "\n" +
                        "    Vertices: " + string_comma(string(stats.GetVertexCount())) + "\n" +
                        "    Triangles: " + string_comma(stats.GetVertexTriangleCount());
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
                .SetListColors(emu_color_maps)
                .SetCallbackDouble(f_map_open)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("MAP LIST"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "New Map", function() {
                var dialog = new EmuDialog(32 + 320 + 32, 480, "New Map");
                
                var col1 = 32;
                var element_width = 320;
                var element_height = 32;
                
                dialog.AddContent([
                    (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Name:", "Map " + string(array_length(Game.maps) + 1), "The name of the map", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() { }))
                        .SetID("NAME"),
                    (new EmuInput(col1, EMU_AUTO, element_width, element_height, "    Width (X):", "160", "The width of the map", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(1, MAP_AXIS_LIMIT)
                        .SetID("X"),
                    (new EmuInput(col1, EMU_AUTO, element_width, element_height, "    Height (Y):", "160", "The height of the map", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(1, MAP_AXIS_LIMIT)
                        .SetID("Y"),
                    (new EmuInput(col1, EMU_AUTO, element_width, element_height, "    Depth (Z):", "8", "The depth of the map", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
                        .SetRealNumberBounds(1, MAP_AXIS_LIMIT)
                        .SetID("Z"),
                    (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Aligned to grid?", true, function() { }))
                        .SetID("GRID"),
                    (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Chunk size:", string(Game.meta.grid.chunk_size), "The size of each chunk of the map; chunks outside of the camera's view will not be updated or rendered (although their contents will continue to exist).", VISIBLE_NAME_LENGTH, E_InputTypes.INT, function() { }))
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
                var xnew = real(self.GetSibling("MAP DATA SIZE X"));
                var ynew = real(self.GetSibling("MAP DATA SIZE Y"));
                var znew = real(self.GetSibling("MAP DATA SIZE Z"));
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
                emu_dialog_generic_variables(Stuff.map.active_map.generic_data);
            }))
                .SetTooltip("You can attach generic data properties to each map, to give the game extra information about it. How you use this is up to you. These properties aren't guaranteed to exist, so the game should always check first before trying to access them."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Advanced", function() {
                dialog_create_map_advanced();
            }))
                .SetTooltip("I put the more important settings out here on the main UI, but there are plenty of other things you may need to specify about maps."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Terrain", function() {
                dialog_create_map_terrain();
            }))
                .SetTooltip("Stuff relating specifically to map terrain."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Freeze Selected Objects", function() {
                emu_dialog_notice("This has not yet been implemented!");
            }))
                .SetTooltip("Selected objects will be converted to a frozen vertex buffer and will no longer be editable. This means they will be significantly faster to process and render, but they will otherwise be effectively permanently removed. Use with caution."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Clear Frozen Data", function() {
                emu_dialog_confirm(undefined, "This will permanently delete the frozen vertex buffer data. If you want to get it back, you will have to re-create it (e.g. by re-importing the Tiled map). Are you sure you want to do this?", function() {
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
            (new EmuInput(col1x, EMU_AUTO, element_width, element_height, "", "", "entity name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                map_foreach_selected(function(entity, data) {
                    entity.name = data.value;
                }, { value: self.value });
            }))
                .SetTooltip("It can be helpful for the entity names to be unique, although they don't have to be.")
                .SetID("ENTITY NAME")
                .SetInputBoxPosition(0, 0)
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "name") ? sel[| 0].name : "*");
                    }
                }),
            (new EmuText(col1x, EMU_AUTO, element_width, element_height, "Type: N/A"))
                .SetID("ENTITY TYPE")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetValue("Type: N/A");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue("Type: " + (map_selection_like_property(sel, "etype") ? global.etype_meta[sel[| 0].etype].name : "(multiple)"));
                    }
                }),
            (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Static?", false, function() {
                map_foreach_selected(function(entity, data) {
                    entity.SetStatic(data.value);
                }, { value: self.value });
            }))
                .SetID("ENTITY STATIC")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "is_static") ? sel[| 0].is_static : 2);
                    }
                }),
            new EmuText(col1x, EMU_AUTO, element_width, element_height, "[c_aqua]Events"),
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Event Pages", element_height, 4, emu_null))
                .SetVacantText("no events")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetCallbackDouble(f_event_page_open)
                .SetID("ENTITY EVENT PAGES")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) != 1) {
                        self.SetInteractive(false);
                        self.SetList([]);
                    } else {
                        self.SetInteractive(true);
                        self.SetList(sel[| 0].object_events);
                    }
                }),
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
                emu_dialog_generic_variables(ds_list_find_value(Stuff.map.selected_entities, 0).generic_data);
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && ds_list_size(sel) == 1);
                }),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Autonomous Movement", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_autonomous_movement();
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && ds_list_size(sel) == 1);
                }),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Options", function() {
                var selection = selection_all();
                
                var dialog = new EmuDialog(320, 480, "Entity Options");
                
                var col1x = 32;
                var col2x = dialog.width / 2;
                var element_width = dialog.height / 2 - 64;
                var element_height = 32;
                
                // i have no idea why gamemaker doesnt like this all of the sudden
                var df_state = map_selection_like_property(selection, "direction_fix") ? ds_list_find_value(selection, 0).direction_fix : 2;
                var au_state = map_selection_like_property(selection, "always_update") ? ds_list_find_value(selection, 0).always_update : 2;
                var preserve_state = map_selection_like_property(selection, "preserve_on_save") ? ds_list_find_value(selection, 0).preserve_on_save : 2;
                var reflect_state = map_selection_like_property(selection, "reflect") ? ds_list_find_value(selection, 0).reflect : 2;
                
                dialog.AddContent([
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Direction Fix", df_state, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.direction_fix = data.value;
                        }, { value: self.value });
                    }))
                        .SetID("ENTITY OPTION DIRECTION FIX"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Always Update", au_state, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.always_update = data.value;
                        }, { value: self.value });
                    }))
                        .SetID("ENTITY OPTION ALWAYS UPDATE"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Preserve", preserve_state, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.preserve_on_save = data.value;
                        }, { value: self.value });
                    }))
                        .SetTooltip("Whether or not the state of the entity is saved when the map is exited, the game is closed, etc.")
                        .SetID("ENTITY OPTION PRESERVE"),
                    (new EmuCheckbox(col1x, EMU_AUTO, element_width, element_height, "Cast Reflection", reflect_state, function() {
                        map_foreach_selected(function(entity, data) {
                            entity.reflect = data.value;
                        }, { value: self.value });
                    }))
                        .SetTooltip("Whether or not the entity should show a reflection in water.")
                        .SetID("ENTITY OPTION REFLECT"),
                ])
                    .AddDefaultCloseButton();
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && ds_list_size(sel) >= 1);
                }),
            #endregion
            #region column 2
            new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]Transform"),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Position X:", "0", "cell", 10, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.translateable) {
                        Stuff.map.active_map.Move(entity, data.value, entity.yy, entity.zz);
                    }
                }, { value: real(self.value) });
            }))
                .SetRequireConfirm(true)
                .SetID("ENTITY POSITION X")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "xx") ? sel[| 0].xx : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "0", "cell", 10, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.translateable) {
                        Stuff.map.active_map.Move(entity, entity.xx, data.value, entity.zz);
                    }
                }, { value: real(self.value) });
            }))
                .SetRequireConfirm(true)
                .SetID("ENTITY POSITION Y")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "yy") ? sel[| 0].yy : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "0", "cell", 10, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.translateable) {
                        Stuff.map.active_map.Move(entity, entity.xx, entity.yy, data.value);
                    }
                }, { value: real(self.value) });
            }))
                .SetRequireConfirm(true)
                .SetID("ENTITY POSITION Z")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "zz") ? sel[| 0].zz : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Offset X:", "0", "cell", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_xx = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0, 1)
                .SetRequireConfirm(true)
                .SetID("ENTITY OFFSET X")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "off_xx") ? sel[| 0].off_xx : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "0", "cell", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_yy = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0, 1)
                .SetRequireConfirm(true)
                .SetID("ENTITY OFFSET Y")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "off_yy") ? sel[| 0].off_yy : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "0", "cell", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_zz = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0, 1)
                .SetRequireConfirm(true)
                .SetID("ENTITY OFFSET Z")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "off_zz") ? sel[| 0].off_zz : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Rotation X:", "0", "degrees", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.rotateable) {
                        entity.rot_xx = real(self.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0, 360)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION X")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "rot_xx") ? sel[| 0].rot_xx : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "0", "degrees", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_yy = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0, 360)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION Y")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "rot_yy") ? sel[| 0].rot_yy : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "0", "degrees", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.offsettable) {
                        entity.off_zz = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0, 360)
                .SetRequireConfirm(true)
                .SetID("ENTITY ROTATION Z")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "rot_zz") ? sel[| 0].rot_zz : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Scale X:", "1", "x", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.scalable) {
                        entity.scale_xx = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0.01, 100)
                .SetRequireConfirm(true)
                .SetID("ENTITY SCALE X")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "scale_xx") ? sel[| 0].scale_xx : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Y:", "1", "x", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.scalable) {
                        entity.scale_yy = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0.01, 100)
                .SetRequireConfirm(true)
                .SetID("ENTITY SCALE Y")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "scale_yy") ? sel[| 0].scale_yy : "");
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "    Z:", "1", "x", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    if (entity.scalable) {
                        entity.scale_zz = real(data.value);
                        editor_map_mark_changed(entity);
                    }
                }, { value: real(self.value) });
            }))
                .SetRealNumberBounds(0.01, 100)
                .SetRequireConfirm(true)
                .SetID("ENTITY SCALE Z")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        self.SetInteractive(true);
                        self.SetValue(map_selection_like_property(sel, "scale_zz") ? sel[| 0].scale_zz : "");
                    }
                }),
            #endregion
        ])
            .SetID("ENTITY"),
        (new EmuTab("Mesh")).AddContent([
            #region column 1
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Meshes", element_height, 22, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var closure = { value: mesh, changed: false, };
                map_foreach_selected(function(entity, closure) {
                    closure.changed |= entity.mesh != closure.value;
                    entity.SetMesh(closure.value, closure.changed ? closure.value.first_proto_guid : entity.mesh_submesh);
                }, closure, ETypeFlags.ENTITY_MESH & ~ETypeFlags.ENTITY);
                
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
                .SetListColors(emu_color_meshes)
                .SetID("ENTITY MESH MESH")
                .SetRefresh(function(sel) {
                    self.Deselect();
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                    } else {
                        self.SetInteractive(true);
                        var common = map_selection_like_property(sel, "mesh", ETypeFlags.ENTITY_MESH);
                        if (common) self.Select(array_search(Game.meshes, guid_get(common.value)), true);
                    }
                }),
            #endregion
            #region column 2
            (new EmuList(col2x, EMU_BASE, element_width, element_height, "Submeshes", element_height, 8, function() {
                if (!self.GetSibling("ENTITY MESH MESH")) return;
                var mesh_index = self.GetSibling("ENTITY MESH MESH").GetSelection();
                if (mesh_index == -1) return;
                var index = self.GetSelection();
                if (index == -1) return;
                
                var submesh = Game.meshes[mesh_index].submeshes[index].proto_guid;
                var closure = { value: submesh, changed: false };
                map_foreach_selected(function(entity, closure) {
                    closure.changed |= entity.mesh_submesh != closure.value;
                    entity.mesh_submesh = closure.value;
                }, closure, ETypeFlags.ENTITY_MESH & ~ETypeFlags.ENTITY);
                
                if (closure.changed)
                    batch_again();
            }))
                .SetVacantText("no meshes")
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("ENTITY MESH SUBMESH")
                .SetRefresh(function(sel) {
                    self.Deselect();
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                    } else {
                        self.SetInteractive(true);
                        var common = map_selection_like_property(sel, "mesh", ETypeFlags.ENTITY_MESH);
                        if (!common) return;
                        
                        var mesh = guid_get(common.value);
                        common = map_selection_like_property(sel, "mesh_submesh", ETypeFlags.ENTITY_MESH);
                        if (common) self.Select(proto_guid_get(mesh, common.value), true);
                    }
                }),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Animation"),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "Animated", false, function() {
                map_foreach_selected(function(entity, data) {
                    entity.animated = data.value;
                }, { value: self.value }, ETypeFlags.ENTITY_MESH & ~ETypeFlags.ENTITY);
            }))
                .SetID("ENTITY MESH ANIMATED")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue(0);
                    } else {
                        var common = map_selection_like_property(sel, "animated", ETypeFlags.ENTITY_MESH);
                        self.SetInteractive(true);
                        self.SetValue(common ? common.value : 2);
                    }
                }),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "Anim. Speed:", "0", "frames per second", 4, E_InputTypes.REAL, function() {
                map_foreach_selected(function(entity, data) {
                    entity.animation_speed = data.value;
                }, { value: real(self.value) }, ETypeFlags.ENTITY_MESH & ~ETypeFlags.ENTITY);
            }))
                .SetID("ENTITY MESH ANIMATION SPEED")
                .SetTooltip("The number of complete animation frames per second. (Animations will not be previewed in the editor.)")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        var common = map_selection_like_property(sel, "animation_speed", ETypeFlags.ENTITY_MESH);
                        self.SetInteractive(true);
                        self.SetValue(common ? common.value : 2);
                    }
                }),
            (new EmuRadioArray(col2x, EMU_AUTO, element_width, element_height, "End action:", 0, function() {
                map_foreach_selected(function(entity, data) {
                    entity.animation_end_action = data.value;
                }, { value: self.value }, ETypeFlags.ENTITY_MESH & ~ETypeFlags.ENTITY);
            }))
                .AddOptions(["Stop", "Loop", "Reverse"])
                .SetID("ENTITY MESH ANIMATION END ACTION")
                .SetTooltip("What do at the end of an animation cycle.")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue(-1);
                    } else {
                        var common = map_selection_like_property(sel, "animation_end_action", ETypeFlags.ENTITY_MESH);
                        self.SetInteractive(true);
                        self.SetValue(common ? common.value : 2);
                    }
                }),
            new EmuText(col2x, EMU_AUTO, element_width, element_height, "[c_aqua]Other Stuff"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Mesh Autotile Data", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                dialog_create_entity_mesh_autotile_properties();
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && map_selection_like_type(sel, ETypeFlags.ENTITY_MESH_AUTO));
                }),
            #endregion
        ])
            .SetID("ENTITY MESH"),
        (new EmuTab("Pawn")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Overworld Sprite", element_height, 22, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                
                map_foreach_selected(function(entity, data) {
                    entity.overworld_sprite = data.value;
                }, { value: Game.graphics.overworlds[index].GUID }, ETypeFlags.ENTITY_PAWN & ~ETypeFlags.ENTITY);
            }))
                .SetList(Game.graphics.overworlds)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("ENTITY PAWN SPRITE")
                .SetRefresh(function(sel) {
                    self.Deselect();
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                    } else {
                        var common = map_selection_like_property(sel, "overworld_sprite", ETypeFlags.ENTITY_PAWN);
                        self.SetInteractive(true);
                        if (common) self.Select(array_search(Game.graphics.overworlds, guid_get(common.value)), true);
                    }
                }),
            (new EmuInput(col2x, EMU_BASE, element_width, element_height, "Frame", "0", "of animation", 4, E_InputTypes.INT, function() {
                map_foreach_selected(function(entity, data) {
                    entity.frame = real(data.value);
                }, { value: real(self.value) }, ETypeFlags.ENTITY_PAWN & ~ETypeFlags.ENTITY);
            }))
                .SetID("ENTITY PAWN FRAME")
                .SetTooltip("The frame of the pawn's animation to show.")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue("");
                    } else {
                        var common = map_selection_like_property(sel, "frame", ETypeFlags.ENTITY_PAWN);
                        self.SetInteractive(true);
                        self.SetValue(common ? common.value : 2);
                    }
                }),
            (new EmuRadioArray(col2x, EMU_AUTO, element_width, element_height, "Direction:", 0, function() {
                map_foreach_selected(function(entity, data) {
                    entity.map_direction = data.value;
                }, { value: self.value }, ETypeFlags.ENTITY_PAWN & ~ETypeFlags.ENTITY);
            }))
                .AddOptions(array_clone(global.rpg_maker_directions))
                .SetID("ENTITY PAWN DIRECTION")
                .SetTooltip("The direction you want this pawn to face on the map.")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue(-1);
                    } else {
                        var common = map_selection_like_property(sel, "map_direction", ETypeFlags.ENTITY_PAWN);
                        self.SetInteractive(true);
                        self.SetValue(common ? common.value : 2);
                    }
                }),
            (new EmuCheckbox(col2x, EMU_AUTO, element_width, element_height, "Animating", false, function() {
                map_foreach_selected(function(entity, data) {
                    entity.is_animating = data.value;
                }, { value: self.value }, ETypeFlags.ENTITY_PAWN & ~ETypeFlags.ENTITY);
            }))
                .SetID("ENTITY PAWN ANIMATING")
                .SetRefresh(function(sel) {
                    if (sel == undefined || ds_list_size(sel) == 0) {
                        self.SetInteractive(false);
                        self.SetValue(false);
                    } else {
                        var common = map_selection_like_property(sel, "is_animating", ETypeFlags.ENTITY_PAWN);
                        self.SetInteractive(true);
                        self.SetValue(common ? common.value : 2);
                    }
                }),
        ])
            .SetID("ENTITY PAWN"),
        (new EmuTab("Effect")).AddContent([
            new EmuText(col1x, EMU_AUTO, element_width, element_height, "[c_aqua]Effect Components"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Light", function() {
                dialog_create_entity_effect_com_lighting();
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && map_selection_like_type(sel, ETypeFlags.ENTITY_EFFECT));
                }),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Particle", function() {
                // later
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && map_selection_like_type(sel, ETypeFlags.ENTITY_EFFECT));
                }),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Audio", function() {
                // later
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && map_selection_like_type(sel, ETypeFlags.ENTITY_EFFECT));
                }),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Markers", function() {
                dialog_create_entity_effect_com_markers();
            }))
                .SetRefresh(function(sel) {
                    self.SetInteractive(sel != undefined && map_selection_like_type(sel, ETypeFlags.ENTITY_EFFECT));
                }),
        ])
            .SetID("ENTITY EFFECT"),
        (new EmuTab("Other")).AddContent([
            new EmuText(col1x, EMU_AUTO, hud_width, element_height, "[c_aqua]This doesn't really fit anywhere else"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Zone data", function() {
                if (ds_list_size(Stuff.map.selected_entities) != 1) return;
                // this behavior will be dependent on the zone type
            }))
                .SetRefresh(function() {
                    var zone = Stuff.map.selected_zone;
                    self.SetInteractive(!!zone);
                    if (!zone) return;
                    self.SetCallback(zone.EditScript);
                    self.text = "Data: " + zone.name;
                })
                .SetTooltip("If you click on a map zone (camera, weather, audio, encounters, etc), you can edit the parameters of it here.")
                .SetID("ZONE DATA"),
        ])
            .SetID("ENTITY OTHER"),
    ]);
    #endregion
    
    #region world
    tab_group.AddTabs(2, [
        (new EmuTab("Mesh Settings")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Meshes:", element_height, 21, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                self.root.Refresh();
            }))
                .SetList(Game.meshes)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetUpdate(function() {
                    self.text = "Meshes: " + string(array_length(Game.meshes));
                })
                .SetListColors(emu_color_meshes)
                .SetCallbackDouble(function() {
                    var index = self.GetSelection();
                    if(index == -1) return;
                    dialog_create_mesh_submesh(Game.meshes[index]);
                })
                .SetTooltip("All meshes available. Legend:\n - RED meshes have one or more submeshes with no vertex buffer associated with it\n - BLUE meshes are SMF meshes, and may have special animations or materials\n - Meshes marked with \"p\" represent particles\n - Meshes marked with \"r\" have one or more reflection meshes associated with them")
                .SetID("MESH LIST"),
            (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Go to Mesh manager", function() {
                momu_meshes();
            }))
                .SetTooltip("Go to the Mesh management window."),
            (new EmuText(col2x, EMU_BASE, element_width, element_height, "[c_aqua]Basic mesh properties")),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "Name:")),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "", "", string(VISIBLE_NAME_LENGTH) + " chars", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                Game.meshes[index].name = self.value;
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].name);
                })
                .SetInputBoxPosition(0, 0)
                .SetID("MESH NAME"),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "Internal name:")),
            (new EmuInput(col2x, EMU_AUTO, element_width, element_height, "", "", string(INTERNAL_NAME_LENGTH) + " chars", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                internal_name_set(Game.meshes[index], self.value);
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].internal_name);
                })
                .SetInputBoxPosition(0, 0)
                .SetID("MESH INTERNAL NAME"),
            (new EmuText(col2x, EMU_AUTO, element_width, element_height, "Bounds:")),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2 - 8, element_height, "x1:", "", "", 4, E_InputTypes.INT, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var old_value = mesh.xmin;
                mesh.xmin = real(self.value);
                if (old_value != mesh.xmin) {
                    mesh.RecalculateBounds();
                }
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].xmin);
                })
                .SetRealNumberBounds(-100, 100)
                .SetID("MESH BOUNDS XMIN"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 2 - 8, element_height, "x2:", "", "", 4, E_InputTypes.INT, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var old_value = mesh.xmax;
                mesh.xmax = real(self.value);
                if (old_value != mesh.xmax) mesh.RecalculateBounds();
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].xmax);
                })
                .SetRealNumberBounds(-100, 100)
                .SetID("MESH BOUNDS XMAX"),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2 - 8, element_height, "y1:", "", "", 4, E_InputTypes.INT, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var old_value = mesh.ymin;
                mesh.ymin = real(self.value);
                if (old_value != mesh.ymin) mesh.RecalculateBounds();
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].ymin);
                })
                .SetRealNumberBounds(-100, 100)
                .SetID("MESH BOUNDS YMIN"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 2 - 8, element_height, "y2:", "", "", 4, E_InputTypes.INT, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var old_value = mesh.ymax;
                mesh.ymax = real(self.value);
                if (old_value != mesh.ymax) mesh.RecalculateBounds();
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].ymax);
                })
                .SetRealNumberBounds(-100, 100)
                .SetID("MESH BOUNDS YMAX"),
            (new EmuInput(col2x, EMU_AUTO, element_width / 2 - 8, element_height, "z1:", "", "", 4, E_InputTypes.INT, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var old_value = mesh.zmin;
                mesh.zmin = real(self.value);
                if (old_value != mesh.zmin) mesh.RecalculateBounds();
                self.root.Refresh();
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].zmin);
                })
                .SetRealNumberBounds(-100, 100)
                .SetID("MESH BOUNDS ZMIN"),
            (new EmuInput(col2x + element_width / 2, EMU_INLINE, element_width / 2 - 8, element_height, "z2:", "", "", 4, E_InputTypes.INT, function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if (index == -1) return;
                
                var mesh = Game.meshes[index];
                var old_value = mesh.zmax;
                mesh.zmax = real(self.value);
                if (old_value != mesh.zmax) mesh.RecalculateBounds();
                self.root.Refresh();
            }))
                .SetRefresh(function() {
                    var index = self.GetSibling("MESH LIST").GetSelection();
                    if (index == -1) return;
                    self.SetValue(Game.meshes[index].zmax);
                })
                .SetRealNumberBounds(-100, 100)
                .SetID("MESH BOUNDS ZMAX"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Auto Calculate Bounds", function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if(index == -1) return;
                Game.meshes[index].AutoCalculateBounds();
                self.root.Refresh();
            }))
                .SetTooltip("Automatically calculate the bounds of a mesh. Rounds to the nearest 32, eg [0, 0, 0] to [28, 36, 32] would be assigned bounds of [0, 0, 0] to [1, 1, 1].")
                .SetID("AUTO CALCULATE BOUNDS"),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Flag Data", function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if(index == -1) return;
                dialog_create_mesh_collision_data(Game.meshes[index]);
            }))
                .SetRefresh(function() {
                    var mesh = self.GetSibling("MESH LIST").GetSelectedItem();
                    self.SetInteractive(!!mesh);
                    if (!mesh) return;
                    var ww = mesh.xmax - mesh.xmin;
                    var hh = mesh.ymax - mesh.ymin;
                    var dd = mesh.zmax - mesh.zmin;
                    if (ww * hh * dd == 0) {
                        self.SetInteractive(false);
                    }
                })
                .SetID("MESH FLAGS")
                .SetTooltip("Go to the Mesh management window."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Submeshes", function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if(index == -1) return;
                dialog_create_mesh_submesh(Game.meshes[index]);
            }))
                .SetTooltip("View and manage mesh submeshes."),
            (new EmuButton(col2x, EMU_AUTO, element_width, element_height, "Advanced", function() {
                var index = self.GetSibling("MESH LIST").GetSelection();
                if(index == -1) return;
                dialog_create_mesh_other_settings(self.GetSibling("MESH LIST").GetAllSelectedIndices());
            }))
                .SetTooltip("General Mesh properties."),
        ])
            .SetID("PLACEMENT MESHES"),
        (new EmuTab("Tile Settings")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Primary map tileset:", element_height, 8, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                Stuff.map.active_map.tileset = Game.graphics.tilesets[index].GUID;
            }))
                .SetRefresh(function() {
                    if (!Stuff.map.active_map) return;
                    for (var i = 0, n = array_length(Game.graphics.tilesets); i < n; i++) {
                        if (Game.graphics.tilesets[i].GUID == Stuff.map.active_map.tileset) {
                            self.Select(i);
                            break;
                        }
                    }
                })
                .SetList(Game.graphics.tilesets)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS),
            (new EmuList(col2x, EMU_INLINE, element_width, element_height, "Water tileset:", element_height, 8, function() {
                var index = self.GetSelection();
                if (index == -1) return;
                Stuff.map.active_map.water_texture = Game.graphics.tilesets[index].GUID;
            }))
                .SetRefresh(function() {
                    if (!Stuff.map.active_map) return;
                    for (var i = 0, n = array_length(Game.graphics.tilesets); i < n; i++) {
                        if (Game.graphics.tilesets[i].GUID == Stuff.map.active_map.water_texture) {
                            self.Select(i);
                            break;
                        }
                    }
                })
                .SetList(Game.graphics.tilesets)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS),
            (new EmuRenderSurface(col1x, EMU_AUTO, hud_width - 64, hud_width - 64, function(mx, my) {
                var image = (Stuff.map.active_map.tileset != NULL) ? guid_get(Stuff.map.active_map.tileset).picture : Game.graphics.tilesets[0].picture;
                
                self.drawCheckerbox(0, 0, self.width, self.height);
                draw_sprite(image, 0, self.offset_x, self.offset_y);
                
                var bs = Stuff.map.selection_fill_tile_size;
                draw_set_alpha(min(bs / 8, 1));
                for (var i = self.offset_x % bs; i < self.width; i += bs) {
                    draw_line_colour(i, 0, i, self.height, c_dkgray, c_dkgray);
                }
                for (var i = self.offset_y % bs; i < self.height; i += bs) {
                    draw_line_colour(0, i, self.width, i, c_dkgray, c_dkgray);
                }
                draw_set_alpha(1);
                
                var tx = Stuff.map.selection_fill_tile_x + self.offset_x;
                var ty = Stuff.map.selection_fill_tile_y + self.offset_y;
                draw_sprite_stretched(spr_terrain_texture_selection, 0, tx, ty, Stuff.map.selection_fill_tile_size, Stuff.map.selection_fill_tile_size);
                draw_rectangle_colour(1, 1, self.width - 2, self.height - 2, c_black, c_black, c_black, c_black, true);
                
                if (mouse_check_button(mb_middle)) {
                    draw_sprite(spr_scroll, 0, mx, my);
                }
            }, function(mx, my) {
                var image = (Stuff.map.active_map.tileset != NULL) ? guid_get(Stuff.map.active_map.tileset).picture : Game.graphics.tilesets[0].picture;
                
                if (!ds_list_empty(EmuOverlay._contents)) return;
                if (!(is_clamped(mx, -16, self.width + 16) && is_clamped(my, -16, self.height + 16))) return;
                
                var bs = Stuff.map.selection_fill_tile_size;
                var tx = bs * ((mx - self.offset_x) div bs);
                var ty = bs * ((my - self.offset_y) div bs);
                tx = clamp(tx, 0, sprite_get_width(image) - bs);
                ty = clamp(ty, 0, sprite_get_height(image) - bs);
                if (mouse_check_button(mb_left)) {
                    Stuff.map.selection_fill_tile_x = tx;
                    Stuff.map.selection_fill_tile_y = ty;
                }
                if (mouse_check_button_pressed(mb_middle)) {
                    self.mx = mx;
                    self.my = my;
                } else if (mouse_check_button(mb_middle)) {
                    self.offset_x = clamp(self.offset_x + (mx - self.mx), min(0, self.width - sprite_get_width(image)), 0);
                    self.offset_y = clamp(self.offset_y + (my - self.my), min(0, self.height - sprite_get_height(image)), 0);
                    self.mx = mx;
                    self.my = my;
                }
            }, function() {
                self.mx = -1;
                self.my = -1;
                self.offset_x = 0;
                self.offset_y = 0;
            }, null))
        ])
            .SetID("PLACEMENT TILES"),
        (new EmuTab("Anim. Settings")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Animated tiles:", element_height, 22, function() {
                // i'm sure i'll figure out what goes here eventually
            })),
        ])
            .SetID("PLACEMENT TILE ANIMATION"),
        (new EmuTab("Misc. Settings")).AddContent([
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Zone type:", element_height, 8, function() {
                Settings.selection.zone_type = self.GetSelection();
            }))
                .SetAllowDeselect(false)
                .SetList(["Camera Zone", "Light Zone", "Flag Zone"])
                .Select(0)
                .SetID("ZONE TYPE"),
            (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Mesh autotile type:", element_height, 8, function() {
                var selection = self.GetSelection();
                if (selection + 1) {
                    Settings.selection.mesh_autotile_type =Game.mesh_autotiles[selection].GUID;
                } else {
                    Settings.selection.mesh_autotile_type = NULL;
                }
            }))
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetList(Game.mesh_autotiles),
        ])
            .SetID("PLACEMENT OTHER"),
    ]);
    #endregion
    
    tab_group.RequestActivateTab(tab_group.GetTabByID("GENERAL"));
    
    container.AddContent([
        (new EmuRenderSurface(0, 0, CW, CH, function() {
            Stuff.map.DrawEditor();
        }, function(mx, my) {
            if (mx >= 0 && my >= 0 && mx < self.width && my < self.height) {
                Stuff.map.camera.Update();
            }
        }, function() {
            // create
        }, function() {
            // destroy
        }))
            .SetID("3D VIEW"),
        tab_group
    ]);
    
    return container;
}