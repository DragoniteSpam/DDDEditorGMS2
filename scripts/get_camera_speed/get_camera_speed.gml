/// @param z
function get_camera_speed(argument0) {

    var factor = argument0;
    var base_speed = 256;
    var accelerate_time = 6;

    return max(1, (base_speed * (logn(32, max(factor, 1)) + 1)) * Stuff.dt * min((Controller.time_wasd_seconds + 1) / accelerate_time * Stuff.setting_camera_fly_rate, 10));


}
