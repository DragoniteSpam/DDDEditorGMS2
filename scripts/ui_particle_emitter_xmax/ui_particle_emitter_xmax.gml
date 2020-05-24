/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.region_x2 = input.value;
    part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, emitter.region_shape, emitter.region_distribution);
    editor_particle_emitter_create_region(emitter);
}