/// @param EditorModeMap

var mode = argument0;

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
    
    element = create_radio_array(col1_x, yy, "Selection mode", col_width, element_height, uivc_radio_selection_mode, Stuff.setting_selection_mode, t_general);
    create_radio_array_options(element, ["Single", "Rectangle", "Circle"]);
    ds_list_add(t_general.contents, element);
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    element = create_checkbox(col1_x, yy, "Additive Selection", col_width, element_height, uivc_check_selection_addition, Stuff.setting_selection_addition, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_radio_array(col1_x, yy, "Fill Type", col_width, element_height, uivc_radio_fill_type, Stuff.setting_selection_fill_type, t_general);
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
    
    element = create_bitfield(col1_x, yy, "Selection Mask:", col_width, element_height, ETypeFlags.ENTITY_ANY, t_general);
    create_bitfield_options_vertical(element, [
        create_bitfield_option_data(ETypeFlags.ENTITY_TILE, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Tile", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_MESH, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Mesh", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_PAWN, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Pawn", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_EFFECT, ui_render_bitfield_option_text_selection_mask, uivc_bitfield_selection_mask, "Effect", -1, 0, col_width / 2, s),
        create_bitfield_option_data(ETypeFlags.ENTITY_ANY, ui_render_bitfield_option_text_selection_mask_all, uivc_bitfield_selection_mask_all, "All", -1, 0, col_width / 2, s),
        create_bitfield_option_data(0, ui_render_bitfield_option_text_selection_mask_none, uivc_bitfield_selection_mask_none, "None", -1, 0, col_width / 2, s)
    ]);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_button(col2_x, yy, "View Master Texture", col_width, element_height, fa_center, uimu_view_master_texture, t_general);
    element.tooltip = "Preview the main texture page of the map. This is not particularly helpful currently and I may remove it at some point.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Wireframes", col_width, element_height, uivc_check_view_wireframe, Stuff.setting_view_wireframe, t_general);
    element.tooltip = "Whether or not you want to view the wireframes to go with visual data.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Grid and Markers", col_width, element_height, uivc_check_view_grids, Stuff.setting_view_grid, t_general);
    element.tooltip = "Whether or not you want to view the cell grid and grid axes.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Texture", col_width, element_height, uivc_check_view_texture, Stuff.setting_view_texture, t_general);
    element.tooltip = "Whether or not to texture the visuals (to use the tilesets, in common terms). If off, a flat orange texture will be used instead. Most of the time you want this on.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Entities", col_width, element_height, uivc_check_view_entities, Stuff.setting_view_entities, t_general);
    element.tooltip = "Whether or not entites should be visible. This is almost everything in the map, and turning it off is quite pointless.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Backfaces", col_width, element_height, uivc_check_view_backface, Stuff.setting_view_backface, t_general);
    element.tooltip = "Whether the backs of triangles should be visible. There is a very small performance cost to turning them on. Generally, this is not needed.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Zones", col_width, element_height, uivc_check_view_zones, Stuff.setting_view_zones, t_general);
    element.tooltip = "Map zones for things like camera and lighting controls. If you have a lot of them, it can become hard to see through them. Zones can only be blicked on when this is turned on.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Lighting", col_width, element_height, uivc_check_view_lighting, Stuff.setting_view_lighting, t_general);
    element.tooltip = "See how the scene looks with lighting. This also affects fog. You may wish to turn this off if you find yourself having a hard time seeing with the lights enabled.";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "View Gizmos", col_width, element_height, uivc_check_view_gizmos, Stuff.setting_view_gizmos, t_general);
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
    element.render = ui_render_text_stats_entities;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "     Static:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_static;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height;
    
    element = create_text(col2_x, yy, "     Solid:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "     Tiles:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_tiles;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height;
    
    element = create_text(col2_x, yy, "     Autotiles:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_tiles_auto;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height;
    
    element = create_text(col2_x, yy, "     Meshes:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_meshes;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height;
    
    element = create_text(col2_x, yy, "     Pawns:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_pawns;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height;
    
    element = create_text(col2_x, yy, "     Effects:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    element = create_text(stat_x, yy, "0", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_effects;
    ds_list_add(t_stats.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "Frozen terrain data:", col_width, element_height, fa_left, col_width, t_stats);
    ds_list_add(t_stats.contents, element);
    
    yy += spacing;
    
    element = create_text(col2_x, yy, "    - kb", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_frozen_size_kb;
    ds_list_add(t_stats.contents, element);
    
    yy += spacing;
    
    element = create_text(col2_x, yy, "    ( - bytes)", col_width, element_height, fa_left, col_width, t_stats);
    element.render = ui_render_text_stats_entities_frozen_size;
    ds_list_add(t_stats.contents, element);
    
    yy += spacing;
    
    #endregion
    
    #region tab: map
    
    yy = legal_y + spacing;
    
    element = create_list(col1_x, yy, "Maps: ", "no maps. (how?!)", col_width, element_height, 20, uivc_list_maps, false, t_maps, Stuff.all_maps);
    element.tooltip = "This is a list of all the maps currently in the game.";
    element.render = ui_render_list_all_maps;
    element.ondoubleclick = dmu_data_open_map;
    element.entries_are = ListEntries.INSTANCES;
    t_maps.el_map_list = element;
    ds_list_add(t_maps.contents, element);
    
    yy += ui_get_list_height(element) + spacing;
    
    element = create_button(col1_x, yy, "Add Map", col_width, element_height, fa_center, dmu_data_add_map, t_maps);
    element.tooltip = "Add a map. You can have up to " + string(0xffff) + " maps in the game. I seriously doubt anyone will need anywhere near that many.";
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col1_x, yy, "Delete Map", col_width, element_height, fa_center, dmu_data_remove_map, t_maps);
    element.tooltip = "Delete the currently selected map. Any existing references to it will no longer work. You should only use this if you're absolutely sure; generally speaking, maps not loaded into memory will not affect the game very much.";
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col1_x, yy, "Open Map", col_width, element_height, fa_center, dmu_data_open_map, t_maps);
    element.tooltip = "Open the currently selected map for editing. Double-clicking it in the list will have the same effect.";
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col1_x, yy, "Make Starting Map", col_width, element_height, fa_center, dmu_data_starting_map, t_maps);
    element.tooltip = "Designate the currently selected map as the first one entered when the game starts. What this means to your game is up to you.";
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col1_x, yy, "Import Tiled", col_width, element_height, fa_center, dmu_data_import_map, t_maps);
    element.tooltip = "Import a Tiled map editor file (json version). Tile data will be imported as frozen terrain; the editor will attempt to convert other data to Entities.";
    ds_list_add(t_maps.contents, element);
    
    yy = legal_y + spacing;
    
    element = create_text(col2_x, yy, "Name:", col_width, element_height, fa_left, col_width, t_maps);
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "", col_width, element_height, uivc_settings_map_name, "", "Name", validate_string, 0, 0, VISIBLE_NAME_LENGTH, 0, vy1, vx2, vy2, t_maps);
    element.tooltip = "The name of the map, as it appears to the player.";
    ds_list_add(t_maps.contents, element);
    t_maps.el_name = element;
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "Internal name:", col_width, element_height, fa_left, col_width, t_maps);
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "", col_width, element_height, uivc_settings_map_internal, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 0, INTERNAL_NAME_LENGTH, 0, vy1, vx2, vy2, t_maps);
    element.tooltip = "The internal name of the map, as it appears to the developer. Standard restrictions on internal names apply.";
    ds_list_add(t_maps.contents, element);
    t_maps.el_internal_name = element;
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "Summary:", col_width, element_height, fa_left, col_width, t_maps);
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "", col_width, element_height, uivc_settings_map_summary, "", "Words", validate_string, 0, 0, 400, 0, vy1, vx2, vy2, t_maps);
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
    
    element = create_checkbox(col2_x, yy, "Is 3D?", col_width, element_height, uivc_settings_map_3d, false, t_maps);
    element.tooltip = "This is my favorite checkbox in the whole entire editor.";
    ds_list_add(t_maps.contents, element);
    t_maps.el_3d = element;
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy,  "Generic Data", col_width, element_height, fa_center, omu_map_generic_data, t_maps);
    element.tooltip = "You can attach generic data properties to each map, to give the game extra information about it. How you use this is up to you. These properties aren't guaranteed to exist, so the game should always check first before trying to access them.";
    ds_list_add(t_maps.contents, element);
    t_maps.el_other = element;
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy,  "More Settings", col_width, element_height, fa_center, dialog_create_settings_map, t_maps);
    element.tooltip = "I put the more important settings out here on the main UI, but there are plenty of other things you may need to specify about maps.";
    ds_list_add(t_maps.contents, element);
    t_maps.el_other = element;
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Freeze Selected Objects", col_width, element_height, fa_center, null, t_maps);
    element.tooltip = "Selected objects will be converted to a frozen vertex buffer and will no longer be editable. This means they will be significantly faster to process and render, but they will otherwise be effectively permanently removed. Use with caution.";
    element.interactive = false;
    ds_list_add(t_maps.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Clear Frozen Data", col_width, element_height, fa_center, null, t_maps);
    element.tooltip = "Clear the frozen vertex buffer data. There is no way to get it back. Use with caution.";
    element.interactive = false;
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
    
    element_entity_option_animate_idle = create_checkbox(col1_x, yy, "Animate Idle", col_width, element_height, uivc_check_entity_option_animate_idle, false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_animate_idle);
    element_entity_option_animate_idle.interactive = false;
    
    yy += element_entity_option_animate_idle.height;
    
    element_entity_option_animate_movement = create_checkbox(col1_x, yy, "Animate Movement", col_width, element_height, uivc_check_entity_option_animate_movement, false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_animate_movement);
    element_entity_option_animate_movement.interactive = false;
    
    yy += element_entity_option_animate_movement.height;
    
    element_entity_option_direction_fix = create_checkbox(col1_x, yy, "Direction Fix", col_width, element_height, uivc_check_entity_option_direction_fix, false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_direction_fix);
    element_entity_option_direction_fix.interactive = false;
    
    yy += element_entity_option_direction_fix.height;
    
    element_entity_option_reset_position = create_checkbox(col1_x, yy, "Reset Position", col_width, element_height, uivc_check_entity_option_reset_position, false, t_p_entity);
    ds_list_add(t_p_entity.contents, element_entity_option_reset_position);
    element_entity_option_reset_position.interactive = false;
    
    yy += element_entity_option_reset_position.height + spacing;
    
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
    
    element_entity_mesh_list = create_list(col1_x, yy, "Mesh", "<no meshes>", col_width, element_height, 16, uivc_entity_mesh_list, false, t_p_mesh, Stuff.all_meshes);
    element_entity_mesh_list.allow_deselect = false;
    element_entity_mesh_list.entries_are = ListEntries.INSTANCES;
    ds_list_add(t_p_mesh.contents, element_entity_mesh_list);
    element_entity_mesh_list.interactive = false;
    
    yy += ui_get_list_height(element_entity_mesh_list) + spacing;
    
    element_entity_mesh_submesh = create_list(col1_x, yy, "Submesh", "<choose a single mesh>", col_width, element_height, 10, uivc_entity_mesh_submesh, false, t_p_mesh, noone);
    element_entity_mesh_submesh.allow_deselect = false;
    element_entity_mesh_submesh.entries_are = ListEntries.INSTANCES;
    ds_list_add(t_p_mesh.contents, element_entity_mesh_submesh);
    element_entity_mesh_submesh.interactive = false;
    
    yy += ui_get_list_height(element_entity_mesh_submesh) + spacing;
    
    yy = legal_y + spacing;
    
    element_entity_mesh_autotile_data = create_button(col2_x, yy, "Mesh Autotile Data", col_width, element_height, fa_center, uivc_entity_mesh_autotile_properties, t_p_mesh);
    ds_list_add(t_p_mesh.contents, element_entity_mesh_autotile_data);
    element_entity_mesh_autotile_data.interactive = false;
    
    yy += element_entity_mesh_autotile_data.height + spacing;
    
    element_entity_mesh_animated = create_checkbox(col2_x, yy, "Animated", col_width, element_height, uivc_entity_mesh_animated, false, t_p_mesh);
    ds_list_add(t_p_mesh.contents, element_entity_mesh_animated);
    element_entity_mesh_animated.interactive = false;
    
    yy += element_entity_mesh_animated.height + spacing;
    
    element_entity_mesh_animation_speed = create_input(col2_x, yy, "Anim. Spd:", col_width, element_height, uivc_entity_mesh_animation_speed, 1, "float", validate_double, -10, 10, 5, vx1, vy1, vx2, vy2, t_p_mesh);
    element_entity_mesh_animation_speed.tooltip = "The number of complete animation cycles per second (animations will not be previewed in the editor)";
    ds_list_add(t_p_mesh.contents, element_entity_mesh_animation_speed);
    element_entity_mesh_animation_speed.interactive = false;
    
    yy += element_entity_mesh_animation_speed.height + spacing;
    
    element_entity_mesh_animation_end_action = create_radio_array(col2_x, yy, "End Action:", col_width, element_height, uivc_entity_mesh_animation_end_action, 0, t_p_mesh);
    create_radio_array_options(element_entity_mesh_animation_end_action, ["Stop", "Loop", "Reverse"]);
    element_entity_mesh_animation_end_action.tooltip = "The number of complete animation cycles per second";
    ds_list_add(t_p_mesh.contents, element_entity_mesh_animation_end_action);
    element_entity_mesh_animation_end_action.interactive = false;
    
    yy += ui_get_radio_array_height(element_entity_mesh_animation_end_action) + spacing;
    
    #endregion
    
    #region tab: entity: pawn
    
    yy = legal_y + spacing;
    
    element_entity_pawn_frame = create_input(col1_x, yy, "Frame:", col_width, element_height, uivc_entity_pawn_editor_frame, 0, "0...3", validate_int, 0, 3, 1, vx1, vy1, vx2, vy2, t_p_pawn);
    ds_list_add(t_p_pawn.contents, element_entity_pawn_frame);
    
    yy += element_entity_pawn_frame.height + spacing;
    
    element_entity_pawn_direction = create_radio_array(col1_x, yy, "Direction", col_width, element_height, uivc_entity_pawn_direction, 0, t_p_pawn);
    create_radio_array_options(element_entity_pawn_direction, ["Down", "Left", "Right", "Up"]);
    ds_list_add(t_p_pawn.contents, element_entity_pawn_direction);
    
    yy += ui_get_radio_array_height(element_entity_pawn_direction) + spacing;
    
    element_entity_pawn_animating = create_checkbox(col1_x, yy, "Animating", col_width, element_height, uivc_entity_pawn_animating, false, t_p_pawn);
    ds_list_add(t_p_pawn.contents, element_entity_pawn_animating);
    
    yy += element_entity_pawn_animating.height + spacing;
    
    element_entity_pawn_sprite = create_list(col1_x, yy, "Overworld Sprite", "<no overworlds>", col_width, element_height, 12, uivc_entity_pawn_set_sprite, false, t_p_pawn, Stuff.all_graphic_overworlds);
    element_entity_pawn_sprite.entries_are = ListEntries.INSTANCES;
    ds_list_add(t_p_pawn.contents, element_entity_pawn_sprite);
    
    yy += ui_get_list_height(element_entity_pawn_sprite) + spacing;
    #endregion
    
    #region tab: entity: effect
    
    yy = legal_y + spacing;
    
    element = create_text(col1_x, yy, "Effect Components", col_width, element_height, fa_left, col_width, t_p_effect);
    ds_list_add(t_p_effect.contents, element);
    
    yy += element.height + spacing;
    
    element_effect_com_light = create_button(col1_x, yy, "Light", col_width, element_height, fa_center, uivc_entity_effect_com_lighting, t_p_effect);
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
    
    element = create_button(col1_x, yy, "Change Tileset", 128, element_height, fa_center, omu_manager_tileset, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    element = create_button(col1_x + (spacing + 128), yy, "Import Main", 128, element_height, fa_center, dmu_dialog_load_tileset_main, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    element = create_button(col1_x + (spacing + 128) * 2, yy, "Export Main", 128, element_height, fa_center, dmu_dialog_save_tileset_main, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_tile_selector(col1_x, yy, legal_width - spacing * 2, (legal_width div Stuff.tile_width) * Stuff.tile_width - element_height, uivc_select_tile, uivc_select_tile_backwards, t_p_tile_editor);
    element.tile_x = mode.selection_fill_tile_x;
    element.tile_y = mode.selection_fill_tile_y;
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy += element.height + spacing;
    var yy_aftergrid = yy;
    
    element = create_text(col1_x, yy, "Tile Properties: x, y", col_width, element_height, fa_left, col_width, t_p_tile_editor);
    element.render = ui_render_text_tile_label;
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col1_x, yy, "Tile Flags", col_width, element_height, fa_center, omu_tile_flags, t_p_tile_editor);
    ds_list_add(t_p_tile_editor.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: general: meshes
    
    yy = legal_y + spacing;
    
    // this is an object variable
    element_mesh_list = create_list(col1_x, yy, "Available meshes: ", "<no meshes>", col_width, element_height, 25, uivc_list_selection_mesh, false, t_p_mesh_editor);
    element_mesh_list.entries_are = ListEntries.SCRIPT;
    element_mesh_list.colorize = true;
    element_mesh_list.render = ui_render_list_all_meshes;
    element_mesh_list.render_colors = ui_list_color_meshes;
    element_mesh_list.ondoubleclick = omu_mesh_preview;
    element_mesh_list.evaluate_text = ui_list_text_meshes;
    ds_list_add(t_p_mesh_editor.contents, element_mesh_list);
    
    yy += ui_get_list_height(element_mesh_list) + spacing;
    
    element = create_button(col1_x, yy, "Import", col_width, element_height, fa_center, omu_mesh_import, t_p_mesh_editor);
    element.tooltip = "Imports a 3D model. The texture coordinates will automatically be scaled on importing; to override this, press the Control key.";
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col1_x, yy, "Delete", col_width, element_height, fa_center, omu_mesh_remove, t_p_mesh_editor);
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
    
    element = create_input(col2_x, yy, "", col_width, element_height, uivc_input_mesh_name, "", "Name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, 0, vy1, vx2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    t_p_mesh_editor.mesh_name = element;
    
    yy += t_p_mesh_editor.mesh_name.height + spacing;
    
    element = create_text(col2_x, yy, "Internal Name:", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "", col_width, element_height, uivc_input_mesh_internal_name, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, 0, vy1, vx2, vy2, t_p_mesh_editor);
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
    
    element = create_input(bounds_x, yy, "xmin:", col_width / 2, element_height, uivc_mesh_set_xmin, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    t_p_mesh_editor.xmin = element;
    
    element = create_input(bounds_x_2, yy, "xmax:", col_width / 2, element_height, uivc_mesh_set_xmax, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    t_p_mesh_editor.xmax = element;
    
    yy += element.height + spacing;
    
    element = create_input(bounds_x, yy, "ymin:", col_width / 2, element_height, uivc_mesh_set_ymin, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    t_p_mesh_editor.ymin = element;
    
    element = create_input(bounds_x_2, yy, "ymax:", col_width / 2, element_height, uivc_mesh_set_ymax, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    t_p_mesh_editor.ymax = element;
    
    yy += element.height + spacing;
    
    element = create_input(bounds_x, yy, "zmin:", col_width / 2, element_height, uivc_mesh_set_zmin, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    t_p_mesh_editor.zmin = element;
    
    element = create_input(bounds_x_2, yy, "zmax:", col_width / 2, element_height, uivc_mesh_set_zmax, 0, "integer", validate_int, -128, 127, 4, 64, vy1, col_width / 2, vy2, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    t_p_mesh_editor.zmax = element;
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Collision Data", col_width, element_height, fa_center, omu_mesh_collision_data, t_p_tile_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Mesh Flags", col_width, element_height, fa_center, omu_mesh_flags, t_p_tile_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Preview", col_width, element_height, fa_center, omu_mesh_preview, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Advanced", col_width, element_height, fa_center, omu_mesh_advanced, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "General Mesh Things", col_width, element_height, fa_left, col_width, t_p_mesh_editor);
    element.color = c_blue;
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Export Selected", col_width, element_height, fa_center, omu_mesh_export_selected, t_p_mesh_editor);
    ds_list_add(t_p_mesh_editor.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Export All", col_width, element_height, fa_center, omu_mesh_export_archive, t_p_mesh_editor);
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
    
    element = create_list(col1_x, yy, "Zone type", "<no zone types>", col_width, element_height, 8, uivc_zone_type, false, t_p_other_editor);
    element.colorize = false;
    element.allow_deselect = false;
    ui_list_select(element, Stuff.setting_selection_zone_type);
    create_list_entries(element, ["Camera Zone"], ["Light Zone"]);
    ds_list_add(t_p_other_editor.contents, element);
    t_p_other_editor.el_zone_type = element;
    
    yy += ui_get_list_height(element) + spacing;
    
    element = create_checkbox(col1_x, yy, "Click to Drag", col_width, element_height, null, false, t_p_other_editor);
    // if this is ever implemented properly, reactivate this
    element.interactive = false;
    t_p_other_editor.el_click_to_drag = element;
    ds_list_add(t_p_other_editor.contents, element);
    #endregion
    
    return id;
}