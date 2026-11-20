// Feather disable all
/// @desc Draws a sphere from a position and a radius. Ignores optional parameters to skip the caching step, resulting in slightly better performance.
/// @param {real} x The x coordinate of the sphere
/// @param {real} y The y coordinate of the sphere
/// @param {real} z The z coordinate of the sphere
/// @param {real} r The radius of the sphere
/// @param {pointer.Texture|real} tex The texture to draw the sphere with (defaults to -1 for no texture)
function d3d_draw_sphere_simple(x, y, z, r, tex = -1) {
    d3d_draw_ellipsoid_simple(x - r, y - r, z - r, x + r, y + r, z + r, tex);
}