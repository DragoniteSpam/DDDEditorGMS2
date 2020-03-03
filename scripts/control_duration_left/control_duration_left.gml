if (Controller.time_left < 0) {
    return;
}

return (get_timer() - Controller.time_left) / MILLION;