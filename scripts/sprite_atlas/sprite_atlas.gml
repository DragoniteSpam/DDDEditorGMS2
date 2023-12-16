#macro SPRITE_ATLAS_DLL "SpriteAtlas.dll"
#macro SPRITE_ATLAS_CALLTYPE dll_cdecl
#macro SPRITE_ATLAS_VERSION "1.0.1"

function __spal__setup(data_buffer, sprite_array, padding) {
    var n = array_length(sprite_array);
    var sprite_lookup = [];
    
    array_sort(sprite_array, function(a, b) {
        return sprite_get_height(b) - sprite_get_height(a);
    });
    
    var i = 0;
    var count = 0;
    repeat (n) {
        var sprite = sprite_array[i];
        var sub = sprite_get_number(sprite);
        var j = 0;
        repeat (sub) {
            var ww = sprite_get_width(sprite) + 2 * padding;
            var hh = sprite_get_height(sprite) + 2 * padding;
            buffer_write(data_buffer, buffer_s32, 100 - sprite_get_width(sprite));
            buffer_write(data_buffer, buffer_s32, 100 - sprite_get_height(sprite));
            buffer_write(data_buffer, buffer_s32, ww);
            buffer_write(data_buffer, buffer_s32, hh);
            sprite_lookup[count++] = {
                spr: sprite,
                index: j++
            };
        }
        i++;
    }
    
    // final width
    buffer_write(data_buffer, buffer_s32, 0);
    // final height
    buffer_write(data_buffer, buffer_s32, 0);
    
    return sprite_lookup;
}

function __spal__cleanup(data_buffer, sprite_lookup, padding, maxx, maxy) {
    maxx = 1 << ceil(log2(maxx));
    maxy = 1 << ceil(log2(maxy));
    
    static warned = false;
    if (max(maxx, maxy) > 0x4000 && !warned) {
        warned = true;
        show_debug_message("Can't create an image larger than 16,384 in a dimension (0x4000), constraining");
        return undefined;
    }
    
    var surface_packed = surface_create(min(0x4000, maxx), min(0x4000, maxy));
    surface_set_target(surface_packed);
    draw_clear_alpha(c_black, 0);
    
    var bm = gpu_get_blendmode();
    gpu_set_blendmode(bm_add);
    var n = array_length(sprite_lookup);
    var index = 0;
    
    repeat (n) {
        var sprite = sprite_lookup[@ index].spr;
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
    
    var output_coordinates = array_create(n);
    var i = 0;
    repeat (n) {
        var data = sprite_lookup[i];
        output_coordinates[i] = {
            x: buffer_peek(data_buffer, i * SpritePackData.SIZE + SpritePackData.X, buffer_s32) + padding,
            y: buffer_peek(data_buffer, i * SpritePackData.SIZE + SpritePackData.Y, buffer_s32) + padding,
            w: buffer_peek(data_buffer, i * SpritePackData.SIZE + SpritePackData.W, buffer_s32) - 2 * padding,
            h: buffer_peek(data_buffer, i * SpritePackData.SIZE + SpritePackData.H, buffer_s32) - 2 * padding,
            sprite: data.spr,
            subimage: data.index
        };
        i++;
    }
    
    return {
        atlas: sprite_packed,
        uvs: output_coordinates,
    };
}