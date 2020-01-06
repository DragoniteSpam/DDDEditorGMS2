event_inherited();

var location = get_temp_code_path(id);
if (file_exists(location)) {
    file_delete(location);
}