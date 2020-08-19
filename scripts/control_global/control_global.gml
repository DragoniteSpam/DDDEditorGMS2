function control_global() {
    if (!GLOBAL_CONTORLS_ENABLED) {
        return;
    }

    /*
     * General keyboard shortcuts
     */
    if (keyboard_check(vk_control)) {
        ui_activate(noone);
        // file
        if (keyboard_check_pressed(ord("S"))) {
            momu_save_data(noone);
        }
        // edit
        if (keyboard_check_pressed(ord("A"))) {
            momu_select_all(noone);
        }
        if (keyboard_check_pressed(ord("D"))) {
            momu_deselect(noone);
        }
        if (keyboard_check_pressed(ord("X"))) {
            momu_cut(noone);
        }
        if (keyboard_check_pressed(ord("C"))) {
            momu_copy(noone);
        }
        if (keyboard_check_pressed(ord("V"))) {
            momu_paste(noone);
        }
        if (keyboard_check_pressed(ord("Z"))) {
            momu_undo(noone);
        }
        if (keyboard_check_pressed(ord("Y"))) {
            momu_redo(noone);
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


}
