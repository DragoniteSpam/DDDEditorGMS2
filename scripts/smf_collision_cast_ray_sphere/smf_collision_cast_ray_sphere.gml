/// @description smf_collision_cast_ray_sphere(sx, sy, sz, r, x1, y1, z1, x2, y2, z2)
/// @param sphereX
/// @param sphereY
/// @param sphereZ
/// @param sphereRadius
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a sphere centered at (sx,sy,sz) with radius r.

Returns the intersection as an array of the following format:
[x, y, z, nx, ny, nz, intersection (true or false)]

Script made by TheSnidr

www.thesnidr.com
*/
var d, dp, dPos, dV, r, l, N, pos;
r = argument3;
dPos = [argument0 - argument4, argument1 - argument5, argument2 - argument6];
dV = [argument7 - argument4, argument8 - argument5, argument9 - argument6];

//dp is now the distance from the starting point to the plane perpendicular to the ray direction, times the length of dV
dp = (dPos[0] * dV[0] + dPos[1] * dV[1] + dPos[2] * dV[2]);

//d is the remaining distance from this plane to the surface of the sphere, times the length of dV
l = sqr(dV[0]) + sqr(dV[1]) + sqr(dV[2]);
d = sqr(dp) + l * (sqr(r) - sqr(dPos[0]) - sqr(dPos[1]) - sqr(dPos[2]));

//If d is less than 0, there is no intersection
if d < 0 {return [0, 0, 0, 0, 0, 0, 0];}
d = sqrt(d);

//If dp is less than d, it means that the ray is cast from within the sphere. We therefore need to add d to dp, since the intersection point will then be on the inside surface of the sphere
if dp < d {dp += d; if dp < 0{return [0, 0, 0, 0, 0, 0, 0];}}
else {dp -= d;}

l = 1 / l;
pos = [argument4 + dV[0] * dp * l, argument5 + dV[1] * dp * l, argument6 + dV[2] * dp * l];
N = smf_vector_normalize([pos[0] - argument0, pos[1] - argument1, pos[2] - argument2]);
return [pos[0], pos[1], pos[2], N[0], N[1], N[2], true];