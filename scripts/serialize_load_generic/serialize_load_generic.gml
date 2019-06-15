/// @param buffer
/// @param Data
/// @param version

argument1.name = buffer_read(argument0, buffer_string);

if (argument2 >= DataVersions.DATA_INTERNAL_NAME) {
    argument1.internal_name = buffer_read(argument0, buffer_string);
}

argument1.flags = buffer_read(argument0, buffer_u32);
guid_set(argument1, buffer_read(argument0, buffer_u32));
