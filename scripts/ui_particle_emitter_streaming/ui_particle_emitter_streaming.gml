/// @param UICheckbox

var checkbox = argument0;
var selection = ui_list_selection(checkbox.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.streaming = checkbox.value;
    if (emitter.type) {
        part_emitter_stream(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.streaming ? emitter.rate : 0);
    }
}