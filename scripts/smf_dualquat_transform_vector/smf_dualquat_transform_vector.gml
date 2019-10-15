/// @description smf_dualquat_transform_vector(Q, vx, vy, vz)
/// @param Q[8]
/// @param vx
/// @param vy
/// @param vz
gml_pragma("forceinline");

var Q, vx, vy, vz, cx, cy, cz;
Q = argument0;
vx = argument1;
vy = argument2;
vz = argument3;

cx = Q[1] * vz - Q[2] * vy + Q[3] * vx;
cy = Q[2] * vx - Q[0] * vz + Q[3] * vy;
cz = Q[0] * vy - Q[1] * vx + Q[3] * vz;

return [vx + 2 * (Q[1] * (cz + Q[6]) - Q[2] * (cy + Q[5]) - Q[7] * Q[0] + Q[4] * Q[3]),
		vy + 2 * (Q[2] * (cx + Q[4]) - Q[0] * (cz + Q[6]) - Q[7] * Q[1] + Q[5] * Q[3]),
		vz + 2 * (Q[0] * (cy + Q[5]) - Q[1] * (cx + Q[4]) - Q[7] * Q[2] + Q[6] * Q[3])];