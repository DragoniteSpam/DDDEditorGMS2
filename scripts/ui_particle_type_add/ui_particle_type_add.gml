/// @param UIButton
function ui_particle_type_add(argument0) {

    var button = argument0;

    if (array_length(Stuff.particle.types) < PART_MAXIMUM_TYPES) {
        var type = instance_create_depth(0, 0, 0, ParticleType);
        type.name = "Type " + string(array_length(Stuff.particle.types));
        instance_deactivate_object(type);
        array_push(Stuff.particle.types, type);
    
        return type;
    }

    return noone;


}
