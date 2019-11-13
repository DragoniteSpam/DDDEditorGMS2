/// @param z

var factor = argument0;
var base_speed = 32;
var accelerate_time = 8;

return max(1, (base_speed * (log2(max(factor, 1)) + 1)) * Stuff.dt * min(Controller.time_wasd_seconds / accelerate_time, 10));