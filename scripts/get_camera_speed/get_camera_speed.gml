/// @param z

var factor = argument0;
var base_speed = 64;
var accelerate_time = 5;

return max(1, (base_speed * (log2(max(factor, 1)) + 1)) * Stuff.dt * min(Controller.time_wasd_seconds / accelerate_time, 10));