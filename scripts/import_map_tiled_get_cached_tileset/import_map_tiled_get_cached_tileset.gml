/// @param cache-map
/// @param path

var cache = argument0;
var path = argument1;

if (!ds_exists(cache, ds_type_map)) {
    return noone;
}

var data = cache[? path];

if (data) {
    return data;
}

var file = cache[? "*dir"] + "\\" + path;

if (!file_exists(file)) {
    cache[? path] = noone;
    return noone;
}

var buffer = buffer_load(file);
data = json_decode(buffer_read(buffer, buffer_text));
buffer_delete(buffer);

ds_map_add_map(cache, path, data);
return data;