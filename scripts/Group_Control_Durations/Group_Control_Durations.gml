function control_duration_left() {
    if (Controller.time_left < 0) return 0;
    return (get_timer() - Controller.time_left) / MILLION;
}

function control_duration_middle() {
    if (Controller.time_middle < 0) return 0;
    return (get_timer() - Controller.time_middle) / MILLION;
}

function control_duration_right() {
    if (Controller.time_right < 0) return 0;
    return (get_timer() - Controller.time_right) / MILLION;
}