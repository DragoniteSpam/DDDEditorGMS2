function meshops_export_d3d(filename, buffer) {
    // we'll estimate a max of 90 vertices per line, plus a kilobyte overhead
    static output = buffer_create(1024, buffer_fixed, 1);
    buffer_resize(output, max(buffer_get_size(output), 1024 + 90 * ((buffer_get_size(buffer) / VERTEX_SIZE) + 2)));
    // if you don't do something to the buffer in GameMaker land, it might
    // not actually be allocated when it gets to the dll
    buffer_fill(output, 0, buffer_f32, 0, buffer_get_size(output));
    var size = __meshops_export_d3d(buffer_get_address(buffer), buffer_get_size(buffer), buffer_get_address(output));
    buffer_save_ext(output, filename, 0, size);
}