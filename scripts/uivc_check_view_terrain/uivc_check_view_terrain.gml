function uivc_check_view_terrain(checkbox) {
    Stuff.setting_view_terrain = checkbox.value;
    setting_set("View", "terrain", Stuff.setting_view_terrain);
}