/// @param UIButton

var button = argument0;

if (ds_list_size(Stuff.particle.types) < PART_MAXIMUM_TYPES) {
    var type = instance_create_depth(0, 0, 0, ParticleType);
    type.name = "Type " + string(ds_list_size(Stuff.particle.types));
    instance_deactivate_object(type);
    ds_list_add(Stuff.particle.types, type);
}