/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    if (emitter.type) {
        part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, emitter.region_shape, emitter.region_distribution);
        part_emitter_burst(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.rate);
    }
}