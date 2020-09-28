/// @param animation
/// @param name
function animation_layer_create(argument0, argument1) {

    var animation = argument0;
    var name = argument1;

    var timeline_layer = instance_create_depth(0, 0, 0, DataAnimLayer);
    timeline_layer.name = name;
    instance_deactivate_object(timeline_layer);
    ds_list_add(animation.layers, timeline_layer);

    return timeline_layer;


}
