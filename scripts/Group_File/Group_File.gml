function file_get_contents(filename) {
    var buffer = buffer_load(filename);
    var contents = buffer_read(buffer, buffer_text);
    buffer_delete(buffer);
    return contents;
}

function file_write_text(filename, text) {
    static buffer = buffer_create(1024, buffer_grow, 1);
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_text, text);
    buffer_save_ext(buffer, filename, 0, buffer_tell(buffer));
}
}