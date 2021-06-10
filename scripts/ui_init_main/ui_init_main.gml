function ui_init_main(mode) {
    with (instance_create_depth(0, 0, 0, UIMain)) {
        
        #region setup
        // it would be best if you don't ask to access these later but if you need to these are just
        // object variables so you can look them up
        t_general = create_tab("General", 0, id);
        t_stats = create_tab("Stats", 0, id);
        t_maps = create_tab("Maps", 0, id);
        
        t_p_tile_editor = create_tab("Tile Ed.", 1, id);
        t_p_tile_animation_editor = create_tab("Tile Anim. Ed.", 1, id);
        t_p_mesh_editor = create_tab("Mesh Ed.", 1, id);
        t_p_other_editor = create_tab("Other Ed.", 1, id);
        
        t_p_entity = create_tab("Entity", 2, id);
        t_p_tile = create_tab("Tile", 2, id);
        t_p_mesh = create_tab("Mesh", 2, id);
        t_p_pawn = create_tab("Pawn", 2, id);
        t_p_effect = create_tab("Effect", 2, id);
        t_p_other = create_tab("Other", 2, id);
        
        // the game will crash if you create a tab row with zero width.
        var tr_general = ds_list_create();
        ds_list_add(tr_general, t_general, t_stats, t_maps);
        var tr_editor = ds_list_create();
        ds_list_add(tr_editor, t_p_tile_editor, t_p_tile_animation_editor, t_p_mesh_editor, t_p_other_editor);
        var tr_world = ds_list_create();
        ds_list_add(tr_world, t_p_entity, t_p_tile, t_p_mesh, t_p_pawn, t_p_effect, t_p_other);
        
        ds_list_add(tabs, tr_general, tr_editor, tr_world);
        
        active_tab = t_general;
        #endregion
        
        // don't try to make three columns. the math has been hard-coded
        // for two. everything will go very badly if you try three or more.
        var element;
        var spacing = 16;
        var legal_x = 32;
        var legal_y = home_row_y + 32;
        var legal_width = ui_legal_width();
        var col_width = legal_width / 2 - spacing * 1.5;
        var col1_x = legal_x + spacing;
        var col2_x = legal_x + col_width + spacing * 2;
        
        var vx1 = col_width / 2;
        var vy1 = 0;
        var vx2 = col_width;
        var vy2 = vy1 + 24;
        
        var button_width = 128;
        
        #region tab: general
        var yy = legal_y + spacing;
        
        element = create_radio_array(col1_x, yy, "Selection mode", col_width, element_height, uivc_radio_selection_mode, Settings.selection.mode, t_general);
        create_radio_array_options(element, ["Single", "Rectangle", "Circle"]);
        ds_list_add(t_general.contents, element);
        
        yy += ui_get_radio_array_height(element) + spacing;
        
        element = create_checkbox(col1_x, yy, "Additive Selection", col_width, element_height, uivc_check_selection_addition, Settings.selection.addition, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_radio_array(col1_x, yy, "Fill Type", col_width, element_height, uivc_radio_fill_type, Settings.selection.fill_type, t_general);
        create_radio_array_options(element, ["Tile", "Animated Tile", "Mesh", "Pawn", "Effect", "Mesh Autotile", "Zone"]);
        ds_list_add(t_general.contents, element);
        
        yy += ui_get_radio_array_height(element) + spacing;
        
        element = create_button(col1_x, yy, "Fill Selection (Space)", col_width, element_height, fa_center, uimu_selection_fill, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Delete Selection (Delete)", col_width, element_height, fa_center, uimu_selection_delete, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        var s = 16;
        
        var f_render_bitfield_selection_mask = function(bitfield, x, y) {
            bitfield.state = (Settings.selection.mask & bitfield.value) == bitfield.value;
            ui_render_bitfield_option_text(bitfield, x, y);
        };
        var f_bitfield_selection_mask = function(bitfield) {
            Settings.selection.mask = Settings.selection.mask ^ bitfield.value;
            sa_process_selection();
        };
        element = create_bitfield(col1_x, yy, "Selection Mask:", col_width, element_height, ETypeFlags.ENTITY_ANY, t_general);
        create_bitfield_options_vertical(element, [
            create_bitfield_option_data(ETypeFlags.ENTITY_TILE, f_render_bitfield_selection_mask, f_bitfield_selection_mask, "Tile", -1, 0, col_width / 2, s),
            create_bitfield_option_data(ETypeFlags.ENTITY_MESH, f_render_bitfield_selection_mask, f_bitfield_selection_mask, "Mesh", -1, 0, col_width / 2, s),
            create_bitfield_option_data(ETypeFlags.ENTITY_PAWN, f_render_bitfield_selection_mask, f_bitfield_selection_mask, "Pawn", -1, 0, col_width / 2, s),
            create_bitfield_option_data(ETypeFlags.ENTITY_EFFECT, f_render_bitfield_selection_mask, f_bitfield_selection_mask, "Effect", -1, 0, col_width / 2, s),
            create_bitfield_option_data(ETypeFlags.ENTITY_ANY, function(bitfield, x, y) {
                bitfield.state = (Settings.selection.mask == ETypeFlags.ENTITY_ANY);
                ui_render_bitfield_option_text(bitfield, x, y);
            }, function(bitfield) {
                Settings.selection.mask = ETypeFlags.ENTITY_ANY;
                sa_process_selection();
            }, "All", -1, 0, col_width / 2, s),
            create_bitfield_option_data(0, function(bitfield, x, y) {
                bitfield.state = (Settings.selection.mask == 0);
                ui_render_bitfield_option_text(bitfield, x, y);
            }, function(bitfield) {
                Settings.selection.mask = 0;
                sa_process_selection();
            }, "None", -1, 0, col_width / 2, s)
        ]);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        // second column
        
        yy = legal_y + spacing;
        
        element = create_checkbox(col2_x, yy, "View Wireframes", col_width, element_height, uivc_check_view_wireframe, Settings.view.wireframe, t_general);
        element.tooltip = "Whether or not you want to view the wireframes to go with visual data.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Grid and Markers", col_width, element_height, uivc_check_view_grids, Settings.view.grid, t_general);
        element.tooltip = "Whether or not you want to view the cell grid and grid axes.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Texture", col_width, element_height, uivc_check_view_texture, Settings.view.texture, t_general);
        element.tooltip = "Whether or not to texture the visuals (to use the tilesets, in common terms). If off, a flat orange texture will be used instead. Most of the time you want this on.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Entities", col_width, element_height, uivc_check_view_entities, Settings.view.entities, t_general);
        element.tooltip = "Whether or not entites should be visible. This is almost everything in the map, and turning it off is quite pointless.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Backfaces", col_width, element_height, uivc_check_view_backface, Settings.view.backface, t_general);
        element.tooltip = "Whether the backs of triangles should be visible. There is a very small performance cost to turning them on. Generally, this is not needed.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Zones", col_width, element_height, uivc_check_view_zones, Settings.view.zones, t_general);
        element.tooltip = "Map zones for things like camera and lighting controls. If you have a lot of them, it can become hard to see through them. Zones can only be blicked on when this is turned on.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Lighting", col_width, element_height, uivc_check_view_lighting, Settings.view.lighting, t_general);
        element.tooltip = "See how the scene looks with lighting. This also affects fog. You may wish to turn this off if you find yourself having a hard time seeing with the lights enabled.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Gizmos", col_width, element_height, uivc_check_view_gizmos, Settings.view.gizmos, t_general);
        element.tooltip = "The helpful frames you see around light sources and other effects and that sort of thing.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "View Terrain", col_width, element_height, uivc_check_view_terrain, Settings.view.terrain, t_general);
        element.tooltip = "The helpful frames you see around light sources and other effects and that sort of thing.";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: stats
        yy = legal_y + spacing;
        
        // if you really want the color-coded entities, maybe make the entry color feature a script instead 
        // of just a list of colors - later, though
        element_all_entities = create_list(col1_x, yy, "All Entities", "<No entities>", col_width, element_height, 28, uivc_list_all_entities, true, t_stats, noone);
        element_all_entities.render = ui_render_list_all_entities;
        element_all_entities.entries_are = ListEntries.INSTANCES;
        ds_list_add(t_stats.contents, element_all_entities);
        
        // second column
        
        yy = legal_y + spacing;
        
        element = create_text(col2_x, yy, "Entity Stats", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing;
        
        var stat_x = col2_x + col_width * 3 / 4;
        
        element = create_text(col2_x, yy, "Total Entities:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(ds_list_size(Stuff.map.active_map.contents.all_entities));
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "     Static:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(Stuff.map.active_map.contents.population_static);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "     Solid:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "     Tiles:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE]);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "     Autotiles:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE_ANIMATED]);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "     Meshes:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(Stuff.map.active_map.contents.population[ETypes.ENTITY_MESH]);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "     Pawns:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(Stuff.map.active_map.contents.population[ETypes.ENTITY_PAWN]);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "     Effects:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            text.text = string(Stuff.map.active_map.contents.population[ETypes.ENTITY_EFFECT]);
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Frozen terrain data:", col_width, element_height, fa_left, col_width, t_stats);
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing / 2;
        
        element = create_text(col2_x, yy, "     - triangles", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            var size = Stuff.map.active_map.contents.frozen_data ? buffer_get_size(Stuff.map.active_map.contents.frozen_data) : 0;
            text.text = "    (" + ((size > 1) ? string(size / VERTEX_SIZE / 3) : "-") + " triangles)";
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "     - vertices", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            var size = Stuff.map.active_map.contents.frozen_data ? buffer_get_size(Stuff.map.active_map.contents.frozen_data) : 0;
            text.text = "    (" + ((size > 1) ? string(size / VERTEX_SIZE) : "-") + " vertices)";
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "    - kb", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            var size = Stuff.map.active_map.contents.frozen_data ? buffer_get_size(Stuff.map.active_map.contents.frozen_data) : 0;
            text.text = "    " + ((size > 1) ? string_comma(ceil(size >> 10)) : "-") + " kb";
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height;
        
        element = create_text(col2_x, yy, "    ( - bytes)", col_width, element_height, fa_left, col_width, t_stats);
        element.render = method(element, function(text, x, y) {
            var size = Stuff.map.active_map.contents.frozen_data ? buffer_get_size(Stuff.map.active_map.contents.frozen_data) : 0;
            text.text = "    (" + ((size > 1) ? string(size) : "-") + " bytes)";
            ui_render_text(text, x, y);
        });
        ds_list_add(t_stats.contents, element);
        
        yy += element.height + spacing / 2;
        #endregion
        
        #region tab: map
        yy = legal_y + spacing;
        
        var f_map_open = function(element) {
            var list = element.root.el_map_list;
            var index = ui_list_selection(list);
            var map = Game.maps[| index];
            if (map != Stuff.map.active_map) {
                selection_clear();
                load_a_map(map);
            }
        };
        
        element = create_list(col1_x, yy, "Maps: ", "no maps. (how?!)", col_width, element_height, 20, null, false, t_maps, Game.maps);
        element.onvaluechange = method(element, function(list) {
            var selection = ui_list_selection(list);
            if (selection + 1) {
                var what = list.entries[| selection];
                list.root.el_name.interactive = true;
                ui_input_set_value(list.root.el_name, what.name);
                list.root.el_internal_name.interactive = true;
                ui_input_set_value(list.root.el_internal_name, what.internal_name);
                list.root.el_summary.interactive = true;
                ui_input_set_value(list.root.el_summary, what.summary);
                // resizing a map checks if any entities will be deleted and warns you if any
                // will; maps that are not loaded do not have a list of their entities on hand,
                // and trying to check this is not worth the trouble
                list.root.el_dim_x.interactive = (what == Stuff.map.active_map);
                ui_input_set_value(list.root.el_dim_x, string(what.xx));
                list.root.el_dim_y.interactive = (what == Stuff.map.active_map);
                ui_input_set_value(list.root.el_dim_y, string(what.yy));
                list.root.el_dim_z.interactive = (what == Stuff.map.active_map);
                ui_input_set_value(list.root.el_dim_z, string(what.zz));
                list.root.el_other.interactive = true;
                list.root.el_3d.value = what.is_3d;
                list.root.el_3d.interactive = true;
            } else {
                list.root.el_name.interactive = false;
                list.root.el_internal_name.interactive = false;
                list.root.el_summary.interactive = false;
                list.root.el_dim_x.interactive = false;
                list.root.el_dim_y.interactive = false;
                list.root.el_dim_z.interactive = false;
                list.root.el_other.interactive = false;
                list.root.el_3d.interactive = false;
            }
        });
        element.tooltip = "This is a list of all the maps currently in the game.";
        element.render_colors = method(element, function(list, index) {
            return (Game.meta.start.map == list.entries[| index].GUID) ? c_blue : c_black;
        });
        element.colorize = true;
        element.ondoubleclick = method(element, f_map_open);
        element.entries_are = ListEntries.INSTANCES;
        t_maps.el_map_list = element;
        ds_list_add(t_maps.contents, element);
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(col1_x, yy, "Add Map", col_width, element_height, fa_center, function(button) {
            dialog_create_new_map(noone);
        }, t_maps);
        element.tooltip = "Add a map. You can have up to " + string(0xffff) + " maps in the game. I seriously doubt anyone will need anywhere near that many.";
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Delete Map", col_width, element_height, fa_center, function(button) {
            var list = button.root.el_map_list;
            var index = ui_list_selection(list);
            var map = Game.maps[| index];
            if (map == Stuff.map.active_map) {
                emu_dialog_notice("Please don't delete a map that you currently have loaded. If you want to delete this map, load a different one first.");
            } else {
                instance_activate_object(map);
                instance_destroy(map);
                ui_list_deselect(button.root.el_map_list);
                ui_list_select(button.root.el_map_list, ds_list_find_index(Game.maps, Stuff.map.active_map));
            }
        }, t_maps);
        element.tooltip = "Delete the currently selected map. Any existing references to it will no longer work. You should only use this if you're absolutely sure; generally speaking, maps not loaded into memory will not affect the game very much.";
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Open Map", col_width, element_height, fa_center, f_map_open, t_maps);
        element.tooltip = "Open the currently selected map for editing. Double-clicking it in the list will have the same effect.";
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Make Starting Map", col_width, element_height, fa_center, function(button) {
            var list = button.root.el_map_list;
            var index = ui_list_selection(list);
            Game.meta.start.map = list.entries[| index].GUID;
        }, t_maps);
        element.tooltip = "Designate the currently selected map as the first one entered when the game starts. What this means to your game is up to you.";
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Import Tiled", col_width, element_height, fa_center, function(button) {
            import_map_tiled(true);
        }, t_maps);
        element.tooltip = "Import a Tiled map editor file (json version). Tile data will be imported as frozen terrain; the editor will attempt to convert other data to Entities.";
        ds_list_add(t_maps.contents, element);
        
        yy = legal_y + spacing;
        
        element = create_text(col2_x, yy, "Name:", col_width, element_height, fa_left, col_width, t_maps);
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "", col_width, element_height, function(input) {
            var selection = ui_list_selection(input.root.el_map_list);
            if (selection + 1) {
                Game.maps[| selection].name = input.value;
            }
        }, "", "Name", validate_string, 0, 0, VISIBLE_NAME_LENGTH, 0, vy1, vx2, vy2, t_maps);
        element.tooltip = "The name of the map, as it appears to the player.";
        ds_list_add(t_maps.contents, element);
        t_maps.el_name = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Internal name:", col_width, element_height, fa_left, col_width, t_maps);
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "", col_width, element_height, function(input) {
            var selection = ui_list_selection(input.root.el_map_list);
            if (selection + 1) {
                internal_name_set(Game.maps[| selection], input.value);
            }
        }, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 0, INTERNAL_NAME_LENGTH, 0, vy1, vx2, vy2, t_maps);
        element.tooltip = "The internal name of the map, as it appears to the developer. Standard restrictions on internal names apply.";
        ds_list_add(t_maps.contents, element);
        t_maps.el_internal_name = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Summary:", col_width, element_height, fa_left, col_width, t_maps);
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "", col_width, element_height, function(input) {
            var selection = ui_list_selection(input.root.el_map_list);
            if (selection + 1) {
                Game.maps[| selection].summary = input.value;
            }
        }, "", "Words", validate_string, 0, 0, 400, 0, vy1, vx2, vy2, t_maps);
        element.tooltip = "A description of the map. Try not to make this too long. You may wish to use Scribble formatting tags.";
        ds_list_add(t_maps.contents, element);
        t_maps.el_summary = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Dimensions", col_width, element_height, fa_left, col_width, t_maps);
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Width (X): ", col_width, element_height, uivc_input_map_size_x, "64", "width", validate_int_map_size_x, 1, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, t_maps);
        element.tooltip = "The width of the map, in tiles. Press Enter to confirm. Shrinking a map may result in entities being deleted.";
        element.require_enter = true;
        ds_list_add(t_maps.contents, element);
        t_maps.el_dim_x = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Height (Y): ", col_width, element_height, uivc_input_map_size_y, "64", "height", validate_int_map_size_y, 1, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, t_maps);
        element.tooltip = "The height of the map, in tiles. Press Enter to confirm. Shrinking a map may result in entities being deleted.";
        element.require_enter = true;
        ds_list_add(t_maps.contents, element);
        t_maps.el_dim_y = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Depth (Z): ", col_width, element_height, uivc_input_map_size_z, "8", "depth", validate_int_map_size_z, 1, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, t_maps);
        element.tooltip = "The depth of the map, in tiles. Press Enter to confirm. Shrinking a map may result in entities being deleted.";
        element.require_enter = true;
        ds_list_add(t_maps.contents, element);
        t_maps.el_dim_z = element;
        
        yy += element.height + spacing * 3;
        
        element = create_text(col2_x, yy, "Maps can go up to " + string(MAP_AXIS_LIMIT) + " in any dimension, but the total volume must be lower than " + string_comma(MAP_VOLUME_LIMIT) + ".", col_width, element_height, fa_left, col_width, t_maps);
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing * 3;
        
        element = create_checkbox(col2_x, yy, "Is 3D?", col_width, element_height, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.el_map_list);
            if (selection + 1) {
                Game.maps[| selection].is_3d = checkbox.value;
            }
        }, false, t_maps);
        element.tooltip = "This is my favorite checkbox in the whole entire editor.";
        ds_list_add(t_maps.contents, element);
        t_maps.el_3d = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy,  "Generic Data", col_width, element_height, fa_center, dialog_create_map_generic_data, t_maps);
        element.tooltip = "You can attach generic data properties to each map, to give the game extra information about it. How you use this is up to you. These properties aren't guaranteed to exist, so the game should always check first before trying to access them.";
        ds_list_add(t_maps.contents, element);
        t_maps.el_other = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy,  "Advanced", col_width, element_height, fa_center, dialog_create_settings_map, t_maps);
        element.tooltip = "I put the more important settings out here on the main UI, but there are plenty of other things you may need to specify about maps.";
        ds_list_add(t_maps.contents, element);
        t_maps.el_other = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Freeze Selected Objects", col_width, element_height, fa_center, null, t_maps);
        element.tooltip = "Selected objects will be converted to a frozen vertex buffer and will no longer be editable. This means they will be significantly faster to process and render, but they will otherwise be effectively permanently removed. Use with caution.";
        element.inheritRender = element.render;
        element.render = function(button, x, y) {
            var selection = ui_list_selection(button.root.el_map_list);
            button.interactive = false;
            if (Game.maps[| selection] == Stuff.map.active_map) button.interactive = true;
            // remove this line if this feature ever gets added
            button.interactive = false;
            button.inheritRender(button, x, y);
        };
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Clear Frozen Data", col_width, element_height, fa_center, function(button) {
            emu_dialog_confirm(button, "This will permanently delete the frozen vertex buffer data. If you want to get it back, you will have to re-create it (e.g. by re-importing the Tiled map). Are you sure you want to do this?", function() {
                Stuff.map.active_map.contents.ClearFrozenData();
                self.root.Dispose();
            });
        }, t_maps);
        element.inheritRender = element.render;
        element.render = function(button, x, y) {
            var selection = ui_list_selection(button.root.el_map_list);
            button.interactive = false;
            if (Game.maps[| selection] == Stuff.map.active_map) button.interactive = true;
            button.inheritRender(button, x, y);
        };
        element.tooltip = "Clear the frozen vertex buffer data. There is no way to get it back. Use with caution.";
        ds_list_add(t_maps.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: entity
        yy = legal_y + spacing;
        
        draw_set_font(FDefault12);
        var max_characters = 32;
        vx2 = vx1 + 288;
        
        element_entity_name = create_input(col1_x, yy, "Name: ", legal_width, element_height, uivc_input_entity_name, "", "Helpful if unique", validate_string, 0, 1, max_characters, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_name);
        element_entity_name.interactive = false;
        
        vx2 = col_width;
        yy += element_entity_name.height + spacing;
        
        element = create_text(col1_x, yy, "Basic Properties", col_width, element_height, fa_left, col_width, t_p_entity);
        element.color = c_blue;
        ds_list_add(t_p_entity.contents, element);
        
        yy += element.height + spacing;
        
        element_entity_type = create_text(col1_x, yy, "Type:", col_width, element_height, fa_left, col_width, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_type);
        
        yy += element_entity_type.height + spacing;
        
        element_entity_static = create_checkbox(col1_x, yy, "Static", col_width, element_height, uivc_check_entity_static, false, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_static);
        element_entity_static.interactive = false;
        
        yy += element_entity_static.height + spacing;
        
        var n = 6;
        
        element_entity_events = create_list(col1_x, yy, "Event Pages", "<No events>", col_width, element_height, n, null, false, t_p_entity, noone);
        element_entity_events.colorize = false;
        element_entity_events.render = ui_render_list_entity_events;
        element_entity_events.entries_are = ListEntries.INSTANCES;
        element_entity_events.ondoubleclick = omu_entity_event_page;
        ds_list_add(t_p_entity.contents, element_entity_events);
        element_entity_events.interactive = false;
        
        yy += ui_get_list_height(element_entity_events) + spacing;
        
        element_entity_event_edit = create_button(col1_x, yy, "Edit Event Page", col_width, element_height, fa_center, omu_entity_event_page, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_event_edit);
        element_entity_event_edit.interactive = false;
        
        yy += element_height + spacing;
        
        element_entity_event_add = create_button(col1_x, yy, "Add Event Page", col_width, element_height, fa_center, omu_entity_add_event, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_event_add);
        element_entity_event_add.interactive = false;
        
        yy += element_height + spacing;
        
        element_entity_event_remove = create_button(col1_x, yy, "Delete Event Page", col_width, element_height, fa_center, omu_entity_remove_event, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_event_remove);
        element_entity_event_remove.interactive = false;
        
        yy += element_height + spacing;
        
        element = create_text(col1_x, yy, "Options", col_width, element_height, fa_left, col_width, t_p_entity);
        element.color = c_blue;
        ds_list_add(t_p_entity.contents, element);
        
        yy += element.height + spacing;
        
        element_entity_option_direction_fix = create_checkbox(col1_x, yy, "Direction Fix", col_width, element_height, function(checkbox) {
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].direction_fix = checkbox.value;
            }
        }, false, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_option_direction_fix);
        element_entity_option_direction_fix.interactive = false;
        
        yy += element_entity_option_direction_fix.height;
        
        element_entity_option_always_update = create_checkbox(col1_x, yy, "Always Update?", col_width, element_height, function(checkbox) {
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].always_update = checkbox.value;
            }
        }, false, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_option_always_update);
        element_entity_option_always_update.interactive = false;
        
        yy += element_entity_option_always_update.height;
        
        element_entity_option_preserve = create_checkbox(col1_x, yy, "Preserve?", col_width, element_height, function(checkbox) {
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].preserve_on_save = checkbox.value;
            }
        }, false, t_p_entity);
        element_entity_option_preserve.tooltip = "Whether or not the state of the entity is saved when the map is exited, the game is closed, etc.";
        ds_list_add(t_p_entity.contents, element_entity_option_preserve);
        element_entity_option_preserve.interactive = false;
        
        yy += element_entity_option_preserve.height;
        
        element_entity_option_reflect = create_checkbox(col1_x, yy, "Cast Reflection?", col_width, element_height, function(checkbox) {
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].reflect = checkbox.value;
            }
        }, false, t_p_entity);
        element_entity_option_reflect.tooltip = "Whether or not the entity should show a reflection in water.";
        ds_list_add(t_p_entity.contents, element_entity_option_reflect);
        element_entity_option_reflect.interactive = false;
        
        yy += element_entity_option_reflect.height + spacing;
        
        element_entity_generic = create_button(col1_x, yy, "Generic Data", col_width, element_height, fa_center, omu_entity_generic_data, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_generic);
        element_entity_generic.interactive = false;
        
        yy += element_height + spacing;
        
        element_entity_option_autonomous_movement = create_button(col1_x, yy, "Autonomous Movement", col_width, element_height, fa_center, omu_entity_autonomous_movement, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_option_autonomous_movement);
        element_entity_option_autonomous_movement.interactive = false;
        
        yy += element_entity_option_autonomous_movement.height + spacing;
        
        // second column
        
        yy = legal_y + spacing + element_entity_name.height + spacing;
        
        element = create_text(col2_x, yy, "Transform: Position", col_width, element_height, fa_left, col_width, t_p_entity);
        element.color = c_blue;
        ds_list_add(t_p_entity.contents, element);
        
        yy += element_height + spacing;
        
        element_entity_pos_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_pos_x, "", "Cell", validate_int, 0, 64, 5, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_pos_x);
        element_entity_pos_x.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_pos_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_pos_y, "", "Cell", validate_int, 0, 64, 5, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_pos_y);
        element_entity_pos_y.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_pos_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_pos_z, "", "Cell", validate_int, 0, 64, 5, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_pos_z);
        element_entity_pos_z.interactive = false;
        
        yy += element_height + spacing;
        
        element = create_text(col2_x, yy, "Transform: Position Offset", col_width, element_height, fa_left, col_width, t_p_entity);
        element.color = c_blue;
        ds_list_add(t_p_entity.contents, element);
        
        yy += element_height + spacing;
        
        element_entity_offset_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_off_x, "", "0...1", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_offset_x);
        element_entity_offset_x.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_offset_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_off_y, "", "0...1", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_offset_y);
        element_entity_offset_y.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_offset_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_off_z, "", "0...1", validate_double, 0, 1, 4, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_offset_z);
        element_entity_offset_z.interactive = false;
        
        yy += element_height + spacing;
        
        element = create_text(col2_x, yy, "Transform: Rotation", col_width, element_height, fa_left, col_width, t_p_entity);
        element.color = c_blue;
        ds_list_add(t_p_entity.contents, element);
        
        yy += element_height + spacing;
        
        element_entity_rot_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_rotate_x, "", "Degrees", validate_int, 0, 359, 3, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_rot_x);
        element_entity_rot_x.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_rot_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_rotate_y, "", "Degrees", validate_int, 0, 359, 3, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_rot_y);
        element_entity_rot_y.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_rot_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_rotate_z, "", "Degrees", validate_int, 0, 359, 3, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_rot_z);
        element_entity_rot_z.interactive = false;
        
        yy += element_height + spacing;
        
        element = create_text(col2_x, yy, "Transform: Scale", col_width, element_height, fa_left, col_width, t_p_entity);
        element.color = c_blue;
        ds_list_add(t_p_entity.contents, element);
        
        yy += element_height + spacing;
        
        element_entity_scale_x = create_input(col2_x, yy, "   X: ", col_width, element_height, uivc_input_entity_scale_x, "", "0.1...10", validate_double, 0.1, 10, 5, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_scale_x);
        element_entity_scale_x.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_scale_y = create_input(col2_x, yy, "   Y: ", col_width, element_height, uivc_input_entity_scale_y, "", "0.1...10", validate_double, 0.1, 10, 5, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_scale_y);
        element_entity_scale_y.interactive = false;
        
        yy += element_height + spacing / 2;
        
        element_entity_scale_z = create_input(col2_x, yy, "   Z: ", col_width, element_height, uivc_input_entity_scale_z, "", "0.1...10", validate_double, 0.1, 10, 5, vx1, vy1, vx2, vy2, t_p_entity);
        ds_list_add(t_p_entity.contents, element_entity_scale_z);
        element_entity_scale_z.interactive = false;
        
        yy += element_height + spacing;
        #endregion
        
        #region tab: entity: mesh
        yy = legal_y + spacing;
        
        element_entity_mesh_list = create_list(col1_x, yy, "Mesh", "<no meshes>", col_width, element_height, 16, function(list) {
            var mesh = Game.meshes[| ui_list_selection(list)];
            // this assumes that every selected entity is already an instance of Mesh
            var entities = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(entities); i++) {
                // if the mesh changes, you should probably also reset the proto guid
                if (guid_get(entities[| i].mesh) != mesh) {
                    entities[| i].mesh_submesh = mesh.first_proto_guid;
                }
                entities[| i].mesh = mesh.GUID;
            }
            batch_again(undefined);
            Stuff.map.ui.element_entity_mesh_submesh.entries = mesh.submeshes;
            ui_list_deselect(Stuff.map.ui.element_entity_mesh_submesh);
            ui_list_select(Stuff.map.ui.element_entity_mesh_submesh, proto_guid_get(mesh, mesh.first_proto_guid), true);
        }, false, t_p_mesh, Game.meshes);
        element_entity_mesh_list.allow_deselect = false;
        element_entity_mesh_list.entries_are = ListEntries.INSTANCES;
        ds_list_add(t_p_mesh.contents, element_entity_mesh_list);
        element_entity_mesh_list.interactive = false;
        
        yy += ui_get_list_height(element_entity_mesh_list) + spacing;
        
        element_entity_mesh_submesh = create_list(col1_x, yy, "Submesh", "<choose a single mesh>", col_width, element_height, 10, function(list) {
            var entities = Stuff.map.selected_entities;
            var mesh_data = guid_get(entities[| 0].mesh);
            var submesh = mesh_data.submeshes[| ui_list_selection(list)].proto_guid;
            for (var i = 0; i < ds_list_size(entities); i++) {
                entities[| i].mesh_submesh = submesh;
            }
            batch_again(undefined);
        }, false, t_p_mesh, noone);
        element_entity_mesh_submesh.allow_deselect = false;
        element_entity_mesh_submesh.entries_are = ListEntries.INSTANCES;
        ds_list_add(t_p_mesh.contents, element_entity_mesh_submesh);
        element_entity_mesh_submesh.interactive = false;
        
        yy += ui_get_list_height(element_entity_mesh_submesh) + spacing;
        
        yy = legal_y + spacing;
            
        element_entity_mesh_autotile_data = create_button(col2_x, yy, "Mesh Autotile Data", col_width, element_height, fa_center, function(button) {
            dialog_create_entity_mesh_autotile_properties(button);
        }, t_p_mesh);
        ds_list_add(t_p_mesh.contents, element_entity_mesh_autotile_data);
        element_entity_mesh_autotile_data.interactive = false;
        
        yy += element_entity_mesh_autotile_data.height + spacing;
        
        element_entity_mesh_animated = create_checkbox(col2_x, yy, "Animated", col_width, element_height, function(checkbox) {
            // this assumes that every selected entity is already an instance of Mesh
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].animated = checkbox.value;
            }
        }, false, t_p_mesh);
        ds_list_add(t_p_mesh.contents, element_entity_mesh_animated);
        element_entity_mesh_animated.interactive = false;
        
        yy += element_entity_mesh_animated.height + spacing;
        
        element_entity_mesh_animation_speed = create_input(col2_x, yy, "Anim. Spd:", col_width, element_height, function(input) {
            // this assumes that every selected entity is already an instance of Mesh
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].animation_speed = real(input.value);
            }
        }, 1, "-60 to 60", validate_int, -60, 60, 3, vx1, vy1, vx2, vy2, t_p_mesh);
        element_entity_mesh_animation_speed.tooltip = "The number of complete animation frames per second. (Animations will not be previewed in the editor.)";
        ds_list_add(t_p_mesh.contents, element_entity_mesh_animation_speed);
        element_entity_mesh_animation_speed.interactive = false;
        
        yy += element_entity_mesh_animation_speed.height + spacing;
        
        element_entity_mesh_animation_end_action = create_radio_array(col2_x, yy, "End Action:", col_width, element_height, function(radio) {
            // this assumes that every selected entity is already an instance of Mesh
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].animation_end_action = radio.value;
            }
        }, 0, t_p_mesh);
        create_radio_array_options(element_entity_mesh_animation_end_action, ["Stop", "Loop", "Reverse"]);
        element_entity_mesh_animation_end_action.tooltip = "The number of complete animation cycles per second";
        ds_list_add(t_p_mesh.contents, element_entity_mesh_animation_end_action);
        element_entity_mesh_animation_end_action.interactive = false;
        
        yy += ui_get_radio_array_height(element_entity_mesh_animation_end_action) + spacing;
        #endregion
        
        #region tab: entity: pawn
        yy = legal_y + spacing;
        
        element_entity_pawn_frame = create_input(col1_x, yy, "Frame:", col_width, element_height, function(input) {
            // this assumes that every selected entity is already an instance of Pawn
            var list = Stuff.map.selected_entities;
            var conversion = real(thing.value);
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].frame = conversion;
            }
        }, 0, "0...3", validate_int, 0, 3, 1, vx1, vy1, vx2, vy2, t_p_pawn);
        ds_list_add(t_p_pawn.contents, element_entity_pawn_frame);
        
        yy += element_entity_pawn_frame.height + spacing;
        
        element_entity_pawn_direction = create_radio_array(col1_x, yy, "Direction", col_width, element_height, function(radio) {
            // this assumes that every selected entity is already an instance of Pawn
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].map_direction = radio.value;
            }
        }, 0, t_p_pawn);
        create_radio_array_options(element_entity_pawn_direction, ["Down", "Left", "Right", "Up"]);
        ds_list_add(t_p_pawn.contents, element_entity_pawn_direction);
        
        yy += ui_get_radio_array_height(element_entity_pawn_direction) + spacing;
        
        element_entity_pawn_animating = create_checkbox(col1_x, yy, "Animating", col_width, element_height, function(checkbox) {
            // this assumes that every selected entity is already an instance of Pawn
            var list = Stuff.map.selected_entities;
            for (var i = 0; i < ds_list_size(list); i++) {
                list[| i].is_animating = checkbox.value;
            }
        }, false, t_p_pawn);
        ds_list_add(t_p_pawn.contents, element_entity_pawn_animating);
        
        yy += element_entity_pawn_animating.height + spacing;
        
        element_entity_pawn_sprite = create_list(col1_x, yy, "Overworld Sprite", "<no overworlds>", col_width, element_height, 12, function(list) {
            // this assumes that every selected entity is already an instance of Pawn
            var entities = Stuff.map.selected_entities;
            var selection = ui_list_selection(list);
            if (selection + 1) {
                for (var i = 0; i < ds_list_size(entities); i++) {
                    entities[| i].overworld_sprite = Game.graphics.overworlds[| selection].GUID;
                }
            }
        }, false, t_p_pawn, Game.graphics.overworlds);
        element_entity_pawn_sprite.entries_are = ListEntries.INSTANCES;
        ds_list_add(t_p_pawn.contents, element_entity_pawn_sprite);
        
        yy += ui_get_list_height(element_entity_pawn_sprite) + spacing;
        #endregion
        
        #region tab: entity: effect
        yy = legal_y + spacing;
        
        element = create_text(col1_x, yy, "Effect Components", col_width, element_height, fa_left, col_width, t_p_effect);
        ds_list_add(t_p_effect.contents, element);
        
        yy += element.height + spacing;
        
        element_effect_com_light = create_button(col1_x, yy, "Light", col_width, element_height, fa_center, function(button) {
            dialog_create_entity_effect_com_lighting(button);
        }, t_p_effect);
        element_effect_com_light.interactive = false;
        ds_list_add(t_p_effect.contents, element_effect_com_light);
        
        yy += element_effect_com_light.height + spacing;
        
        element_effect_com_particle = create_button(col1_x, yy, "Particle", col_width, element_height, fa_center, null, t_p_effect);
        element_effect_com_particle.interactive = false;
        ds_list_add(t_p_effect.contents, element_effect_com_particle);
        
        yy += element_effect_com_particle.height + spacing;
        
        element_effect_com_audio = create_button(col1_x, yy, "Audio", col_width, element_height, fa_center, null, t_p_effect);
        element_effect_com_audio.interactive = false;
        ds_list_add(t_p_effect.contents, element_effect_com_audio);
        
        yy += element_effect_com_audio.height + spacing;
        #endregion
        
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
                    Stuff.map.active_map.tileset = Game.graphics.tilesets[| selection].GUID;
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
            list.text = list.text + string(ds_list_size(list.entries));
            ui_render_list(list, x, y);
            list.text = oldtext;
        });
        element_mesh_list.render_colors = method(element_mesh_list, function(list, index) {
            var mesh = list.entries[| index];
            for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
                if (!mesh.submeshes[| i].buffer) {
                    return c_red;
                }
            }
            switch (mesh.type) {
                case MeshTypes.RAW: return c_black;
                case MeshTypes.SMF: return c_blue;
            }
            return c_black;
        });
        element_mesh_list.ondoubleclick = method(element_mesh_list, function(list) {
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
            if (data) dialog_create_mesh_advanced(undefined, data);
        });
        element_mesh_list.evaluate_text = method(element_mesh_list, function(list, index) {
            var mesh = list.entries[| index];
            var prefix = "";
            if (mesh.flags & MeshFlags.PARTICLE) {
                prefix += "p";
            }
            if (mesh.flags & MeshFlags.SILHOUETTE) {
                prefix += "s";
            }
            for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
                if (mesh.submeshes[| i].reflect_buffer) {
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
        
        yy += ui_get_list_height(element_mesh_list) + spacing;
        
        element = create_button(col1_x, yy, "Import", col_width, element_height, fa_center, function(button) {
            var fn = get_open_filename_mesh();
            if (file_exists(fn)) {
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, undefined); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, undefined); break;
                    case ".vrax": import_vrax(fn); break;
                    case ".smf": import_smf(fn); break;
                    case ".qma": import_qma(fn); break;
                    case ".dae": import_dae(fn); break;
                }
            }
        }, t_p_mesh_editor);
        element.file_dropper_action = function(element, files) {
            var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".smf"]);
            for (var i = 0; i < array_length(filtered_list); i++) {
                var fn = filtered_list[i];
                switch (filename_ext(fn)) {
                    case ".obj": import_obj(fn, true); break;
                    case ".d3d": case ".gmmod": import_d3d(fn, true); break;
                    case ".smf": import_smf(fn);
                }
            }
        };
        element.tooltip = "Imports a 3D model. The texture coordinates will automatically be scaled on importing; to override this, press the Control key.";
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Delete", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
            if (data) {
                instance_activate_object(data);
                instance_destroy(data);
            }
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
            if (data) {
                internal_name_set(data, input.value);
            }
        }, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, 0, vy1, vx2, vy2, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        t_p_mesh_editor.mesh_name_internal = element;
        
        yy += t_p_mesh_editor.mesh_name_internal.height + spacing;
        
        var s = 10;
        
        var bounds_x = col2_x;
        var bounds_x_2 = bounds_x + col_width / 2;
        
        element = create_text(bounds_x, yy, "Bounds", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        element.color = c_blue;
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(bounds_x, yy, "xmin:", col_width / 2, element_height, function(input) {
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
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
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
            if (data) {
                dialog_create_mesh_collision_data(noone, data);
            }
        }, t_p_tile_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Advanced", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
            if (data) dialog_create_mesh_advanced(undefined, data);
        }, t_p_mesh_editor);
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "General Mesh Things", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
        element.color = c_blue;
        ds_list_add(t_p_mesh_editor.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Export Selected", col_width, element_height, fa_center, function(button) {
            var data = Game.meshes[| Stuff.map.selection_fill_mesh];
            if (data) {
                var fn = get_save_filename_mesh();
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
        
        element = create_button(col2_x, yy, "Export All", col_width, element_height, fa_center, function(button) {
            var fn = get_save_filename_mesh_qma("");
            if (string_length(fn) > 0) {
                export_qma(fn);
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
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_list(col1_x, yy, "Mesh Autotile type", "<no mesh autotiles types>", col_width, element_height, 8, function(list) {
            var selection = ui_list_selection(list);
            if (selection + 1) {
                Settings.selection.mesh_autotile_type = list.entries[| selection].GUID;
            } else {
                Settings.selection.mesh_autotile_type = NULL;
            }
        }, false, t_p_other_editor, Game.mesh_autotiles);
        element.entries_are = ListEntries.INSTANCES;
        ds_list_add(t_p_other_editor.contents, element);
        t_p_other_editor.el_mesh_autotile_type = element;
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_checkbox(col1_x, yy, "Click to Drag", col_width, element_height, null, false, t_p_other_editor);
        // if this is ever implemented properly, reactivate this
        element.interactive = false;
        t_p_other_editor.el_click_to_drag = element;
        ds_list_add(t_p_other_editor.contents, element);
        #endregion
        
        return id;
    }
}