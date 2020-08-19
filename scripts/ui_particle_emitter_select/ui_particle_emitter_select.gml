/// @param UIList
function ui_particle_emitter_select(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        var emitter = Stuff.particle.emitters[| selection];
        list.root.shape.value = emitter.region_shape;
        list.root.distr.value = emitter.region_distribution;
        list.root.streaming.value = emitter.streaming;
        list.root.draw.value = emitter.draw_region;
        ui_input_set_value(list.root.name, string(emitter.name));
        ui_input_set_value(list.root.xmin, string(emitter.region_x1));
        ui_input_set_value(list.root.ymin, string(emitter.region_y1));
        ui_input_set_value(list.root.xmax, string(emitter.region_x2));
        ui_input_set_value(list.root.ymax, string(emitter.region_y2));
        ui_input_set_value(list.root.rate, string(emitter.rate));
        ui_list_deselect(list.root.types);
        ui_list_select(list.root.types, ds_list_find_index(Stuff.particle.types, emitter.type));
    }


}
