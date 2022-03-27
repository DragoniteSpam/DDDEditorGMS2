// timing things
dt = delta_time / MILLION;
time = get_timer() / MILLION;
time_int = time div 1;
frames++;

var status = drago_window_fetch_status();

if (status == WINDOW_CLOSE) {
    var top = EmuOverlay.GetTop();
    if (top && (top.flags & DialogFlags.IS_QUIT)) {
        self.is_quitting = true;
        game_end();
    } else {
        momu_exit();
    }
}

// if you want to do other things with the program window in c++ do them before you reset the status
drago_window_reset_status();