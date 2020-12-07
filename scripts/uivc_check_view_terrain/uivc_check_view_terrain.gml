function uivc_check_view_terrain(checkbox) {
    Settings.view.terrain = checkbox.value;
    setting_set("View", "terrain", Settings.view.terrain);
}