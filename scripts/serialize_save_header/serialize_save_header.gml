/// @param buffer
/// @param file-data
/// @param is-base?
function serialize_save_header(argument0, argument1, argument2) {

    var buffer = argument0;
    var file_data = argument1;
    var is_base = argument2;

    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
    buffer_write(buffer, buffer_u8, is_base ? SERIALIZE_DATA_AND_MAP : SERIALIZE_ASSETS);

    if (is_base) {
        buffer_write(buffer, buffer_string, Stuff.game_file_summary);
        buffer_write(buffer, buffer_string, Stuff.game_file_author);
        buffer_write(buffer, buffer_u16, current_year);
        buffer_write(buffer, buffer_u8, current_month);
        buffer_write(buffer, buffer_u8, current_day);
        buffer_write(buffer, buffer_u8, current_hour);
        buffer_write(buffer, buffer_u8, current_minute);
        buffer_write(buffer, buffer_u8, current_second);
    }


}
