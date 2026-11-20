// Feather disable all
/// @desc Draws a sphere from a position and a radius.
/// @param {real} x The x coordinate of the sphere
/// @param {real} y The y coordinate of the sphere
/// @param {real} z The z coordinate of the sphere
/// @param {real} r The radius of the sphere
/// @param {pointer.Texture|real} tex The texture to draw the sphere with (defaults to -1 for no texture)
/// @param {real} [hrepeat] The number of horizontal texture repetitions (defaults to 1)
/// @param {real} [vrepeat] The number of vertical texture repetitions (defaults to 1)
/// @param {real} [steps] The number of steps to draw the sphere with; higher values produce smooth shapes but are more expensive (defaults to 32)
/// @param {real} [c] The vertex color to draw the sphere with (defaults to the current draw color)
/// @param {real} [a] The vertex color to draw the sphere with (defaults to the current draw alpha)
function d3d_draw_sphere(x, y, z, r, tex = -1, hrepeat = 1, vrepeat = 1, steps = 32, c = draw_get_colour(), a = draw_get_alpha()) {
    d3d_draw_ellipsoid(x - r, y - r, z - r, x + r, y + r, z + r, tex, hrepeat, vrepeat, steps, c, a);
}