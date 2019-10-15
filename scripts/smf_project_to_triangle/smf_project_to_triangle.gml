/// @description smf_project_to_triangle(pos[3], tri[12]);
/// @param pos[3]
/// @param tri[12];
/*
This script projects the given coordinate onto the given triangle.
If the coordinate isn't directly above the triangle, the resulting position will be the nearest point on
one of the triangle's edges.
The triangle is a 12-value array of the following format:
[x1, y1, z1, x2, y2, z2, x3, y3, z3, nx, ny, nz]

Script created by TheSnidr
www.thesnidr.com
*/
var t, u, dp, l, pos, tri;
pos = argument0;
tri = argument1;
//////////////////////////////////////////////////////////////////
//Check first triangle vector
t = [pos[0] - tri[0], pos[1] - tri[1], pos[2] - tri[2]];
u = [tri[3] - tri[0], tri[4] - tri[1], tri[5] - tri[2]];
if (dot_product_3d(t[2] * u[1] - t[1] * u[2], t[0] * u[2] - t[2] * u[0], t[1] * u[0] - t[0] * u[1], tri[9], tri[10], tri[11]) <= 0)
{
	dp = clamp(dot_product_3d(u[0], u[1], u[2], t[0], t[1], t[2]) / (sqr(u[0]) + sqr(u[1]) + sqr(u[2])), 0, 1);
	return [tri[0] + u[0] * dp, tri[1] + u[1] * dp, tri[2] + u[2] * dp];
}
//////////////////////////////////////////////////////////////////
//Check second triangle vector
t = [pos[0] - tri[3], pos[1] - tri[4], pos[2] - tri[5]];
u = [tri[6] - tri[3], tri[7] - tri[4], tri[8] - tri[5]];
if (dot_product_3d(t[2] * u[1] - t[1] * u[2], t[0] * u[2] - t[2] * u[0], t[1] * u[0] - t[0] * u[1], tri[9], tri[10], tri[11]) <= 0)
{
	dp = clamp(dot_product_3d(u[0], u[1], u[2], t[0], t[1], t[2]) / (sqr(u[0]) + sqr(u[1]) + sqr(u[2])), 0, 1);
	return [tri[3] + u[0] * dp, tri[4] + u[1] * dp, tri[5] + u[2] * dp];
}
//////////////////////////////////////////////////////////////////
//Check third triangle vector
t = [pos[0] - tri[6], pos[1] - tri[7], pos[2] - tri[8]];
u = [tri[0] - tri[6], tri[1] - tri[7], tri[2] - tri[8]];
if (dot_product_3d(t[2] * u[1] - t[1] * u[2], t[0] * u[2] - t[2] * u[0], t[1] * u[0] - t[0] * u[1], tri[9], tri[10], tri[11]) <= 0)
{
	dp = clamp(dot_product_3d(u[0], u[1], u[2], t[0], t[1], t[2]) / (sqr(u[0]) + sqr(u[1]) + sqr(u[2])), 0, 1);
	return [tri[6] + u[0] * dp, tri[7] + u[1] * dp, tri[8] + u[2] * dp];
}
//////////////////////////////////////////////////////////////////
//Project the coordinates to the plane defined by the triangle
l = tri[9] * t[0] + tri[10] * t[1] + tri[11] * t[2];
return [pos[0] - tri[9] * l, pos[1] - tri[10] * l, pos[2] - tri[11] * l];