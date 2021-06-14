/// @param UIButton
function ui_particle_type_add(argument0) {

    var button = argument0;

    if (array_length(Stuff.particle.types) < PART_MAXIMUM_TYPES) {
        array_push(Stuff.particle.types, new ParticleType("Type " + string(array_length(Stuff.particle.types))));
    }

}
