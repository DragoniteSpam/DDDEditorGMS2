#region array stuff
function array_to_list(array) {
    var list = ds_list_create();
    for (var i = 0; i < array_length(array); i++) {
        ds_list_add(list, array[@ i]);
    }
    
    return list;
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

function array_search(array, value) {
    for (var i = 0; i < array_length(array); i++) {
        if (array[i] == value) return i;
    }
    return -1;
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
        return a.internal_name > b.internal_name;
    });
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

function buffer_read_buffer(source, length) {
    var sbuffer = buffer_create(length, buffer_fixed, 1);
    buffer_copy(source, buffer_tell(source), length, sbuffer, 0);
    buffer_seek(source, buffer_seek_relative, length);
    return sbuffer;
}

function buffer_read_sprite(buffer) {
    var sw = buffer_read(buffer, buffer_u16);
    var sh = buffer_read(buffer, buffer_u16);
    var slength = sw * sh * 4;
    var surface = surface_create(sw, sh);
    var sbuffer = buffer_read_buffer(buffer, slength); 
    
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
    buffer_resize(to, buffer_get_size(to) + size);
    buffer_copy(from, 0, buffer_get_size(from), to, buffer_tell(to));
    buffer_seek(to, buffer_seek_relative, size);
}

function buffer_write_vertex_buffer(buffer, vbuff_data) {
    if (Game.meta.export.vertex_format == DEFAULT_VERTEX_FORMAT) {
        buffer_write_buffer(buffer, vbuff_data);
    } else {
        buffer_seek(vbuff_data, buffer_seek_start, 0);
        for (var i = 0; i < buffer_get_size(vbuff_data); i += VERTEX_SIZE) {
            var xx = buffer_read(vbuff_data, buffer_f32);
            var yy = buffer_read(vbuff_data, buffer_f32);
            var zz = buffer_read(vbuff_data, buffer_f32);
            var nx = buffer_read(vbuff_data, buffer_f32);
            var ny = buffer_read(vbuff_data, buffer_f32);
            var nz = buffer_read(vbuff_data, buffer_f32);
            var xt = buffer_read(vbuff_data, buffer_f32);
            var yt = buffer_read(vbuff_data, buffer_f32);
            var cc = buffer_read(vbuff_data, buffer_u32);
            buffer_write(buffer, buffer_f32, xx);
            buffer_write(buffer, buffer_f32, yy);
            buffer_write(buffer, buffer_f32, zz);
            if (Game.meta.export.vertex_format & (1 << VertexFormatData.NORMAL)) {
                buffer_write(buffer, buffer_f32, nx);
                buffer_write(buffer, buffer_f32, ny);
                buffer_write(buffer, buffer_f32, nz);
            }
            if (Game.meta.export.vertex_format & (1 << VertexFormatData.TEXCOORD)) {
                buffer_write(buffer, buffer_f32, xt);
                buffer_write(buffer, buffer_f32, yt);
            }
            if (Game.meta.export.vertex_format & (1 << VertexFormatData.COLOUR)) {
                buffer_write(buffer, buffer_u32, cc);
            }
        }
    }
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

function buffer_clone(buffer, type, alignment) {
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

function buffer_dotobj_to_standard(poly_list) {
    var source = poly_list[eDotDaePolyList.VertexBuffer];
    var format_code = poly_list[eDotDaePolyList.FormatCode];
    var raw = buffer_create_from_vertex_buffer(source, buffer_fixed, 1);
    var vbuff = vertex_create_buffer();
    vertex_begin(vbuff, Stuff.graphics.vertex_format);
    
    if (format_code & DOTDAE_FORMAT_J) {
        repeat (vertex_get_number(source)) {
            var xx = buffer_read(raw, buffer_f32);
            var yy = buffer_read(raw, buffer_f32);
            var zz = buffer_read(raw, buffer_f32);
            var nx = buffer_read(raw, buffer_f32);
            var ny = buffer_read(raw, buffer_f32);
            var nz = buffer_read(raw, buffer_f32);
            var c = buffer_read(raw, buffer_u32);
            var xt = buffer_read(raw, buffer_f32);
            var yt = buffer_read(raw, buffer_f32);
            
            buffer_seek(raw, buffer_seek_relative, 32);
            
            vertex_position_3d(vbuff, xx, yy, zz);
            vertex_normal(vbuff, nx, ny, nz);
            vertex_texcoord(vbuff, xt, yt);
            vertex_colour(vbuff, c & 0x00ffffff, (c >> 24) / 0xff);
        }
    } else {
        //repeat (vertex_get_number(source)) {
        repeat (buffer_get_size(raw) / 36) {
            var xx = buffer_read(raw, buffer_f32);
            var yy = buffer_read(raw, buffer_f32);
            var zz = buffer_read(raw, buffer_f32);
            var nx = buffer_read(raw, buffer_f32);
            var ny = buffer_read(raw, buffer_f32);
            var nz = buffer_read(raw, buffer_f32);
            var c = buffer_read(raw, buffer_u32);
            var xt = buffer_read(raw, buffer_f32);
            var yt = buffer_read(raw, buffer_f32);
            
            vertex_position_3d(vbuff, xx, yy, zz);
            vertex_normal(vbuff, nx, ny, nz);
            vertex_texcoord(vbuff, xt, yt);
            vertex_colour(vbuff, c & 0x00ffffff, (c >> 24) / 0xff);
        }
    }
    
    vertex_end(vbuff);
    buffer_delete(raw);
    
    return vbuff;
}
#endregion

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

function ds_list_clear_disposable(list) {
    // this was implemented some time into the project. there are probably
    // a couple destroy events that could use this but don't.
    var n = ds_list_size(list);
    
    for (var i = 0; i < n; i++) {
        var what = list[| i];
        if (what) what.Destroy();
    }
    
    ds_list_clear(list);
    
    return n;
}

function ds_list_clone(source) {
    // this doesn't really do anything special, it just makes ds_list_copy
    // slightly shorter
    
    var list = ds_list_create();
    ds_list_copy(list, source);
    
    return list;
}

function ds_list_destroy_instances(list) {
    ds_list_clear_instances(list);
    ds_list_destroy(list);
}

function ds_list_destroy_instances_indirect(list) {
    // because there are some instances which automatically remove themselves
    // from the list that you want to pass to this script, and doing this the
    // easy way will cause the program to break
    var n = ds_list_size(list);
    var pending = ds_list_create();
    ds_list_copy(pending, list);
    for (var i = 0; i < ds_list_size(pending); i++) {
        instance_activate_object(pending[| i]);
        instance_destroy(pending[| i]);
    }
    ds_list_destroy(pending);
    ds_list_destroy(list);
    
    return n;
}

function ds_list_pop(list) {
    // for when you want to be using a stack, but need to
    // do stuff with it that you need a list for.
    var n = ds_list_size(list) - 1;
    var value = list[| n];
    ds_list_delete(list, n);
    return value;
}
/// @param list
/// @param [value-get]
/// @param [l]
/// @param [r]
function ds_list_sort_fast() {
    // sorts by data.name instead of data
    var list = argument[0];
    var value = (argument_count > 1 && argument[1] != undefined) ? argument[1] : function(list, index) { return list[| index].internal_name; };
    var l = (argument_count > 2) ? argument[2] : 0;
    var r = (argument_count > 3) ? argument[3] : ds_list_size(list) - 1;
    
    if (l < r) {
        var m = (l + r) div 2;
        ds_list_sort_fast(list, value, l, m);
        ds_list_sort_fast(list, value, m + 1, r);
        ds_list_sort_fast__merge(list, l, m, r, value);
    }
    
    return list;
}

function ds_list_sort_fast__merge(list, l, m, r, value) {
    var n1 = m - l + 1;
    var n2 = r - m;
    var lt = ds_list_create();
    var rt = ds_list_create();
    
    for (var i = 0; i < n1; i++) {
        // this should technically be a ds_list_add but whatever
        lt[| i] = list[| l +i ];
    }
    for (var j = 0; j < n2; j++) {
        // ditto
        rt[| j] = list[| m + j + 1];
    }
    
    var i = 0;
    var j = 0;
    var k = l;
    
    while (i < n1 && j < n2) {
        if (value(lt, i) <= value(rt, j)) {
            list[| k++] = lt[| i++];
        } else {
            list[| k++] = rt[| j++];
        }
    }
    
    while (i < n1) {
        list[| k++] = lt[| i++];
    }
    while (j < n2) {
        list[| k++] = rt[| j++];
    }
    
    ds_list_destroy(lt);
    ds_list_destroy(rt);
}

/// @param list
/// @param [l]
/// @param [r]
function ds_list_sort_internal() {
    // sorts by data.name instead of data
    var list = argument[0];
    var l = (argument_count > 1) ? argument[1] : 0;
    var r = (argument_count > 2) ? argument[2] : ds_list_size(list) - 1;
    return ds_list_sort_fast(list, function(list, index) {
        return string_lower(list[| index].internal_name);
    }, l, r);
}

/// @param list
/// @param [l]
/// @param [r]
function ds_list_sort_name() {
    // sorts by data.name instead of data
    var list = argument[0];
    var l = (argument_count > 1) ? argument[1] : 0;
    var r = (argument_count > 2) ? argument[2] : ds_list_size(list) - 1;
    
    return ds_list_sort_fast(list, function(list, index) {
        return string_lower(list[| index].name);
    }, l, r);
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

#region ds_map stuff
function ds_map_to_array(map) {
    var array = array_create(ds_map_size(map));
    var index = 0;
    for (var i = ds_map_find_first(map); i != undefined; i = ds_map_find_next(map, i)) {
        array[index++] = i;
    }
    return array;
}

function ds_map_to_list(map) {
    var list = ds_list_create();
    for (var i = ds_map_find_first(map); i != undefined; i = ds_map_find_next(map, i)) {
        ds_list_add(list, i);
    }
    return list;
}
#endregion