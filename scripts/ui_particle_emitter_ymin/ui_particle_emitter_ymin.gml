/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.region_y1 = input.value;
    editor_particle_emitter_set_region(emitter);
    editor_particle_emitter_create_region(emitter);
}