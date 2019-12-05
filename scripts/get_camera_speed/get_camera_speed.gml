/// @param z

var factor = argument0;
var base_speed = 256;
var accelerate_time = 6;

return max(1, (base_speed * (log10(max(factor, 1)) + 1)) * Stuff.dt * min(Controller.time_wasd_seconds / accelerate_time, 10));