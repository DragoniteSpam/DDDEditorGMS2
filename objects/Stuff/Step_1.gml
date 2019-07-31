// delta time
dt = delta_time/MILLION;
// seconds elapsed since the game started
time = get_timer()/MILLION;
// seconds as an integer
time_int = time div 1;
// frames
frames++;

var status = ds_stuff_fetch_status();

if (status == WINDOW_CLOSE) {
    var top = ds_list_top(Camera.dialogs);
    if (top && (top.dialog_flags & (1 << DialogFlags.IS_QUIT))) {
        game_end();
    } else {
        var dg = dialog_create_yes_or_no(noone, "Do you want to close the program?", dmu_dialog_quit);
        dg.dialog_flags = dg.dialog_flags | (1 << DialogFlags.IS_QUIT);
    }
}

// if you want to do other things with the program window in c++ do them before you reset the status
ds_stuff_reset_status();