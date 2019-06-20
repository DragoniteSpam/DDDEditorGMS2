/*
 * General keyboard shortcuts
 */
if (keyboard_check(vk_control)) {
    /*
     * file
     */
    if (keyboard_check_pressed(ord("N"))) {
        momu_new(noone);
    }
    if (keyboard_check_pressed(ord("S"))) {
        if (keyboard_check(vk_shift)) {
            momu_save_data(noone);
        } else if (keyboard_check(vk_alt)) {
            momu_save_assets(noone);
        } else {
            momu_save_map(noone);
        }
    }
    if (keyboard_check_pressed(ord("O"))) {
        momu_open(noone);
    }
    /*
     * edit
     */
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

if (keyboard_check_pressed(vk_f6)) {
    momu_editor_3d(noone);
}
if (keyboard_check_pressed(vk_f7)) {
    momu_editor_event(noone);
}
if (keyboard_check_pressed(vk_f8)) {
    momu_editor_data(noone);
}