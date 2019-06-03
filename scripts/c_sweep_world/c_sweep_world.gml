/// @description c_sweep_world(shape, xfrom, yfrom, zfrom, xto, yto, zto, mask)
/// @param shape
/// @param xfrom
/// @param yfrom
/// @param zfrom
/// @param xto
/// @param yto
/// @param zto
/// @param mask
/*
Performs a convex sweep from (xfrom,yfrom,zfrom) to (xto,yto,zto), against all collision objects in the world, using a mask.
A sweep is like a ray cast except it uses a shape to check for collisions instead of a ray.
Since this is a convex sweep test, the shape should only have 1 sub-shape. If there are multiple sub-shapes the first one is used for the sweep test.
Returns true if there was a hit, and false otherwise. Use the c_hit_* functions to get more information about the hit.
*/
return external_call(global._c_sweep_world, argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7);
