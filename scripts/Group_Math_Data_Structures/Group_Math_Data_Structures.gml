#region array stuff - please don't delete these, even if you find that they're not used anywhere
function array_to_list(array) {
    var list = ds_list_create();
    for (var i = 0; i < array_length(array); i++) {
        ds_list_add(list, array[@ i]);
    }
    
    return list;
}

function array_to_map(array) {
    var results = { };
    for (var i = 0, n = array_length(array); i < n; i++) {
        results[$ string(i)] = array[i];
    }
    return results;
}

function array_values_to_map(array) {
    var results = { };
    for (var i = 0, n = array_length(array); i < n; i++) {
        if (!variable_struct_exists(results, string(array[i]))) {
            results[$ string(array[i])] = i;
        }
    }
    return results;
}

function array_clear(array, value) {
    for (var i = 0; i < array_length(array); i++) {
        array[@ i] = value;
    }
}

function array_clear_instances(array) {
    var n = array_length(array);
    for (var i = 0; i < n; i++) {
        var what = array[i];
        if (what) {
            if (is_struct(what)) {
                what.Destroy();
            } else {
                instance_activate_object(what);
                instance_destroy(what);
            }
        }
    }
    
    array_resize(array, 0);
    
    return n;
}

function array_clone(array) {
    var new_array = array_create(array_length(array));
    array_copy(new_array, 0, array, 0, array_length(array));
    return new_array;
}

function array_empty(array) {
    return array_length(array) == 0;
}

function array_create_2d(x, y, value = 0) {
    var arr = array_create(x);
    for (var i = 0; i < x; i++) {
        arr[@ i] = array_create(y, value);
    }
    return arr;
}

function array_create_3d(x, y, z, value = 0) {
    var arr = array_create(x);
    for (var i = 0; i < x; i++) {
        arr[@ i] = array_create(y);
        for (var j = 0; j < y; j++) {
            arr[@ i][@ j] = array_create(z, value);
        }
    }
    return arr;
}

function array_create_4d(x, y, z, w, value = 0) {
    var arr = array_create(x);
    for (var i = 0; i < x; i++) {
        arr[@ i] = array_create(y);
        for (var j = 0; j < y; j++) {
            arr[@ i][@ j] = array_create(z, value);
            for (var k = 0; k < z; k++) {
                arr[@ i][@ j][@ k] = array_create(w, value);
            }
        }
    }
    return arr;
}

function array_clear_2d(array, value = 0) {
    for (var i = 0; i < array_length(array); i++) {
        for (var j = 0; j < array_length(array[i]); j++) {
            array[@ i][@ j] = value;
        }
    }
}

function array_clear_3d(array, value = 0) {
    for (var i = 0; i < array_length(array); i++) {
        for (var j = 0; j < array_length(array[i]); j++) {
            for (var k = 0; k < array_length(array[i][j]); k++) {
                array[@ i][@ j][@ k] = value;
            }
        }
    }
}

function array_clear_4d(array, value = 0) {
    for (var i = 0; i < array_length(array); i++) {
        for (var j = 0; j < array_length(array[i]); j++) {
            for (var k = 0; k < array_length(array[i][j]); k++) {
                for (var l = 0; l < array_length(array[i][j][k]); l++) {
                    array[@ i][@ j][@ k][@ l] = value;
                }
            }
        }
    }
}

function array_resize_2d(array, x, y) {
    array_resize(array, x);
    for (var i = 0; i < array_length(array); i++) {
        if (is_array(array[i])) array_resize(array[i], y);
        else array[@ i] = array_create(y);
    }
}

function array_resize_3d(array, x, y, z) {
    var old_x = array_length(array);
    array_resize(array, x);
    for (var i = 0; i < array_length(array); i++) {
        if (is_array(array[i])) array_resize(array[i], y);
        else array[@ i] = array_create(y);
        for (var j = 0; j < array_length(array[i]); j++) {
            if (is_array(array[i][j])) array_resize(array[i][j], z);
            else array[@ i][@ j] = array_create(z);
        }
    }
}

