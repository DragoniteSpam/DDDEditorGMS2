function buffer_text_write_real(_file_handle, _real) {
    buffer_text_write_string(_file_handle, string(_real) + " ");
}