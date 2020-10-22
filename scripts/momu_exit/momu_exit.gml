function momu_exit(menu) {
    var dg = dialog_create_yes_or_no(noone, "Do you want to close the program?", function(button) {
        game_end();
    });
    dg.dialog_flags |= DialogFlags.IS_QUIT;
}