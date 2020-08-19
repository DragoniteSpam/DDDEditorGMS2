function control_duration_middle() {
    if (Controller.time_middle < 0) {
        return 0;
    }

    return (get_timer() - Controller.time_middle) / MILLION;


}
