/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.name = input.value;
}