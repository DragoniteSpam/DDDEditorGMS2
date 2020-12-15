function get_temp_text_path(code) {
    return PATH_TEMP + string(code.id) + FILE_TEXT_EXTENSION;
}

function get_temp_code_path(code) {
    return PATH_TEMP + string(code.id) + FILE_CODE_EXTENSION;
}