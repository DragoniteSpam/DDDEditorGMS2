/// @description c_raycast_world(xfrom, yfrom, zfrom, xto, yto, zto, mask)
/// @param xfrom
/// @param  yfrom
/// @param  zfrom
/// @param  xto
/// @param  yto
/// @param  zto
/// @param  mask
/*
Casts a ray from (xfrom,yfrom,zfrom) to (xto,yto,zto), against all collision objects in the world, using a mask.
Returns true if the ray hit something, and false if it did not.
Use the c_hit_* functions to get more information about the hit.
*/
return external_call(global._c_raycast_world, argument0, argument1, argument2, argument3, argument4, argument5, argument6);
