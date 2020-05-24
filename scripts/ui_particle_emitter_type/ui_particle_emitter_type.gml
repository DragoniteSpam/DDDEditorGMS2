/// @param UIList

var list = argument0;
var selected_type = ui_list_selection(list);
var selection = ui_list_selection(list.root.list);

if (selection + 1 && selected_type + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    emitter.type = Stuff.particle.types[| selected_type];
    part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, emitter.region_shape, emitter.region_distribution);
    part_emitter_stream(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.streaming ? emitter.rate * Stuff.dt : 0);
}