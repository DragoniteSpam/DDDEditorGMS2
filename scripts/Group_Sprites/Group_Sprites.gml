#macro sprite_save sprite_save_fixed
#macro __sprite_add_old sprite_add
#macro sprite_add sprite_add_fixed
#macro sprite_delete sprite_delete_ext
#macro __sprite_delete_old sprite_delete

function sprite_add_fixed(filename, imagenum, removeback, smooth, xorig, yorig) {
    var sprite = __sprite_add_old(filename, imagenum, false, false, xorig, yorig);
    
    if (removeback) {
        for (var i = 0; i < sprite_get_number(sprite); i++) {
            var buffer = sprite_to_buffer(sprite, i);
            var sh = sprite_get_height(sprite);
            var sw = sprite_get_width(sprite);
            var addr_remove = (sh - 1) * sw * buffer_sizeof(buffer_u32);
            var color_remove = buffer_peek(buffer, addr_remove, buffer_u32) & 0x00ffffff;
            for (var j = 0; j < sw * sh; j++) {
                var addr = j * buffer_sizeof(buffer_u32);
                if ((buffer_peek(buffer, addr, buffer_u32) & 0x00ffffff) == color_remove) {
                    buffer_poke(buffer, addr, buffer_u32, 0x00000000);
                }
            }
            sprite_delete(sprite);
            sprite = sprite_from_buffer(buffer, sw, sh);
        }
    }
    
    return sprite;
}

function sprite_save_fixed(sprite, subimg, path) {
    // by yellowafterlife
    var t = sprite_to_surface(sprite, subimg);
    surface_save(t, path);
    surface_free(t);
}

function sprite_delete_ext(sprite) {
    for (var i = 0, n = sprite_get_number(sprite); i < n; i++) {
        sprite_sample_remove_from_cache(sprite, i);
    }
    __sprite_delete_old(sprite);
}

function sprite_to_buffer(sprite, subimg) {
    // by yellowafterlife
    var surface = sprite_to_surface(sprite, subimg);
    var buffer = buffer_create(sprite_get_width(sprite) * sprite_get_height(sprite) * 4, buffer_fixed, 1);
    buffer_get_surface(buffer, surface, 0);
    surface_free(surface);
    return buffer;
}

function sprite_from_buffer(buffer, w, h) {
    var surface = surface_create(w, h);
    buffer_set_surface(buffer, surface, 0);
    var sprite = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_free(surface);
    return sprite;
}

function sprite_to_surface(sprite, subimg) {
    // https://www.yoyogames.com/blog/60/alpha-and-surfaces
    var dd = surface_get_depth_disable();
    surface_depth_disable(true);
    var t = surface_create(sprite_get_width(sprite), sprite_get_height(sprite));
    surface_depth_disable(dd);
    surface_set_target(t);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendmode(bm_add);
    gpu_set_blendenable(false);
    draw_sprite(sprite, subimg, 0, 0);
    gpu_set_blendmode(bm_normal);
    gpu_set_blendenable(true);
    surface_reset_target();
    return t;
}

function sprite_from_surface(surface) {
    return sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_height(surface), false, false, 0, 0);
}

function sprite_crop(sprite, x, y, w, h) {
    var surface = surface_create(w, h);
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendmode(bm_add);
    draw_sprite(sprite, 0, -x, -y);
    gpu_set_blendmode(bm_normal);
    var cropped = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_reset_target();
    surface_free(surface);
    return cropped;
}

