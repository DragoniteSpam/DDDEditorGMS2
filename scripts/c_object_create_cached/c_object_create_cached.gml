/// @param shape
/// @param group
/// @param mask

var shape = argument0;
var group = argument1;
var mask = argument2;

if (ds_queue_size(Stuff.c_object_cache) > 0) {
    var obj = ds_queue_dequeue(Stuff.c_object_cache);
    c_object_set_shape(obj, shape);
    c_object_set_mask(obj, group, mask);
    return obj;
}

return c_object_create(shape, group, mask);