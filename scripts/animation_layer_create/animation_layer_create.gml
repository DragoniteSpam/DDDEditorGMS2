/// @param animation
/// @param name

var animation = argument0;
var name = argument1;

var timeline_layer = instantiate(DataAnimLayer);
timeline_layer.name = name;
instance_deactivate_object(timeline_layer);
ds_list_add(animation.layers, timeline_layer);

return timeline_layer;