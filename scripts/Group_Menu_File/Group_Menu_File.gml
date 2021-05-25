function momu_exit() {
    dialog_create_yes_or_no(noone, "Do you want to close the program?", function(button) {
        game_end();
    }).flags |= DialogFlags.IS_QUIT;
}

function momu_preferences() {
    menu_activate(noone);
    dialog_create_preferences();
}

function momu_save_data() {
    menu_activate(noone);
    Stuff.schedule_save = true;
}

function momu_settings_data() {
    menu_activate(noone);
    dialog_create_settings_data(noone);
}