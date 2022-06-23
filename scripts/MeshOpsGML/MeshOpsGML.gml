function meshops_get_bounds(buffer) {
    static output = buffer_create(24, buffer_fixed, 4);
    __meshops_get_bounds(buffer_get_address(buffer), buffer_get_address(output), buffer_get_size(buffer));
    var data = new BoundingBox(
        buffer_peek(output,  0, buffer_f32),
        buffer_peek(output,  4, buffer_f32),
        buffer_peek(output,  8, buffer_f32),
        buffer_peek(output, 12, buffer_f32),
        buffer_peek(output, 16, buffer_f32),
        buffer_peek(output, 20, buffer_f32),
    );
    return data;
}

function meshops_chunk_settings(chunk_size, startx, starty, endx, endy) {
    __meshops_chunk_settings(chunk_size, startx, starty, endx, endy);
}

function meshops_chunk_analyze(data, meta) {
    __meshops_chunk_analyze(buffer_get_address(data), buffer_get_address(meta), buffer_get_size(data), buffer_get_size(meta));
}

function meshops_chunk(data, meta) {
    __meshops_chunk(buffer_get_address(data), buffer_get_address(meta), buffer_get_size(data));
}

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
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
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
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    var length = __meshops_vertex_formatted(buffer_get_address(buffer), buffer_get_address(output), buffer_get_size(buffer), format);
    buffer_resize(output, length);
    return output;
}