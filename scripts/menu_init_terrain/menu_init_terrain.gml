function menu_init_terrain() {
    with (instance_create_depth(0, 0, 0, MenuMain)) {
        // top-level stuff
        var menu_file = create_menu("File", element_width, element_height, id);
        var menu_help = create_menu("Help", element_width, element_height, id);
        ds_list_add(contents, menu_file, menu_help);
        
        var m_separator = create_menu_element("----------", null, id);
        
        #region file stuff
        var mf_preferences = create_menu_element("Preferences", momu_preferences, menu_file);
        var mf_exit = create_menu_element("Exit (Alt+F4)", momu_exit, menu_file);
        ds_list_add(menu_file.contents,
            mf_preferences,
            mf_exit
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