function array_resize_4d(array, x, y, z, w) {
    var old_x = array_length(array);
    array_resize(array, x);
    for (var i = 0; i < array_length(array); i++) {
        if (is_array(array[i])) array_resize(array[i], y);
        else array[@ i] = array_create(y);
        for (var j = 0; j < array_length(array[i]); j++) {
            if (is_array(array[i][j])) array_resize(array[i][j], z);
            else array[@ i][@ j] = array_create(z);
            for (var k = 0; k < array_length(array[i][j]); k++) {
                if (is_array(array[i][j][k])) array_resize(array[i][j][k], w);
                else array[@ i][@ j][@ k] = array_create(w);
            }
        }
    }
}

function array_sort_name(array) {
    array_sort(array, function(a, b) {
        return (a.name > b.name) ? 1 : -1;
    });
    return array;
}

function array_sort_internal(array) {
    array_sort(array, function(a, b) {
        return (a.internal_name > b.internal_name) ? 1 : -1;
    });
}

function array_search_guid(array, guid) {
    for (var i = 0, n = array_length(array); i < n; i++) {
        if (array[i].GUID == guid) {
            return i;
        }
    }
    return -1;
}

function array_search_internal_name(array, name) {
    for (var i = 0, n = array_length(array); i < n; i++) {
        if (array[i].internal_name == name) {
            return i;
        }
    }
    return -1;
}

function random_element_from_array(array) {
    if (array_length(array) == 0) return undefined;
    return array[irandom(array_length(array) - 1)];
}

function array_join(array, separator = " ") {
    static buffer_concat = buffer_create(1000, buffer_grow, 1);
    buffer_seek(buffer_concat, buffer_seek_start, 0);
    for (var i = 0, n = array_length(array); i < n; i++) {
        buffer_write(buffer_concat, buffer_text, array[i]);
        if (i < array_length(array) - 1)
            buffer_write(buffer_concat, buffer_text, separator);
    }
    buffer_write(buffer_concat, buffer_u8, 0);
    return buffer_peek(buffer_concat, 0, buffer_text);
}
#endregion

#region buffer stuff
function buffer_get_pixel(surface, buffer, x, y) {
    x = floor(x);
    y = floor(y);
    var sw = surface_get_width(surface);
    var sh = surface_get_height(surface);
    var offset = (y * sw + x) * 4;
    
    return buffer_peek(buffer, offset, buffer_u32) >> 8;
}

function buffer_sample(buffer, u, v, w, h, type = buffer_u32) {
    return buffer_sample_pixel(buffer, u * w, v * h, w, h, type);
}

function buffer_sample_pixel(buffer, x, y, w, h, type = buffer_u32) {
    // might implement texture wrapping some other day but right now i dont feel like it
    x = clamp(x, 0, w - 1);
    y = clamp(y, 0, h - 1);
    var address_ul = (floor(x) + floor(y) * w) * buffer_sizeof(type);
    var address_ur = (ceil(x) + floor(y) * w) * buffer_sizeof(type);
    var address_ll = (floor(x) + ceil(y) * w) * buffer_sizeof(type);
    var address_lr = (ceil(x) + ceil(y) * w) * buffer_sizeof(type);
    var horizontal_lerp = frac(x);
    var vertical_lerp = frac(y);
    var value_ul = buffer_peek(buffer, address_ul, type);
    var value_ur = buffer_peek(buffer, address_ur, type);
    var value_ll = buffer_peek(buffer, address_ll, type);
    var value_lr = buffer_peek(buffer, address_lr, type);
    var value_l = lerp(value_ul, value_ll, vertical_lerp);
    var value_r = lerp(value_ur, value_lr, vertical_lerp);
    return lerp(value_l, value_r, horizontal_lerp);
}

function buffer_read_buffer(source) {
    var length = buffer_read(source, buffer_u32);
    var sbuffer = buffer_create(length, buffer_fixed, 1);
    buffer_copy(source, buffer_tell(source), length, sbuffer, 0);
    buffer_seek(source, buffer_seek_relative, length);
    return sbuffer;
}

