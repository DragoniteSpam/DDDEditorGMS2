/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    if (emitter.type) {
        part_emitter_burst(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.rate);
    }
}