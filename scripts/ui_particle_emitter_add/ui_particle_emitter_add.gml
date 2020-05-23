/// @param UIButton

var button = argument0;

if (ds_list_size(Stuff.particle.emitters) < PART_MAXIMUM_EMITTERS) {
    var emitter = part_emitter_create(Stuff.particle.system);
    ds_list_add(Stuff.particle.emitters, emitter);
}