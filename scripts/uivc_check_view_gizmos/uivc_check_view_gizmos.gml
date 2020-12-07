function uivc_check_view_gizmos(checkbox) {
    Settings.view.gizmos = checkbox.value;
    setting_set("View", "gizmos", Settings.view.gizmos);
}