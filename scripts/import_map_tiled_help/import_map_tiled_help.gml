function import_map_tiled_get_cached_object(cache, path) {
    var data = cache[$ path];
    if (data) return data;
    var file = cache[$ "*dir"] + "/" + path;
    
    if (!file_exists(file)) {
        cache[$ path] = undefined;
        return undefined;
    }
    
    var buffer = buffer_load(file);
    data = json_parse(buffer_read(buffer, buffer_text));
    buffer_delete(buffer);
    
    cache[$ path] = data;
    return data;
}

function import_map_tiled_get_cached_tileset(cache, path) {
    var data = cache[$ path];
    if (data) return data;
    var file = cache[$ "*dir"] + "/" + path;
    
    if (!file_exists(file)) {
        cache[$ path] = undefined;
        return undefined;
    }
    
    var buffer = buffer_load(file);
    data = json_parse(buffer_read(buffer, buffer_text));
    buffer_delete(buffer);
    
    cache[$ path] = data;
    return data;
}