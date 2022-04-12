function graphics_add_generic(filename, prefix, list, name = filename_name(filename), remove_back = true) {
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = new DataImage(name);
    data.source_filename = filename;
    data.picture = sprite_add(filename, 0, false, false, 0, 0);
    data.width = sprite_get_width(data.picture);
    data.height = sprite_get_height(data.picture);
    
    internal_name_generate(data, prefix + internal_name);
    array_push(list, data);
    
    return data;
}