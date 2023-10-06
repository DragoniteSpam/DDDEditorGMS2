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
        Stuff.mesh.SetMode();
    }
    if (keyboard_check_pressed(vk_f6)) {
        Stuff.map.SetMode();
    }
    if (keyboard_check_pressed(vk_f7)) {
        Stuff.event.SetMode();
    }
    if (keyboard_check_pressed(vk_f8)) {
        Stuff.data.SetMode();
    }
    if (keyboard_check_pressed(vk_f9)) {
        Stuff.animation.SetMode();
    }
    if (keyboard_check_pressed(vk_f10)) {
        Stuff.terrain.SetMode();
    }
    if (keyboard_check_pressed(vk_f11)) {
        Stuff.text.SetMode();
    }
    if (keyboard_check_pressed(vk_f12)) {
        Stuff.voxelish.SetMode();
    }
}