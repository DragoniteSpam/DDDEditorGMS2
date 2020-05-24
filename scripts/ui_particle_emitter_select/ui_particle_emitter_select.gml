/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    ui_input_set_value(list.root.name, emitter.name);
    list.root.shape.value = emitter.region_shape;
    list.root.distr.value = emitter.region_distribution;
    ui_input_set_value(list.root.xmin, emitter.region_x1);
    ui_input_set_value(list.root.ymin, emitter.region_y1);
    ui_input_set_value(list.root.xmax, emitter.region_x2);
    ui_input_set_value(list.root.ymax, emitter.region_y2);
    list.root.streaming.value = emitter.streaming;
    ui_input_set_value(list.root.rate, emitter.rate);
    ui_list_select(list.root.types, ds_list_find_index(Stuff.particle.types, emitter.type));
}