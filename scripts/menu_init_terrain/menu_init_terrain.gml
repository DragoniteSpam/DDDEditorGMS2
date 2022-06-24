function menu_init_terrain() {
    with (instance_create_depth(0, 0, 0, MenuMain)) {
        // top-level stuff
        var menu_file = create_menu("File", element_width, element_height, id);
        var menu_help = create_menu("Help", element_width, element_height, id);
        ds_list_add(contents, menu_file, menu_help);
        
        var m_separator = create_menu_element("----------", null, id);
        
        #region file stuff
        ds_list_add(menu_file.contents,
            create_menu_element("New Terrain (Ctrl + N)", momu_terrain_new, menu_file),
            create_menu_element("Save Terrain (Ctrl + S)", momu_terrain_save, menu_file),
            create_menu_element("Open Terrain (Ctrl + O)", momu_terrain_load, menu_file),
            create_menu_element("Export Terrain (Ctrl + E)", momu_terrain_export, menu_file),
            create_menu_element("Export Heightmap (Ctrl + Shift + E)", momu_terrain_heightmap, menu_file),
            create_menu_element("Preferences", momu_preferences, menu_file),
            create_menu_element("Exit (Alt+F4)", momu_exit, menu_file),
        );
        #endregion
        
        #region help stuff
        ds_list_add(menu_help.contents,
            create_menu_element("Credits", momu_credits, menu_help)
        );
        #endregion
        
        instance_deactivate_object(id);
        
        return id;
    }
}