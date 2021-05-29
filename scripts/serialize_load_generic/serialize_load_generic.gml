function serialize_load_generic(buffer, data, version) {
    data.name = buffer_read(buffer, buffer_string);
    internal_name_set(data, buffer_read(buffer, buffer_string));
    data.flags = buffer_read(buffer, buffer_u32);
    guid_set(data, buffer_read(buffer, buffer_datatype));
    data.summary = buffer_read(buffer, buffer_string);
}