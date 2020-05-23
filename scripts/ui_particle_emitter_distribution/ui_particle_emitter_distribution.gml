/// @param UIRadioArray

var radio = argument0;
var selection = ui_list_selection(radio.root.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.region_distribution = radio.value;
}