function menu_init_mesh() {
    with (instance_create_depth(0, 0, 0, MenuMain)) {
        // top-level stuff
        var menu_file = create_menu("File", element_width, element_height, id);
        var menu_assets = create_menu("Assets", element_width, element_height, id);
        var menu_help = create_menu("Help", element_width, element_height, id);
        ds_list_add(contents, menu_file, menu_assets, menu_help);
        
        var m_separator = create_menu_element("----------", null, id);
        
        #region file stuff
        var mf_save_data = create_menu_element("Save (Ctrl+S)", momu_save_data, menu_file);
        var mf_settings_data = create_menu_element("Global Data Settings (Ctrl+G)", momu_settings_data_mesh, menu_file);
        var mf_preferences = create_menu_element("Preferences", momu_preferences, menu_file);
        var mf_exit = create_menu_element("Exit (Alt+F4)", momu_exit, menu_file);
        ds_list_add(menu_file.contents,
            mf_save_data,
            mf_settings_data,
            mf_preferences,
            mf_exit
        );
        #endregion
        
        #region data stuff
        var md_graphic_ts = create_menu_element("Textures", momu_graphics_manager, menu_assets);
        ds_list_add(menu_assets.contents,
            md_graphic_ts,
        );
        #endregion
        
        #region help stuff
        var mh_credits = create_menu_element("Credits", momu_credits, menu_help);
        ds_list_add(menu_help.contents,
            mh_credits
        );
        #endregion
        
        instance_deactivate_object(id);
        
        return id;
    }
}