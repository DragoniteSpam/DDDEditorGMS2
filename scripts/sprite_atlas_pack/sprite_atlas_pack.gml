function sprite_atlas_pack(sprites, padding, stride = 4, force_power_of_two = true) {
    var sprite_count = array_length(sprites);
    var sprite_info = array_create(sprite_count);
    
    var area = 0;
    var max_sprite_width = 0;
    
    // this array may grow if some sprites have more than one frame
    for (var i = 0; i < sprite_count; i++) {
        var sprite = sprites[i];
        var presented_width = sprite_get_width(sprite) + 2 * padding;
        var presented_height = sprite_get_height(sprite) + 2 * padding;
        max_sprite_width = max(max_sprite_width, presented_width);
        var frames = sprite_get_number(sprite);
        area += frames * presented_width * presented_height;
        for (var j = 0; j < frames; j++) {
            sprite_info[i] = {
                sprite: sprite,
                index: j,
                x: 0,
                y: 0,
                w: presented_width,
                h: presented_height
            };
        }
    }
    
    array_sort(sprite_info, function(a, b) {
        return sign(b.h - a.h);
    });
    
    var max_width = max(sqrt(area), max_sprite_width);
    if (force_power_of_two) {
        max_width = power(2, ceil(log2(max_width)));
    }
    var max_height = 0;
    
    for (var i = 0; i < sprite_count; i++) {
        var sprite = sprite_info[i];
        var sprite_inst = instance_create_depth(0, 0, 0, obj_sprite_atlas_placeholder, {
            image_xscale: sprite.w,
            image_yscale: sprite.h
        });
        
        var limit = max_width - sprite.w;
        var yy = 0;
        while (true) {
            var placed = false;
            for (var xx = 0; xx <= limit; xx += stride) {
                with (sprite_inst) {
                    if (!place_meeting(xx, yy, obj_sprite_atlas_placeholder)) {
                        sprite.x = xx;
                        sprite.y = yy;
                        max_height = max(max_height, sprite.y + sprite.h);
                        sprite_inst.x = xx;
                        sprite_inst.y = yy;
                        placed = true;
                    }
                }
                if (placed) {
                    break;
                }
            }
            
            // i really wish gm had multi-level break
            if (placed) {
                break;
            }
            
            yy += stride;
        }
    }
    
    instance_destroy(obj_sprite_atlas_placeholder);
    
    var base_height = max_height;
    if (force_power_of_two) {
        max_height = power(2, ceil(log2(max_height)));
    }
    var atlas = surface_create(max_width, max_height);
    
    surface_set_target(atlas);
    draw_clear_alpha(c_black, 0);
    
    for (var i = 0; i < sprite_count; i++) {
        var sprite = sprite_info[i];
        
        var xx = sprite.x;
        var yy = sprite.y;
        
        var spr = sprite.sprite;
        var sub = sprite.index;
        var w = sprite_get_width(spr);
        var h = sprite_get_height(spr);
        draw_sprite(spr, sub, xx + padding, yy + padding);
        
        if (padding > 0) {
            draw_sprite_general(spr, sub, 0, 0, w, 1, xx + padding, yy, 1, padding, 0, c_white, c_white, c_white, c_white, 1);
            draw_sprite_general(spr, sub, 0, 0, 1, h, xx, yy + padding, padding, 1, 0, c_white, c_white, c_white, c_white, 1);
            draw_sprite_general(spr, sub, 0, h - 1, w, 1, xx + padding, yy + padding + h, 1, padding, 0, c_white, c_white, c_white, c_white, 1);
            draw_sprite_general(spr, sub, w - 1, 0, 1, h, xx + padding + w, yy + padding, padding, 1, 0, c_white, c_white, c_white, c_white, 1);
        }
    }
    
    surface_reset_target();
    
    var sprite = sprite_create_from_surface(atlas, 0, 0, max_width, max_height, false, false, 0, 0);
    surface_free(atlas);
    
    return {
        base_width: max_width,
        base_height: base_height,
        uvs: sprite_info,
        atlas: sprite
    }
}