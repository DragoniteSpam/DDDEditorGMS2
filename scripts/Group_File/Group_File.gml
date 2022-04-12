function file_get_contents(filename) {
    var buffer = buffer_load(filename);
    var contents = buffer_read(buffer, buffer_text);
    buffer_delete(buffer);
    return contents;
}

function file_touch(filename) {
    buffer_write_file(filename, "");
}

function filename_abbreviated(filename, width) {
    if (string_width(filename) <= width) {
        return filename;
    } else {
        var prefix = string_copy(filename, 1, 10) + "...   ";
        var prefix_width = string_width(prefix);
        var text = "";
        for (var i = string_length(filename); i > 0; i--) {
            var next = string_char_at(filename, i) + text;
            if (string_width(next) > (width - prefix_width)) {
                return prefix + text;
                break;
            }
            text = next;
        }
        return prefix + text;
    }
}
