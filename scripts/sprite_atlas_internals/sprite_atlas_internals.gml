#macro SPRITE_ATLAS_DLL "SpriteAtlas.dll"
#macro SPRITE_ATLAS_CALLTYPE dll_cdecl
#macro SPRITE_ATLAS_VERSION "1.1.0"

enum SpritePackData {
    X = 0,
    Y = 4,
    W = 8,
    H = 12,
    SIZE = 16,
};

function __spal__setup(data_buffer, sprite_array, padding, force_power_of_two) {
    var sprite_count = array_length(sprite_array);
    var sprite_lookup = array_create(sprite_count);
    
    var area = 0;
    var max_sprite_width = 0;
    
    // this array may grow if some sprites have more than one frame
    for (var i = 0; i < sprite_count; i++) {
        var sprite = sprite_array[i];
        var presented_width = sprite_get_width(sprite) + 2 * padding;
        var presented_height = sprite_get_height(sprite) + 2 * padding;
        max_sprite_width = max(max_sprite_width, presented_width);
        var frames = sprite_get_number(sprite);
        area += frames * presented_width * presented_height;
        for (var j = 0; j < frames; j++) {
            sprite_lookup[i] = {
                sprite: sprite,
                index: j,
                w: presented_width,
                h: presented_height
            };
        }
    }
    
    array_sort(sprite_lookup, function(a, b) {
        return sign(b.h - a.h);
    });
    
    var max_width = max(ceil(sqrt(area)), max_sprite_width);
    if (force_power_of_two) {
        max_width = power(2, ceil(log2(max_width)));
    }
    
    var i = 0;
    var count = 0;
    repeat (array_length(sprite_lookup)) {
        var sprite = sprite_lookup[i++].sprite;
        var ww = sprite_get_width(sprite) + 2 * padding;
        var hh = sprite_get_height(sprite) + 2 * padding;
        buffer_write(data_buffer, buffer_s32, -1);
        buffer_write(data_buffer, buffer_s32, -1);
        buffer_write(data_buffer, buffer_s32, ww);
        buffer_write(data_buffer, buffer_s32, hh);
    }
    
    // target width
    buffer_write(data_buffer, buffer_s32, max_width);
    // final height
    buffer_write(data_buffer, buffer_s32, 0);
    
    buffer_resize(data_buffer, buffer_tell(data_buffer));
    
    return sprite_lookup;
}

function __spal__cleanup(data_buffer, sprite_lookup, padding, maxx, maxy, force_power_of_two) {
    static warned = false;
    if (max(maxx, maxy) > 0x4000 && !warned) {
        warned = true;
        show_debug_message("Can't create an image larger than 16,384 in a dimension (0x4000), constraining");
        return undefined;
    }
    
    maxx = min(0x4000, maxx);
    maxy = min(0x4000, maxy);
    
    var base_height = maxy;
    if (force_power_of_two) {
        maxy = power(2, ceil(log2(maxy)));
    }
    
    var surface_packed = surface_create(maxx, maxy);
    surface_set_target(surface_packed);
    draw_clear_alpha(c_black, 0);
    
    var bm = gpu_get_blendmode();
    gpu_set_blendmode(bm_add);
    var n = array_length(sprite_lookup);
    var index = 0;
    
    repeat (n) {
        var sprite = sprite_lookup[@ index].sprite;
        var sub = sprite_lookup[index].index;
        var i = index++ * 16;
        var xx = buffer_peek(data_buffer, i + SpritePackData.X, buffer_s32);
        var yy = buffer_peek(data_buffer, i + SpritePackData.Y, buffer_s32);
        
        if (padding > 0) {
            draw_sprite_general(sprite, sub, 0, 0, sprite_get_width(sprite), 1, xx + padding, yy, 1, padding, 0, c_white, c_white, c_white, c_white, 1);
            draw_sprite_general(sprite, sub, 0, 0, 1, sprite_get_height(sprite), xx, yy + padding, padding, 1, 0, c_white, c_white, c_white, c_white, 1);
            draw_sprite_general(sprite, sub, 0, sprite_get_height(sprite) - 1, sprite_get_width(sprite), 1, xx + padding, yy + padding + sprite_get_height(sprite), 1, padding, 0, c_white, c_white, c_white, c_white, 1);
            draw_sprite_general(sprite, sub, sprite_get_width(sprite) - 1, 0, 1, sprite_get_height(sprite), xx + padding + sprite_get_width(sprite), yy + padding, padding, 1, 0, c_white, c_white, c_white, c_white, 1);
        }
        draw_sprite_ext(sprite, sub, xx + padding, yy + padding, 1, 1, 0, c_white, 1);
    }
    gpu_set_blendmode(bm);
    
    surface_reset_target();
    
    var sprite_packed = sprite_create_from_surface(surface_packed, 0, 0, maxx, maxy, false, 0, 0, 0);
    surface_free(surface_packed);
    
    var i = 0;
    repeat (n) {
        var data = sprite_lookup[i];
        data.x = buffer_peek(data_buffer, i * SpritePackData.SIZE + SpritePackData.X, buffer_s32) + padding;
        data.y = buffer_peek(data_buffer, i * SpritePackData.SIZE + SpritePackData.Y, buffer_s32) + padding;
        i++;
    }
    
    return {
        base_width: maxx,
        base_height: base_height,
        atlas: sprite_packed,
        uvs: sprite_lookup,
    };
}