function get_camera_speed(z) {
    var base_speed = 256;
    var accelerate_time = 6;
    return max(1, (base_speed * (logn(32, max(z, 1)) + 1)) * Stuff.dt * min((Controller.time_wasd_seconds + 1) / accelerate_time * Settings.config.camera_fly_rate, 10));
}