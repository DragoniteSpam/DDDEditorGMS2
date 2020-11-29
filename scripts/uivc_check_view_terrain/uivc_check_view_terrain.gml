function uivc_check_view_terrain(checkbox) {
    Stuff.settings.view.terrain = checkbox.value;
    setting_set("View", "terrain", Stuff.settings.view.terrain);
}