function meshops_export_d3d(filename, buffer) {
    // we'll estimate a max of 144 characters per line, plus a kilobyte overhead
    // estimating the number of characters it takes to represent a vertex can
    // be tricky, but the values are formatted to 6 decimal places, plus a
    // leading "0.,", optionally a -, and (for the same of argument) the three
    // position coordinates might have up to 6 decimal places
    // 144 characters should be plenty of extra space, in order to prevent the
    // file writer from overflowing the buffer and crashing the editor
    static output = buffer_create(1024, buffer_fixed, 1);
    buffer_resize(output, max(buffer_get_size(output), 1024 + 144 * ((buffer_get_size(buffer) / VERTEX_SIZE) + 2)));
    // if you don't do something to the buffer in GameMaker land, it might
    // not actually be allocated when it gets to the dll
    buffer_fill(output, 0, buffer_f32, 0, buffer_get_size(output));
    var size = __meshops_export_d3d(buffer_get_address(buffer), buffer_get_size(buffer), buffer_get_address(output));
    buffer_save_ext(output, filename, 0, size);
    // if the buffer takes up a significant amount of space, shrink it back down
    // so that it's not sitting here getting in the way
    if (buffer_get_size(output) > 0x200000) {
        buffer_resize(output, 0x200000);
    }
}

function meshops_vertex_formatted(buffer, format) {
    var output = buffer_create(buffer_get_size(buffer), buffer_fixed, 1);
    buffer_fill(output, 0, buffer_u32, 0, buffer_get_size(buffer));
    var length = __meshops_vertex_formatted(buffer_get_address(buffer), buffer_get_address(output), buffer_get_size(buffer), format);
    buffer_resize(output, length);
    return output;
}