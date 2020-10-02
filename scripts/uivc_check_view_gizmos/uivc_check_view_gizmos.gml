function uivc_check_view_gizmos(checkbox) {
    Stuff.setting_view_gizmos = checkbox.value;
    setting_set("View", "gizmos", Stuff.setting_view_gizmos);
}