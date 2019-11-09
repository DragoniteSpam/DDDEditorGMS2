// timing things
dt = delta_time / MILLION;
time = get_timer() / MILLION;
time_int = time div 1;
frames++;

// mouse things
MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();

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
    view_set_visible(view_3d_preview, false);
    var top = ds_list_top(Stuff.dialogs);
    if (top && (top.dialog_flags & (1 << DialogFlags.IS_QUIT))) {
        game_end();
    } else {
        var dg = dialog_create_yes_or_no(noone, "Do you want to close the program?", dmu_dialog_quit);
        dg.dialog_flags = dg.dialog_flags | (1 << DialogFlags.IS_QUIT);
    }
}

// if you want to do other things with the program window in c++ do them before you reset the status
ds_stuff_reset_status();