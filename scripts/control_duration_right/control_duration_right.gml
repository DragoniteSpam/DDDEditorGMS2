function control_duration_right() {
	if (Controller.time_right < 0) {
	    return 0;
	}

	return (get_timer() - Controller.time_right) / MILLION;


}
