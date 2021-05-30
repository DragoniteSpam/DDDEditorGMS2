function serialize_save_header(buffer, file_data, is_base) {
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
    buffer_write(buffer, buffer_u8, is_base ? SERIALIZE_DATA_AND_MAP : SERIALIZE_ASSETS);
}