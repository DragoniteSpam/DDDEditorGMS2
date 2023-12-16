/// Based on: https://jsfiddle.net/cey0nfux/
/// Explanation: https://gamedev.net/forums/topic/683912-sprite-packing-algorithm-explained-with-example-code/5320030/
function sprite_atlas_pack(sprite_array, padding, borders) {
    enum SpritePackData {
        X = 0,
        Y = 4,
        W = 8,
        H = 12,
        SIZE = 16,
    };
    
    var data_buffer = buffer_create(array_length(sprite_array) << 4, buffer_grow, 4);
    var sprite_lookup = __spal__setup(data_buffer, sprite_array, padding);
    var n = array_length(sprite_lookup);
    
    var maxx = 0;
    var maxy = 0;
    var nextx = 0;
    var nexty = 0;
    
    static place = function(data_buffer, index, maxx, maxy) {
        static collides = function(data_buffer, index, x, y) {
            var ow = buffer_peek(data_buffer, index + SpritePackData.W, buffer_s32);
            var oh = buffer_peek(data_buffer, index + SpritePackData.H, buffer_s32);
            var i = 0;
            repeat (buffer_get_size(data_buffer) >> 4) {
                if (i != index) {
                    var xx = buffer_peek(data_buffer, i + SpritePackData.X, buffer_s32);
                    var yy = buffer_peek(data_buffer, i + SpritePackData.Y, buffer_s32);
                    var ww = buffer_peek(data_buffer, i + SpritePackData.W, buffer_s32);
                    var hh = buffer_peek(data_buffer, i + SpritePackData.H, buffer_s32);
                    if (!((xx + ww + 4 < x) || (xx > x + ow + 4) || (yy + hh + 4 < y) || (yy > y + oh + 4))) return true;
                }
                i += 16;
            }
            return false;
        };
        
        var xx = 0;
        repeat (maxx >> 2) {
            var yy = 0;
            repeat (maxx >> 2) {
                if (!collides(data_buffer, index, xx, yy)) {
                    buffer_poke(data_buffer, index + SpritePackData.X, buffer_s32, xx);
                    buffer_poke(data_buffer, index + SpritePackData.Y, buffer_s32, yy);
                    return true;
                }
                yy += 4;
            }
            xx += 4;
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
            if (!place(data_buffer, i, maxx, maxy)) {
                if (nextx + ww > maxy) {
                    nexty = maxy;
                    nextx = 0;
                }
                buffer_poke(data_buffer, addr_x, buffer_s32, nextx);
                buffer_poke(data_buffer, addr_y, buffer_s32, nexty);
                nextx += ww + 4;
            }
        }
        
        maxx = max(maxx, buffer_peek(data_buffer, addr_x, buffer_s32) + ww + 4);
        maxy = max(maxy, buffer_peek(data_buffer, addr_y, buffer_s32) + hh + 4);
        i += 16;
    }
    
    var results = __spal__cleanup(data_buffer, sprite_lookup, padding, maxx, maxy);
    buffer_delete(data_buffer);
    return results;
}