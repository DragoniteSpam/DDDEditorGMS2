// timing things
dt = delta_time / MILLION;
time = get_timer() / MILLION;
time_int = time div 1;
frames++;

// keep the overlay view updated
var ww = window_get_width();
var hh = window_get_height();
var camera_overlay = view_get_camera(view_overlay);
camera_set_view_pos(camera_overlay, 0, 0);
camera_set_view_size(camera_overlay, ww, hh);
view_set_xport(view_overlay, 0);
view_set_yport(view_overlay, 0);
view_set_wport(view_overlay, ww);
view_set_hport(view_overlay, hh);

var status = ds_stuff_fetch_status();

if (status == WINDOW_CLOSE) {
    var top = EmuOverlay.GetTop();
    if (top && (top.flags & DialogFlags.IS_QUIT)) {
        is_quitting = true;
        game_end();
    } else {
        momu_exit();
    }
}

// if you want to do other things with the program window in c++ do them before you reset the status
ds_stuff_reset_status();