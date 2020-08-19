#region array stuff
function array_to_list(array) {
    var list = ds_list_create();
    for (var i = 0; i < array_length(argument0); i++) {
        ds_list_add(list, argument0[@ i]);
    }
    
    return list;
}

function array_clear(array, value) {
    for (var i = 0; i < array_length(array); i++) {
        array[@ i] = value;
    }
}
#endregion

#region buffer stuff
function buffer_get_datatype(version) {
    return (version >= DataVersions.ID_OVERHAUL) ? buffer_datatype : buffer_datatype_old;
}

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
    
    buffer_set_surface(sbuffer, surface, buffer_surface_copy, 0, 0);
    
    var sprite = sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);
    
    buffer_delete(sbuffer);
    surface_free(surface);
    
    return sprite;
}

/// @param surface
/// @param buffer
/// @param x
/// @param y
/// @param color
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

function buffer_write_sprite(buffer, sprite) {
    var surface = sprite_to_surface(sprite, 0);
    var sw = surface_get_width(surface);
    var sh = surface_get_height(surface);
    var slength = sw * sh * 4;
    
    var sbuffer = buffer_create(slength, buffer_fixed, 1);
    var size = buffer_get_size(sbuffer);
    buffer_get_surface(sbuffer, surface, buffer_surface_copy, 0, 0);
    buffer_write(buffer, buffer_u16, sw);
    buffer_write(buffer, buffer_u16, sh);
    
    buffer_write_buffer(buffer, sbuffer);
    
    surface_free(surface);
    buffer_delete(sbuffer);
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
            instance_activate_object(list[| i]);
            instance_destroy(list[| i]);
        }
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
        if (script_execute(value, lt, i) <= script_execute(value, rt, j)) {
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
        return list[| index].internal_name;
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
        return list[| index].name;
    }, l, r);
}

function ds_list_top(list) {
    // for when you want to be using a stack, but need to
    // do stuff with it that you need a list for.
    return list[| ds_list_size(list) - 1];
}
#endregion

#region ds_map stuff
function ds_map_to_list(map) {
    var list = ds_list_create();
    for (var i = ds_map_find_first(map); i != undefined; i = ds_map_find_next(map, i)) {
        ds_list_add(list, i);
    }
    return list;
}
#endregion