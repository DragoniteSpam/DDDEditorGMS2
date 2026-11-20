// Feather disable all
/// @desc Function Description
/// @param {real} x1 The starting x coordinate of the capsule
/// @param {real} y1 The starting y coordinate of the capsule
/// @param {real} z1 The starting z coordinate of the capsule
/// @param {real} x2 The ending x coordinate of the capsule
/// @param {real} y2 The ending y coordinate of the capsule
/// @param {real} z2 The ending z coordinate of the capsule
/// @param {pointer.Texture|real} tex The texture to draw the cylinder with (defaults to -1 for no texture)
function d3d_draw_capsule_simple(x1, y1, z1, x2, y2, z2, tex = -1) {
    d3d_draw_cylinder_simple(x1, y1, z1, x2, y2, z2, tex, false);
    var zradius = min(abs(x2 - x1), abs(y2 - y1)) / 2;
    d3d_draw_ellipsoid_simple(x1, y1, z1 - zradius, x2, y2, z1 + zradius, tex);
    d3d_draw_ellipsoid_simple(x1, y1, z2 - zradius, x2, y2, z2 + zradius, tex);
}