function sprite_get_cropped_dimensions(sprite, subimage = 0, cutoff = 0) {
    var buffer = sprite_to_buffer(sprite, 0);
    var sw = sprite_get_width(sprite);
    var sh = sprite_get_height(sprite);
    var ww = sw;
    var hh = sh;
    // horizontal
    for (var i = 0; i < sw; i++) {
        var xx = sw - i - 1;
        // assume the column is clear until proven otherwise
        ww = xx;
        var done = false;
        for (var j = 0; j < sh; j++) {
            // right to left
            var yy = j;
            var index = (yy * sw + xx) * 4;
            var alpha = buffer_peek(buffer, index + 3, buffer_u8);
            if (alpha > cutoff) {
                ww = xx + 1;
                done = true;
                break;
            }
        }
        if (done) {
            break;
        }
    }
    // vertical
    for (var i = 0; i < sh; i++) {
        var yy = sh - i - 1;
        // assume the column is clear until proven otherwise
        hh = yy;
        var done = false;
        for (var j = 0; j < sw; j++) {
            // right to left
            var xx = j;
            var index = (yy * sw + xx) * 4;
            var alpha = buffer_peek(buffer, index + 3, buffer_u8);
            if (alpha > cutoff) {
                hh = yy + 1;
                done = true;
                break;
            }
        }
        if (done) {
            break;
        }
    }
    buffer_delete(buffer);
    
    return new Vector2(ww, hh);
}

function sprite_remove_transparent_color(sprite, color = 0xff00ff) {
    var w = sprite_get_width(sprite);
    var h = sprite_get_height(sprite);
    var buffer = sprite_to_buffer(sprite, 0);
    var changed = false;
    for (var i = 0, len = buffer_get_size(buffer); i < len; i += 4) {
        if (buffer_peek(buffer, i, buffer_u32) & 0xffffff == color) {
            buffer_poke(buffer, i, buffer_u32, 0);
            changed = true;
        }
    }
    
    if (changed) {
        sprite_delete(sprite);
        sprite = sprite_from_buffer(buffer, w, h);
    }
    
    buffer_delete(buffer);
    
    return sprite;
}

function sprite_sample(sprite, index, u, v) {
    return sprite_sample_pixel(sprite, index, u * sprite_get_width(sprite), v * sprite_get_height(sprite));
}

function sprite_sample_pixel(sprite, index, x, y, cmd = "") {
    static cache = { };
    var sprite_id = string(sprite) + ";" + string(index);
    var buffer = cache[$ sprite_id];
    
    switch (cmd) {
        case "remove":
            if (buffer != undefined) {
                buffer_delete(buffer);
            }
            variable_struct_remove(cache, sprite_id);
            return;
        case "buffer":
            sprite_sample(sprite, index, 0, 0);     // ensure that it exists in the cache
            return cache[$ sprite_id];
    }
    
    if (buffer == undefined) {
        buffer = sprite_to_buffer(sprite, index);
        cache[$ sprite_id] = buffer;
    }
    
    return sprite_sample_buffer_pixel(buffer, x, y, sprite_get_width(sprite), sprite_get_height(sprite));
}

function sprite_sample_remove_from_cache(sprite, index) {
    sprite_sample_pixel(sprite, index, 0, 0, "remove");
}

function sprite_sample_get_buffer(sprite, index) {
    return sprite_sample_pixel(sprite, index, 0, 0, "buffer");
}

function sprite_sample_buffer(buffer, u, v, w, h) {
    return sprite_sample_buffer_pixel(buffer, u * w, v * h, w, h);
}

function sprite_sample_buffer_pixel(buffer, x, y, w, h) {
    // might implement texture wrapping some other day but right now i dont feel like it
    x = clamp(x, 0, w - 1);
    y = clamp(y, 0, h - 1);
    var address_ul = (floor(x) + floor(y) * w) * 4;
    var address_ur = (ceil(x) + floor(y) * w) * 4;
    var address_ll = (floor(x) + ceil(y) * w) * 4;
    var address_lr = (ceil(x) + ceil(y) * w) * 4;
    var horizontal_lerp = frac(x);
    var vertical_lerp = frac(y);
    var colour_ul = buffer_peek(buffer, address_ul, buffer_u32);
    var colour_ur = buffer_peek(buffer, address_ur, buffer_u32);
    var colour_ll = buffer_peek(buffer, address_ll, buffer_u32);
    var colour_lr = buffer_peek(buffer, address_lr, buffer_u32);
    var colour_l = merge_colour_ds(colour_ul, colour_ll, vertical_lerp);
    var colour_r = merge_colour_ds(colour_ur, colour_lr, vertical_lerp);
    return merge_colour_ds(colour_l, colour_r, horizontal_lerp);
}