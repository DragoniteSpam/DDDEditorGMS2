function uivc_check_view_gizmos(checkbox) {
    Stuff.settings.view.gizmos = checkbox.value;
    setting_set("View", "gizmos", Stuff.settings.view.gizmos);
}