/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.rate = real(input.value);
    if (emitter.type) {
        part_emitter_stream(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.streaming ? emitter.rate * Stuff.dt : 0);
    }
}