function buffer_read_sprite(buffer) {
    var sw = buffer_read(buffer, buffer_u16);
    var sh = buffer_read(buffer, buffer_u16);
    var surface = surface_create(sw, sh);
    var sbuffer = buffer_read_buffer(buffer); 
    
    buffer_set_surface(sbuffer, surface, 0);
    
    var sprite = sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);
    
    buffer_delete(sbuffer);
    surface_free(surface);
    
    return sprite;
}

function buffer_set_pixel(surface, buffer, x, y, color) {
    x = floor(x);
    y = floor(y);
    var sw = surface_get_width(surface);
    var sh = surface_get_height(surface);
    var offset = (y * sw + x) * 4;

    buffer_poke(buffer, offset, buffer_u32, 0x000000ff | (color << 8));
}

function buffer_write_buffer(to, from) {
    var size = buffer_get_size(from);
    buffer_write(to, buffer_u32, size);
    buffer_resize(to, buffer_get_size(to) + size);
    buffer_copy(from, 0, buffer_get_size(from), to, buffer_tell(to));
    buffer_seek(to, buffer_seek_relative, size);
}

// this is like buffer_write_buffer but it doesnt write the length or seek
// to the new position
function buffer_append_buffer(to, from) {
    var buffer_end = buffer_get_size(to);
    buffer_resize(to, buffer_get_size(to) + buffer_get_size(from));
    buffer_copy(from, 0, buffer_get_size(from), to, buffer_end);
}

function buffer_write_vertex_buffer(buffer, vbuff_data) {
    var formatted = meshops_vertex_formatted(vbuff_data, Game.meta.export.vertex_format);
    buffer_write_buffer(buffer, formatted);
    buffer_delete(formatted);
}

function buffer_write_sprite(buffer, sprite) {
    var surface = sprite_to_surface(sprite, 0);
    var sw = surface_get_width(surface);
    var sh = surface_get_height(surface);
    var slength = sw * sh * 4;
    
    var sbuffer = buffer_create(slength, buffer_fixed, 1);
    var size = buffer_get_size(sbuffer);
    buffer_get_surface(sbuffer, surface, 0);
    buffer_write(buffer, buffer_u16, sw);
    buffer_write(buffer, buffer_u16, sh);
    
    buffer_write_buffer(buffer, sbuffer);
    
    surface_free(surface);
    buffer_delete(sbuffer);
}

function buffer_clone(buffer, type = buffer_get_type(buffer), alignment = buffer_get_alignment(buffer)) {
    var new_buffer = buffer_create(buffer_get_size(buffer), type, alignment);
    buffer_copy(buffer, 0, buffer_get_size(buffer), new_buffer, 0);
    return new_buffer;
}

function buffer_write_file(str, filename) {
    static buffer = buffer_create(1000, buffer_grow, 1);
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_text, str);
    buffer_save_ext(buffer, filename, 0, buffer_tell(buffer));
}

function buffer_read_file(filename) {
    var data = buffer_load(filename);
    var str = buffer_read(data, buffer_string);
    buffer_delete(data);
    return str;
}

#region ds_list stuff
function ds_list_clear_instances(list) {
    // this was implemented some time into the project. there are probably
    // a couple destroy events that could use this but don't.
    var n = ds_list_size(list);
    
    for (var i = 0; i < n; i++) {
        var what = list[| i];
        if (what) {
            if (is_struct(what)) {
                what.Destroy();
            } else {
                instance_activate_object(what);
                instance_destroy(what);
            }
        }
    }
    
    ds_list_clear(list);
    
    return n;
}

function ds_list_destroy_instances(list) {
    ds_list_clear_instances(list);
    ds_list_destroy(list);
}

function ds_list_filter(list, f) {
    var selected_elements = [];
    for (var i = 0, n = ds_list_size(list); i < n; i++) {
        if (f(list[| i])) {
            array_push(selected_elements, list[| i]);
        }
    }
    return selected_elements;
}

function ds_list_to_array(list) {
    var array = array_create(ds_list_size(list));
    for (var i = 0; i < array_length(array); i++) {
        array[@ i] = list[| i];
    }
    return array;
}

function ds_list_top(list) {
    // for when you want to be using a stack, but need to
    // do stuff with it that you need a list for.
    return list[| ds_list_size(list) - 1];
}
#endregion