/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

if (version >= DataVersions.DATA_CHUNK_ADDRESSES) {
    var addr_next = buffer_read(buffer, buffer_u64);
}

var n_maps = buffer_read(buffer, buffer_u16);

repeat (n_maps) {
    var map = instance_create_depth(0, 0, 0, DataMapContainer);
    serialize_load_generic(buffer, map, version);
    
    if (version >= DataVersions.MAP_VERSIONING) {
        map.version = buffer_read(buffer, buffer_u32);
    } else {
        map.version = version;
    }
    
    var size = buffer_read(buffer, buffer_u32);
    buffer_delete(map.data_buffer);
    map.data_buffer = buffer_read_buffer(buffer, size);
    
    if (buffer_md5(map.data_buffer, 0, buffer_get_size(buffer)) != EMPTY_BUFFER_MD5) {
        buffer_seek(map.data_buffer, buffer_seek_start, 0);
    
        buffer_read(map.data_buffer, buffer_datatype);
        // @todo when all of the map contents variables have been moved over to regular map
        //serialize_load_map_contents_meta(map.data_buffer, version, map);

        map.xx = buffer_read(map.data_buffer, buffer_u16);
        map.yy = buffer_read(map.data_buffer, buffer_u16);
        map.zz = buffer_read(map.data_buffer, buffer_u16);
    
        buffer_seek(map.data_buffer, buffer_seek_start, 0);
    } // else the map has not been initialized yet and it just uses its default values
}

load_a_map(guid_get(Stuff.game_starting_map));