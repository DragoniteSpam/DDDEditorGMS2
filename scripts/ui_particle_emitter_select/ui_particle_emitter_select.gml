/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    ui_input_set_value(list.root.name, emitter.name);
    list.root.shape.value = emitter.region_shape;
    list.root.distr.value = emitter.region_distribution;
}