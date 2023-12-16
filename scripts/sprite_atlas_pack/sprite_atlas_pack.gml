/// Based on: https://jsfiddle.net/cey0nfux/
/// Explanation: https://gamedev.net/forums/topic/683912-sprite-packing-algorithm-explained-with-example-code/5320030/
function sprite_atlas_pack(sprite_array, padding, stride = 4) {
    enum SpritePackData {
        X = 0,
        Y = 4,
        W = 8,
        H = 12,
        SIZE = 16,
    };
    
    // each sprite is represented by four 4-byte floats
    var data_buffer = buffer_create(array_length(sprite_array) * 4 * 4, buffer_grow, 4);
    var sprite_lookup = __spal__setup(data_buffer, sprite_array, padding);
    var n = array_length(sprite_lookup);
    
    var maxx = 0;
    var maxy = 0;
    var nextx = 0;
    var nexty = 0;
    
    static place = function(data_buffer, index, maxx, maxy, stride) {
        var sprite_count = buffer_get_size(data_buffer) / 4 / 4;
        var xx = 0;
        repeat (maxx / stride) {
            var yy = 0;
            repeat (maxy / stride) {
                var is_free = true;
                
                var owplusstep = buffer_peek(data_buffer, index + SpritePackData.W, buffer_s32) + stride;
                var ohplusstep = buffer_peek(data_buffer, index + SpritePackData.H, buffer_s32) + stride;
                var i = 0;
                repeat (sprite_count) {
                    if (i != index) {
                        var tx = buffer_peek(data_buffer, i + SpritePackData.X, buffer_s32);
                        var ty = buffer_peek(data_buffer, i + SpritePackData.Y, buffer_s32);
                        var tw = buffer_peek(data_buffer, i + SpritePackData.W, buffer_s32);
                        var th = buffer_peek(data_buffer, i + SpritePackData.H, buffer_s32);
                        if (!((tx + tw + stride < xx) || (tx > xx + owplusstep) || (ty + th + stride < yy) || (ty > yy + ohplusstep))) {
                            is_free = false;
                            break;
                        }
                    }
                    i += 16;
                }
                
                if (is_free) {
                    buffer_poke(data_buffer, index + SpritePackData.X, buffer_s32, xx);
                    buffer_poke(data_buffer, index + SpritePackData.Y, buffer_s32, yy);
                    return true;
                }
                yy += stride;
            }
            xx += stride;
        }
        return false;
    };
    
    var i = 0;
    repeat (n) {
        var addr_x = i + SpritePackData.X;
        var addr_y = i + SpritePackData.Y;
        var ww = buffer_peek(data_buffer, i + SpritePackData.W, buffer_s32);
        var hh = buffer_peek(data_buffer, i + SpritePackData.H, buffer_s32);
        if (maxx == 0) {
            buffer_poke(data_buffer, addr_x, buffer_s32, 0);
            buffer_poke(data_buffer, addr_y, buffer_s32, 0);
            nextx += ww + 4;
        } else {
            if (!place(data_buffer, i, maxx, maxy, stride)) {
                if (nextx + ww > maxy) {
                    nexty = maxy;
                    nextx = 0;
                }
                buffer_poke(data_buffer, addr_x, buffer_s32, nextx);
                buffer_poke(data_buffer, addr_y, buffer_s32, nexty);
                nextx += ww + stride;
            }
        }
        
        maxx = max(maxx, buffer_peek(data_buffer, addr_x, buffer_s32) + ww + stride);
        maxy = max(maxy, buffer_peek(data_buffer, addr_y, buffer_s32) + hh + stride);
        i += 16;
    }
    
    var results = __spal__cleanup(data_buffer, sprite_lookup, padding, maxx, maxy);
    buffer_delete(data_buffer);
    return results;
}