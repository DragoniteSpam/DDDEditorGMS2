/// @param UIButton

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var data = list.entries[| selection];
    var buffer = sprite_to_buffer(data.picture, 0);
    var sw = sprite_get_width(data.picture);
    var sh = sprite_get_height(data.picture);
    var ww = sw;
    var hh = sh;
    // @todo implement a cutoff alpha value
    var cutoff = 127;
    // @todo implement a value to round to
    var round_to = 16;
    // horizontal
    for (var i = 0; i < sw; i++) {
        var xx = sw - i - 1;
        // assume the column is clear until proven otherwise
        ww = xx;
        var done = false;
        for (var j = 0; j < sh; j++) {
            // right to left
            var yy = j;
            var index = (xx * sh + yy) * 4;
            var alpha = buffer_peek(buffer, index + 3, buffer_u8);
            if (alpha >= cutoff) {
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
            var index = (xx * sh + yy) * 4;
            var alpha = buffer_peek(buffer, index + 3, buffer_u8);
            if (alpha >= cutoff) {
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
    data.width = round_ext(ww, round_to);
    data.height = round_ext(hh, round_to);
    list.root.el_dim_x.value = string(data.width);
    list.root.el_dim_y.value = string(data.height);
}