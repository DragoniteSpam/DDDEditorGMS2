function import_qma(filename, adjust) {
    if (adjust == undefined) adjust = true;
    var buffer = buffer_load(filename);
    
    var data = json_decode(buffer_read(buffer, buffer_string));
    var version = data[? "version"];
    
    ds_map_destroy(data);
    
    var n = buffer_read(buffer, buffer_u32);
    
    repeat (n) {
        var mesh = import_qma_next(buffer, version);
    }
    
    buffer_delete(buffer);
}