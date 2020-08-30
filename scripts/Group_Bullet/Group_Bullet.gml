var dll = "data\\collisions.dll";
var calltype = dll_cdecl;

global._c_world_create = external_define(dll, "c_world_create", calltype, ty_real, 0);
global._c_world_destroy = external_define(dll, "c_world_destroy", calltype, ty_real, 0);
global._c_world_exists = external_define(dll, "c_world_exists", calltype, ty_real, 0);
global._c_world_add_object = external_define(dll, "c_world_add_object", calltype, ty_real, 1, ty_real);
global._c_world_remove_object = external_define(dll, "c_world_remove_object", calltype, ty_real, 1, ty_real);
global._c_world_get_count = external_define(dll, "c_world_get_count", calltype, ty_real, 0);
global._c_object_create = external_define(dll, "c_object_create", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_object_destroy = external_define(dll, "c_object_destroy", calltype, ty_real, 1, ty_real);
global._c_object_exists = external_define(dll, "c_object_exists", calltype, ty_real, 1, ty_real);
global._c_object_apply_transform = external_define(dll, "c_object_apply_transform", calltype, ty_real, 1, ty_real);
global._c_object_set_shape = external_define(dll, "c_object_set_shape", calltype, ty_real, 2, ty_real, ty_real);
global._c_object_set_mask = external_define(dll, "c_object_set_mask", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_object_set_userid = external_define(dll, "c_object_set_userid", calltype, ty_real, 2, ty_real, ty_real);
global._c_object_get_userid = external_define(dll, "c_object_get_userid", calltype, ty_real, 1, ty_real);
global._c_shape_create = external_define(dll, "c_shape_create", calltype, ty_real, 0);
global._c_shape_destroy = external_define(dll, "c_shape_destroy", calltype, ty_real, 1, ty_real);
global._c_shape_exists = external_define(dll, "c_shape_exists", calltype, ty_real, 1, ty_real);
global._c_shape_add_box = external_define(dll, "c_shape_add_box", calltype, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global._c_shape_add_sphere = external_define(dll, "c_shape_add_sphere", calltype, ty_real, 2, ty_real, ty_real);
global._c_shape_add_capsule = external_define(dll, "c_shape_add_capsule", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_shape_add_cylinder = external_define(dll, "c_shape_add_cylinder", calltype, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global._c_shape_add_cone = external_define(dll, "c_shape_add_cone", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_shape_add_plane = external_define(dll, "c_shape_add_plane", calltype, ty_real, 5, ty_real, ty_real, ty_real, ty_real, ty_real);
global._c_shape_begin_trimesh = external_define(dll, "c_shape_begin_trimesh", calltype, ty_real, 0);
global._c_shape_load_trimesh = external_define(dll, "c_shape_load_trimesh", calltype, ty_real, 1, ty_string);
global._c_shape_end_trimesh = external_define(dll, "c_shape_end_trimesh", calltype, ty_real, 1, ty_real);
global._c_hit_x = external_define(dll, "c_hit_x", calltype, ty_real, 0);
global._c_hit_y = external_define(dll, "c_hit_y", calltype, ty_real, 0);
global._c_hit_z = external_define(dll, "c_hit_z", calltype, ty_real, 0);
global._c_hit_nx = external_define(dll, "c_hit_nx", calltype, ty_real, 0);
global._c_hit_ny = external_define(dll, "c_hit_ny", calltype, ty_real, 0);
global._c_hit_nz = external_define(dll, "c_hit_nz", calltype, ty_real, 0);
global._c_hit_fraction = external_define(dll, "c_hit_fraction", calltype, ty_real, 0);
global._c_hit_object = external_define(dll, "c_hit_object", calltype, ty_real, 1, ty_real);
global._c_transform_position = external_define(dll, "c_transform_position", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_transform_rotation = external_define(dll, "c_transform_rotation", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_transform_scaling = external_define(dll, "c_transform_scaling", calltype, ty_real, 3, ty_real, ty_real, ty_real);
global._c_transform_identity = external_define(dll, "c_transform_identity", calltype, ty_real, 0);
global._c_raycast_world = external_define(dll, "c_raycast_world", calltype, ty_real, 7, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global._c_raycast_object = external_define(dll, "c_raycast_object", calltype, ty_real, 7, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global._c_overlap_world = external_define(dll, "c_overlap_world", calltype, ty_real, 1, ty_real);
global._c_overlap_world_position = external_define(dll, "c_overlap_world_position", calltype, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global._c_overlap_object = external_define(dll, "c_overlap_object", calltype, ty_real, 2, ty_real, ty_real);
global._c_sweep_world = external_define(dll, "c_sweep_world", calltype, ty_real, 8, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global._c_shape_add_triangle = external_define(dll, "c_shape_add_triangle", calltype, ty_real, 9, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);

function c_hit_fraction() {
    // Returns a number between 0 and 1, which is the distance to the hit.
    return external_call(global._c_hit_fraction);
}

function c_hit_nx() {
    // Returns the x component of the normal of the last hit.
    return external_call(global._c_hit_nx);
}

function c_hit_ny() {
    // Returns the y component of the normal of the last hit.
    return external_call(global._c_hit_ny);
}

function c_hit_nz() {
    // Returns the z component of the normal of the last hit.
    return external_call(global._c_hit_nz);
}

function c_hit_object(n) {
    // Returns the id's of the collision objects that were hit.
    // For raycasts and sweeps, only one object can be hit so use 0 as the argument.
    // Overlap tests can hit multiple objects to use argument0 to access each one.
    // c_overlap_world() and c_overlap_world_position() return the number of objects that were hit.
    return external_call(global._c_hit_object, n);
}

function c_hit_x() {
    // Returns the x position of the last hit.
    return external_call(global._c_hit_x);
}

function c_hit_y() {
    // Returns the y position of the last hit.
    return external_call(global._c_hit_y);
}

function c_hit_z() {
    // Returns the z position of the last hit.
    return external_call(global._c_hit_z);
}

function c_object_apply_transform(object) {
    // Sets the transformation of the collision object to the currently defined transform.
    // Note: Scaling has no effect on collision objects, it only works on shapes.
    return external_call(global._c_object_apply_transform, object);
}

function c_object_create(shape, group, mask) {
    // Creates a collision object from a shape and returns the id.
    // The "group" argument is an integer bitfield where each bit represents a group. This is the group that this object is in.
    // The "mask" argument sets which groups this object can collide with.
    // A bitwise AND operation is performed with the group of one object and the mask of another whenever there is a collision check.
    // For a collision to occur between two objects, both objects' masks must include each other.
    return external_call(global._c_object_create, shape, group, mask);
}

function c_object_destroy(object) {
    // Destroys the collision object, freeing the memory used.
    // Do not destroy an object while it is in the world. Remove it first or use c_world_destroy_object() instead.
    return external_call(global._c_object_destroy, object);
}

function c_object_exists(object) {
    // Returns true if the collision object exists, and false otherwise.
    return external_call(global._c_object_exists, object);
}

function c_object_get_userid(object) {
    // Use this to retrieve the value that you set with c_object_set_userid().
    // Returns 0 if no value has been set.
    return external_call(global._c_object_get_userid, object);
}

function c_object_set_mask(object, group, mask) {
    // Sets the collision mask of the object.
    return external_call(global._c_object_set_mask, object, group, mask);
}

function c_object_set_shape(object, shape) {
    // Sets the shape of the collision object.
    return external_call(global._c_object_set_shape, object, shape);
}

function c_object_set_userid(object, number) {
    // Associate a collision object with any unsigned integer of your choice.
    // Useful for linking a GameMaker instance with a collision object.
    return external_call(global._c_object_set_userid, object, number);
}

function c_overlap_object(object1, object2) {
    // Checks if two objects overlap each other. The objects do not need to be in the world.
    // Returns true if there is an overlap, and false if not.
    return external_call(global._c_overlap_object, object1, object2);
}

function c_overlap_world(object) {
    // Checks if the object overlaps any other object in the world. The object does not need to be in the world.
    // Returns the number of objects that are overlapping this object. Use c_hit_object(n) to get those objects.
    return external_call(global._c_overlap_world, object);
}

function c_overlap_world_position(object, x, y, z) {
    // Checks if the object will overlap any other object at the given position. The object does not need to be in the world.
    // Returns the number of objects that are overlapping this object. Use c_hit_object(n) to get those objects.
    return external_call(global._c_overlap_world_position, object, x, y, z);
}

function c_raycast_object(object, xfrom, yfrom, zfrom, xto, yto, zto, mask) {
    // Casts a ray from (xfrom,yfrom,zfrom) to (xto,yto,zto), against the specified object.
    // Returns true if the ray hit, and false if it did not.
    // Use the c_hit_* functions to get more information about the hit.
    return external_call(global._c_raycast_object, object, xfrom, yfrom, zfrom, xto, yto, zto, mask);
}

function c_raycast_world(xfrom, yfrom, zfrom, xto, yto, zto, mask) {
    // Casts a ray from (xfrom,yfrom,zfrom) to (xto,yto,zto), against all collision objects in the world, using a mask.
    // Returns true if the ray hit something, and false if it did not.
    // Use the c_hit_* functions to get more information about the hit.
    return external_call(global._c_raycast_world, xfrom, yfrom, zfrom, xto, yto, zto, mask);
}

function c_shape_add_box(shape, xhalf, yhalf, zhalf) {
    // Adds a box to a shape, centered at (0,0,0).
    // Note: The shape will be added with the currently defined transformation.
    return external_call(global._c_shape_add_box, shape, xhalf, yhalf, zhalf);
}

function c_shape_add_capsule(shape, radius, height) {
    // Adds a z-up facing capsule to a shape, centered at (0,0,0)
    // Note: The shape will be added with the currently defined transformation.
    return external_call(global._c_shape_add_capsule, shape, radius, height);
}

function c_shape_add_cone(shape, radius, height) {
    // Adds a z-up facing cone to a shape, centered at (0,0,0)
    // Note: The shape will be added with the currently defined transformation.
    return external_call(global._c_shape_add_cone, shape, radius, height);
}

function c_shape_add_cylinder(shape, xhalf, yhalf, zhalf) {
    // Adds a z-up facing cylinder to a shape, centered at (0,0,0).
    // Note: The shape will be added with the currently defined transformation.
    return external_call(global._c_shape_add_cylinder, shape, xhalf, yhalf, zhalf);
}

function c_shape_add_plane(shape, nx, ny, nz, distance) {
    // Adds an infinite plane that is solid to infinity on one side.
    // It is defined by a surface normal and the distance to the world origin.
    return external_call(global._c_shape_add_plane, shape, nx, ny, nz, distance);
}

function c_shape_add_sphere(shape, radius) {
    // Adds a sphere to a shape, centered at (0,0,0)
    // This shape is very efficient, but it can't have a non-uniform scale.
    // Note: The shape will be added with the currently defined transformation.
    return external_call(global._c_shape_add_sphere, shape, radius);
}

function c_shape_add_triangle(x1, y1, z1, x2, y2, z2, x3, y3, z3) {
    // Adds a triangle to a trimesh. Make sure you call c_shape_begin_trimesh() before adding triangles.
    return external_call(global._c_shape_add_triangle, x1, y1, z1, x2, y2, z2, x3, y3, z3);
}

function c_shape_begin_trimesh() {
    // Creates a trimesh that you can add triangles to. Call this before adding any triangles.
    // Note: Trimeshes cannot collide with other trimeshes. Intended use is static level geometry.
    return external_call(global._c_shape_begin_trimesh);
}

function c_shape_create() {
    // Creates an empty shape and returns the id.
    // A shape can be used by any number of objects and can contain any number of sub-shapes.
    return external_call(global._c_shape_create);
}


function c_shape_destroy(shape) {
    // Destroys the shape, freeing the memory used. Don't destroy a shape while there are objects using it.
    return external_call(global._c_shape_destroy, shape);
}

function c_shape_end_trimesh(shape) {
    // Call this when done adding triangles to a trimesh. This function adds the trimesh to the shape.
    // Note: The trimesh will be added with the currently defined transformation.
    // Note: Trimeshes cannot collide with other trimeshes. Intended use is static level geometry.
    return external_call(global._c_shape_end_trimesh, shape);
}

function c_shape_exists(shape) {
    // Returns true if the shape exists, and false otherwise.
    return external_call(global._c_shape_exists, shape);
}

function c_shape_load_trimesh(filename) {
    // Loads a trimesh from a GameMaker model file.
    // Only triangle lists are supported. Triangle fans/strips don't load properly and primitive shapes are ignored.
    // Returns 1 if successful, 0 for undefined trimesh, and -1 for file system error.
    return external_call(global._c_shape_load_trimesh, filename);
}

function c_sweep_world(shape, xfrom, yfrom, zfrom, xto, yto, zto, mask) {
    // Performs a convex sweep from (xfrom,yfrom,zfrom) to (xto,yto,zto), against all collision objects in the world, using a mask.
    // A sweep is like a ray cast except it uses a shape to check for collisions instead of a ray.
    // Since this is a convex sweep test, the shape should only have 1 sub-shape. If there are multiple sub-shapes the first one is used for the sweep test.
    // Returns true if there was a hit, and false otherwise. Use the c_hit_* functions to get more information about the hit.
    return external_call(global._c_sweep_world, shape, xfrom, yfrom, zfrom, xto, yto, zto, mask);
}

function c_transform_identity() {
    // Resets the transformation to the identity transform.
    return external_call(global._c_transform_identity);
}

function c_transform_matrix(matrix) {
    // Sets the translation and rotation from a 4x4 matrix. Set scaling separately.
    var r = external_call(global._c_transform_matrix, matrix[0], matrix[1], matrix[2], matrix[4], matrix[5], matrix[6], matrix[8], matrix[9], matrix[10]);
    c_transform_position(matrix[12], matrix[13], matrix[14]);
}

function c_transform_position(x, y, z) {
    // Sets the translation of the transformation.
    return external_call(global._c_transform_position, x, y, z);
}

function c_transform_rotation(xrot, yrot, zrot) {
    // Sets the rotation of the transformation in euler angles.
    // Note: Angles are in degrees. You can easily modify this script to use radians instead.
    return external_call(global._c_transform_rotation, degtorad(-xrot), degtorad(-yrot), degtorad(-zrot));
}

function c_transform_rotation_axis(xa, ya, za, angle) {
    // Sets the rotation of the transformation as an angle around an axis.
    // Note: Angle is in radians.
    return external_call(global._c_transform_rotation_axis, xa, ya, za, angle);
}

function c_transform_rotation_quaternion(x, y, z, w) {
    // Sets the rotation of the transformation as a quaternion.
    return external_call(global._c_transform_rotation_quaternion, x, y, z, w);
}

function c_transform_scaling(xscale, yscale, zscale) {
    // Sets the scaling of the transformation.
    // Note: Scaling only applies to shapes and will have no effect when applied to a collision object.
    // Note: Not all shapes support non-uniform scaling.
    return external_call(global._c_transform_scaling, xscale, yscale, zscale);
}

function c_world_add_object(object) {
    // Adds a collision object to the world, so it will participate in world collision checks.
    return external_call(global._c_world_add_object, object);
}

function c_world_create() {
    // Creates the collision world. There can only be one world at a time. Returns true if successful.
    // The collision world lets you perform collision checks against multiple objects at once.
    // You must create the collision world before you call perform any collision checks, even if you are only performing checks on individual objects.
    return external_call(global._c_world_create);
}

function c_world_destroy() {
    // Destroys the world and all the collision objects in it. Shapes are not destroyed.
    return external_call(global._c_world_destroy);
}

function c_world_destroy_object(object) {
    // Removes the object from the world and then destroys it, freeing the memory used.
    // A convenience script. Same thing as removing the object and then destroying it yourself.
    c_world_remove_object(object);
    c_object_destroy(object);
}

function c_world_exists() {
    // Retuns true if the collision world exists, and false otherwise.
    return external_call(global._c_world_exists);
}

function c_world_get_count() {
    // Returns the number of collision objects that are in the world.
    return external_call(global._c_world_get_count);
}

function c_world_remove_object(object) {
    // Removes a collision object from the world. Does not destroy the object, it only removes it from the world.
    // The object will no longer participate in world collision checks.
    return external_call(global._c_world_remove_object, object);
}