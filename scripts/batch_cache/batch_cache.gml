var buffer=vertex_create_buffer();
var buffer_wire=vertex_create_buffer();
vertex_begin(buffer, Camera.vertex_format);
vertex_begin(buffer_wire, Camera.vertex_format_line);
var list=ds_list_create();

for (var i=0; i<ds_list_size(ActiveMap.batch_in_the_future); i++){
    var thing=ActiveMap.batch_in_the_future[| i];
    thing.batch_index=ds_list_size(ActiveMap.batches);
    script_execute(thing.batch, buffer, buffer_wire, thing);
    ds_list_add(list, thing);
}

vertex_end(buffer);
vertex_freeze(buffer);

vertex_end(buffer_wire);
vertex_freeze(buffer_wire);

ds_list_add(ActiveMap.batches, buffer);
ds_list_add(ActiveMap.batches_wire, buffer_wire);
ds_list_add(ActiveMap.batch_instances, list);

ds_list_clear(ActiveMap.batch_in_the_future);
