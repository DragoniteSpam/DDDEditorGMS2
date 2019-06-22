if (Controller.time_left < 0) {
    return 0;
}

return (get_timer() - Controller.time_left) / MILLION;