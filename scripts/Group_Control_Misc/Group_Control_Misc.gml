function control_global() {
    if (!GLOBAL_CONTORLS_ENABLED) return;
    
    if (keyboard_check(vk_control)) {
        ui_activate(noone);
        // file
        if (keyboard_check_pressed(ord("S"))) {
            momu_save_data();
        }
        if (keyboard_check_pressed(ord("G"))) {
            momu_settings_data();
        }
        if (keyboard_check_pressed(ord("E"))) {
            momu_export_data();
        }
        // edit
        if (keyboard_check_pressed(ord("A"))) {
            momu_select_all();
        }
        if (keyboard_check_pressed(ord("D"))) {
            momu_deselect();
        }
        if (keyboard_check_pressed(ord("X"))) {
            momu_cut();
        }
        if (keyboard_check_pressed(ord("C"))) {
            momu_copy();
        }
        if (keyboard_check_pressed(ord("V"))) {
            momu_paste();
        }
        if (keyboard_check_pressed(ord("Z"))) {
            momu_undo();
        }
        if (keyboard_check_pressed(ord("Y"))) {
            momu_redo();
        }
    }
    
    if (keyboard_check_pressed(vk_f5)) {
        editor_mode_meshes();
    }
    if (keyboard_check_pressed(vk_f6)) {
        editor_mode_3d();
    }
    if (keyboard_check_pressed(vk_f7)) {
        editor_mode_event();
    }
    if (keyboard_check_pressed(vk_f8)) {
        editor_mode_data();
    }
    if (keyboard_check_pressed(vk_f9)) {
        editor_mode_animation();
    }
    if (keyboard_check_pressed(vk_f10)) {
        editor_mode_heightmap();
    }
    if (keyboard_check_pressed(vk_f11)) {
        editor_mode_text();
    }
}