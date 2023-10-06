function menu_init_main() {
    with (instance_create_depth(0, 0, 0, MenuMain)) {
        // top-level stuff
        var menu_file = create_menu("File", element_width, element_height, id);
        var menu_edit = create_menu("Edit", element_width, element_height, id);
        var menu_data = create_menu("Data", element_width, element_height, id);
        var menu_beta = create_menu("Beta", element_width, element_height, id);
        var menu_help = create_menu("Help", element_width, element_height, id);
        ds_list_add(contents, menu_file, menu_edit, menu_data, menu_beta, menu_help);
        
        var m_separator = create_menu_element("----------", null, id);
        
        #region file stuff
        var mf_save_data = create_menu_element("Save (Ctrl+S)", momu_save_data, menu_file);
        var mf_export_data = create_menu_element("Export (Ctrl+E)", momu_export_data, menu_file);
        var mf_settings_data = create_menu_element("Global Data Settings (Ctrl+G)", momu_settings_data, menu_file);
        var mf_preferences = create_menu_element("Preferences", momu_preferences, menu_file);
        var mf_exit = create_menu_element("Exit (Alt+F4)", momu_exit, menu_file);
        mf_save_data.interactive = MENU_EDITOR_ENABLED;
        mf_settings_data.interactive = MENU_EDITOR_ENABLED;
        ds_list_add(menu_file.contents,
            mf_save_data,
            mf_export_data,
            mf_settings_data,
            mf_preferences,
            mf_exit
        );
        #endregion
        
        #region edit stuff
        var me_undo = create_menu_element("Undo (Ctrl+Z)", momu_undo, menu_edit);
        var me_redo = create_menu_element("Redo (Ctrl+Y)", momu_redo, menu_edit);
        var me_cut = create_menu_element("Cut (Ctrl+X)", momu_cut, menu_edit);
        var me_copy = create_menu_element("Copy (Ctrl+C)", momu_copy, menu_edit);
        var me_paste = create_menu_element("Paste (Ctrl+V)", momu_paste, menu_edit);
        var me_select_all =create_menu_element("Select All (Ctrl+A)", momu_select_all, menu_edit);
        var me_deselect = create_menu_element("Deselect (Ctrl+D)", momu_deselect, menu_edit);
        me_undo.interactive = MENU_EDITOR_ENABLED;
        me_redo.interactive = MENU_EDITOR_ENABLED;
        me_cut.interactive = MENU_EDITOR_ENABLED;
        me_copy.interactive = MENU_EDITOR_ENABLED;
        me_paste.interactive = MENU_EDITOR_ENABLED;
        me_select_all.interactive = MENU_EDITOR_ENABLED;
        me_deselect.interactive = MENU_EDITOR_ENABLED;
        
        ds_list_add(menu_edit.contents,
            me_undo,
            me_redo,
            //
            m_separator,
            me_cut,
            me_copy,
            me_paste,
            //
            m_separator,
            me_select_all,
            me_deselect
        );
        #endregion
        
        #region data stuff
        var md_graphics = create_menu_element("Graphics", momu_graphics_manager, menu_data);
        var md_audio = create_menu_element("Audio", momu_audio_manager, menu_data);
        var md_mesh_at = create_menu_element("Mesh Autotiles", momu_graphic_mesh_autotiles, menu_data);
        md_audio.interactive = MENU_EDITOR_ENABLED;
        md_mesh_at.interactive = MENU_EDITOR_ENABLED;
        var md_data_types = create_menu_element("Define Data Types", momu_data_types, menu_data);
        var md_reload = create_menu_element("Reload Assets...", momu_expand, menu_data, true);
            var md_reload_image = create_menu_element("Images", momu_reload_images, md_reload);
            var md_reload_mesh = create_menu_element("Meshes", momu_reload_meshes, md_reload);
            var md_reload_audio = create_menu_element("Audio", momu_reload_audio, md_reload);
            ds_list_add(md_reload.contents,
                md_reload_image,
                md_reload_mesh,
                md_reload_audio,
            );
        var md_meshes = create_menu_element("Mesh Editor (F5)", momu_meshes, menu_data);
        var md_3d = create_menu_element("Map Editor (F6)", momu_editor_3d, menu_data);
        var md_events = create_menu_element("Event Editor (F7)", momu_editor_event, menu_data);
        var md_data = create_menu_element("Game Data Editor (F8)", momu_editor_data, menu_data);
        var md_animation = create_menu_element("Animation Editor (F9)", momu_editor_animation, menu_data);
        var md_heightmap = create_menu_element("Terrain Editor (F10)", momu_editor_heightmap, menu_help);
        var md_text = create_menu_element("Language Text (F11)", momu_editor_text, menu_help);
        var md_voxelish = create_menu_element("Voxelish Editor (F12)", momu_editor_voxelish, menu_help);
        md_data_types.interactive = MENU_EDITOR_ENABLED;
        md_meshes.interactive = MENU_EDITOR_ENABLED;
        md_3d.interactive = MENU_EDITOR_ENABLED;
        md_events.interactive = MENU_EDITOR_ENABLED;
        md_data.interactive = MENU_EDITOR_ENABLED;
        md_animation.interactive = MENU_EDITOR_ENABLED;
        md_heightmap.interactive = MENU_EDITOR_ENABLED;
        md_text.interactive = MENU_EDITOR_ENABLED;
        md_voxelish.interactive = MENU_EDITOR_ENABLED;
        ds_list_add(menu_data.contents,
            md_graphics,
            md_audio,
            md_mesh_at,
            md_data_types,
            md_reload,
            //
            m_separator,
            md_meshes,
            md_3d,
            md_events,
            md_data,
            md_animation,
            md_heightmap,
            md_text,
            md_voxelish,
            //
            //m_separator,
            // uncomment this if you add other things
        );
        #endregion
        
        #region beta stuff
        var mb_no_beta = create_menu_element("(No beta features, currently)", null, menu_help);
        //
        var md_beta_spart = create_menu_element("Spart demo", momu_editor_spart, menu_help);
        md_beta_spart.interactive = MENU_EDITOR_ENABLED;
        ds_list_add(menu_beta.contents,
            md_beta_spart,
        );
        #endregion
        
        #region help stuff
        var mh_credits = create_menu_element("Credits", momu_credits, menu_help);
        ds_list_add(menu_help.contents,
            mh_credits
        );
        #endregion
        
        #region right-click stuff
        // this is an instance variable and not a local one
        menu_right_click = create_menu("right-click", element_width, element_height, id, true);
        var mrc_player = create_menu_element("Set Player Start", momu_expand, menu_right_click, true);
            var mrc_player_down = create_menu_element("Facing Down", momu_set_starting_position_down, mrc_player);
            var mrc_player_left = create_menu_element("Facing Left", momu_set_starting_position_left, mrc_player);
            var mrc_player_right = create_menu_element("Facing Right", momu_set_starting_position_right, mrc_player);
            var mrc_player_up = create_menu_element("Facing Up", momu_set_starting_position_up, mrc_player);
            ds_list_add(mrc_player.contents,
                mrc_player_down,
                mrc_player_left,
                mrc_player_right,
                mrc_player_up
            );
        var mrc_fill = create_menu_element("Fill", momu_expand, menu_right_click, true);
            var mrc_fill_tile = create_menu_element("Tile", null, mrc_fill);
            var mrc_fill_autotile = create_menu_element("Autotile", null, mrc_fill);
            var mrc_fill_mesh = create_menu_element("Mesh", null, mrc_fill);
            var mrc_fill_pawn = create_menu_element("Pawn", null, mrc_fill);
            var mrc_fill_effect = create_menu_element("Effect", null, mrc_fill);
            var mrc_fill_terrain = create_menu_element("Mesh Autotile", null, mrc_fill);
            ds_list_add(mrc_fill.contents,
                mrc_fill_tile,
                mrc_fill_autotile,
                mrc_fill_mesh,
                mrc_fill_pawn,
                mrc_fill_effect,
                mrc_fill_terrain
            );
        var mrc_delete = create_menu_element("Delete", null, menu_right_click);
        var mrc_cut = create_menu_element("Cut", momu_cut, menu_right_click);
        var mrc_copy = create_menu_element("Copy", momu_copy, menu_right_click);
        var mrc_paste = create_menu_element("Paste", momu_paste, menu_right_click);
        var mrc_prefab = create_menu_element("Save as Prefrab", null, menu_right_click);
        ds_list_add(menu_right_click.contents,
            mrc_player,
            //
            m_separator,
            mrc_fill,
            mrc_delete,
            //
            m_separator,
            mrc_cut,
            mrc_copy,
            mrc_paste,
            //
            m_separator,
            mrc_prefab
        );
        #endregion
        
        instance_deactivate_object(id);
        
        return id;
    }
}