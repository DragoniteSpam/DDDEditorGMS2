/// @description c_transform_scaling(xs, ys, zs)
/// @param xs
/// @param  ys
/// @param  zs
/*
Sets the scaling of the transformation.
Note: Scaling only applies to shapes and will have no effect when applied to a collision object.
Note: Not all shapes support non-uniform scaling.
*/
return external_call(global._c_transform_scaling, argument0, argument1, argument2);
