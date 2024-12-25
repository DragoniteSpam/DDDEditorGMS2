function momu_exit() {
    var dialog = emu_dialog_confirm(undefined, "Do you want to close the program?", game_end);
    dialog.contents_interactive = true;
    dialog.flags |= DialogFlags.IS_QUIT;
}

function momu_errors() {
    _emu_active_element(undefined);
    menu_close_all();
    Stuff.ShowErrorMessages();
}

function momu_preferences() {
    _emu_active_element(undefined);
    menu_close_all();
    dialog_create_preferences();
}

function momu_save_data() {
    _emu_active_element(undefined);
    menu_close_all();
    project_save();
}

function momu_export_data() {
    _emu_active_element(undefined);
    menu_close_all();
    project_export();
}

function momu_settings_data() {
    _emu_active_element(undefined);
    menu_close_all();
    dialog_create_settings_data();
}

function momu_settings_data_mesh() {
    _emu_active_element(undefined);
    menu_close_all();
    dialog_create_settings_data_mesh();
}