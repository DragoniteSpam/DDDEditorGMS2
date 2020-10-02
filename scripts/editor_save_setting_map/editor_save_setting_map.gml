function editor_save_setting_map(mode) {
    setting_set("Map", "x", mode.x);
    setting_set("Map", "y", mode.y);
    setting_set("Map", "z", mode.z);
    setting_set("Map", "xto", mode.xto);
    setting_set("Map", "yto", mode.yto);
    setting_set("Map", "zto", mode.zto);
    setting_set("Map", "fov", mode.fov);
}