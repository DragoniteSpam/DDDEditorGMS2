/// @description void batch_again(index);
/// @param index

vertex_delete_buffer(ActiveMap.batches[| argument0]);
vertex_delete_buffer(ActiveMap.batches_wire[| argument0]);
var list=ActiveMap.batch_instances[| argument0];

if (ds_list_size(list)>0) {
    var buffer=vertex_create_buffer();
    var buffer_wire=vertex_create_buffer();
    vertex_begin(buffer, Camera.vertex_format);
    vertex_begin(buffer_wire, Camera.vertex_format_line);
    
    for (var i=0; i<ds_list_size(list); i++) {
        var thing=list[| i];
        script_execute(thing.batch, buffer, buffer_wire, thing);
    }
    
    vertex_end(buffer);
    vertex_freeze(buffer);
    
    vertex_end(buffer_wire);
    vertex_freeze(buffer_wire);
    
    ActiveMap.batches[| argument0]=buffer;
    ActiveMap.batches_wire[| argument0]=buffer_wire;
} else {
    ds_list_destroy(list);
    ds_list_delete(ActiveMap.batches, argument0);
    ds_list_delete(ActiveMap.batches_wire, argument0);
    ds_list_delete(ActiveMap.batch_instances, argument0);
    
    for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++) {
        var thing=ActiveMap.all_entities[| i];
        if (thing.batch_index>argument0) {
            thing.batch_index--;
        }
    }
}
