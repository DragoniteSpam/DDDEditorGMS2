function momu_exit() {
    emu_dialog_confirm(undefined, "Do you want to close the program?", function() {
        game_end();
    }).flags |= DialogFlags.IS_QUIT;
}

function momu_preferences() {
    menu_activate(noone);
    dialog_create_preferences();
}

function momu_save_data() {
    menu_activate(noone);
    project_save();
}

function momu_export_data() {
    menu_activate(noone);
    project_export();
}

function momu_settings_data() {
    menu_activate(noone);
    dialog_create_settings_data(noone);
}