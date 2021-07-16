function sprite_get_cropped_dimensions(sprite, subimage, cutoff) {
    if (subimage == undefined) subimage = 0;
    if (cutoff == undefined) cutoff = 0;
    
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
    
    return new vec2(ww, hh);
}