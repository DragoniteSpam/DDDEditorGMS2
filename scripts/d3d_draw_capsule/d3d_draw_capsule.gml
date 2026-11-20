// Feather disable all
/// @desc Function Description
/// @param {real} x1 The starting x coordinate of the capsule
/// @param {real} y1 The starting y coordinate of the capsule
/// @param {real} z1 The starting z coordinate of the capsule
/// @param {real} x2 The ending x coordinate of the capsule
/// @param {real} y2 The ending y coordinate of the capsule
/// @param {real} z2 The ending z coordinate of the capsule
/// @param {pointer.Texture|real} tex The texture to draw the cylinder with (defaults to -1 for no texture)
/// @param {real} [hrepeat] The number of horizontal texture repetitions (defaults to 1)
/// @param {real} [vrepeat] The number of vertical texture repetitions (defaults to 1)
/// @param {real} [steps] The number of steps to draw the cylinder with; higher values produce smooth shapes but are more expensive (defaults to 32)
/// @param {real} [c1] The vertex color to draw the beginning of the cylinder with (defaults to the current draw color)
/// @param {real} [a1] The vertex alpha to draw the beginning of the cylinder with (defaults to the current draw alpha)
/// @param {real} [c2] The vertex color to draw the end of the cylinder with (defaults to c1)
/// @param {real} [a2] The vertex alpha to draw the end of the cylinder with (defaults to a1)
function d3d_draw_capsule(x1, y1, z1, x2, y2, z2, tex = -1, hrepeat = 1, vrepeat = 1, steps = 32, c1 = draw_get_colour(), a1 = draw_get_alpha(), c2 = c1, a2 = a1) {
    d3d_draw_cylinder(x1, y1, z1, x2, y2, z2, tex, hrepeat, vrepeat, false, steps, c1, a1, c2, a2);
    var zradius = min(abs(x2 - x1), abs(y2 - y1)) / 2;
    d3d_draw_ellipsoid(x1, y1, z1 - zradius, x2, y2, z1 + zradius, tex, hrepeat, vrepeat, steps, c1, a1);
    d3d_draw_ellipsoid(x1, y1, z2 - zradius, x2, y2, z2 + zradius, tex, hrepeat, vrepeat, steps, c2, a2);
}