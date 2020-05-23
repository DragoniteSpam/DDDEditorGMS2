/// @param UIButton

var button = argument0;

if (ds_list_size(Stuff.particle.types) < PART_MAXIMUM_TYPES) {
    var type = part_type_create();
    ds_list_add(Stuff.particle.types, type);
}