/// @param buffer
/// @param version
/// @param DataMapContainer

var buffer = argument0;
var version = argument1;
var map = argument2;
var map_contents = map.contents;

version = map.version;

map.tiled_map_id = buffer_read(buffer, buffer_s32);
var xx = buffer_read(buffer, buffer_u16);
var yy = buffer_read(buffer, buffer_u16);
var zz = buffer_read(buffer, buffer_u16);
data_resize_map(map, xx, yy, zz);

map.tileset =                   buffer_read(buffer, buffer_get_datatype(version));
map.fog_start =                 buffer_read(buffer, buffer_f32);
map.fog_end =                   buffer_read(buffer, buffer_f32);
map.fog_colour =                buffer_read(buffer, buffer_u32);
map.base_encounter_rate =       buffer_read(buffer, buffer_u32);
map.base_encounter_deviation =  buffer_read(buffer, buffer_u32);
map.water_level =               buffer_read(buffer, buffer_f32);
map.light_ambient_colour =      buffer_read(buffer, buffer_u32);
if (version >= DataVersions.MAP_SKYBOX_DATA) {
    map.skybox =  buffer_read(buffer, buffer_datatype);
}
if (version >= DataVersions.MAP_ENTITY_CHUNKS) {
    map.map_chunk_size = buffer_read(buffer, buffer_u16);
}

var bools =                     buffer_read(buffer, buffer_u32);
map.indoors =                   unpack(bools, 0);
map.draw_water =                unpack(bools, 1);
map.fast_travel_to =            unpack(bools, 2);
map.fast_travel_from =          unpack(bools, 3);
map.is_3d =                     unpack(bools, 4);
map.fog_enabled =               unpack(bools, 5);
map.on_grid =                   unpack(bools, 6);
map.reflections_enabled =       unpack(bools, 7);
if (version >= DataVersions.MAP_PLAYER_LIGHT) {
    map.light_player_enabled =  unpack(bools, 8);
}
map.light_enabled =             unpack(bools, 9);

map.code =                      buffer_read(buffer, buffer_string);

#region autotiles
var at_count = buffer_read(buffer, buffer_u16);

for (var i = 0; i < at_count; i++) {
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var size = buffer_read(buffer, buffer_u32);
        map_contents.mesh_autotiles_top_raw[i] = buffer_read_buffer(buffer, size);
        map_contents.mesh_autotiles_top[i] = vertex_create_buffer_from_buffer(map_contents.mesh_autotiles_top_raw[i], Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.mesh_autotiles_top[i]);
    }
}

for (var i = 0; i < at_count; i++) {
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var size = buffer_read(buffer, buffer_u32);
        map_contents.mesh_autotiles_vertical_raw[i] = buffer_read_buffer(buffer, size);
        map_contents.mesh_autotiles_vertical[i] = vertex_create_buffer_from_buffer(map_contents.mesh_autotiles_vertical_raw[i], Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.mesh_autotiles_vertical[i]);
    }
}

for (var i = 0; i < at_count; i++) {
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var size = buffer_read(buffer, buffer_u32);
        map_contents.mesh_autotiles_base_raw[i] = buffer_read_buffer(buffer, size);
        map_contents.mesh_autotiles_base[i] = vertex_create_buffer_from_buffer(map_contents.mesh_autotiles_base_raw[i], Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.mesh_autotiles_base[i]);
    }
}

for (var i = 0; i < at_count; i++) {
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var size = buffer_read(buffer, buffer_u32);
        map_contents.mesh_autotiles_slope_raw[i] = buffer_read_buffer(buffer, size);
        map_contents.mesh_autotiles_slope[i] = vertex_create_buffer_from_buffer(map_contents.mesh_autotiles_slope_raw[i], Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.mesh_autotiles_slope[i]);
    }
}
#endregion

#region generic data
var n_generic = buffer_read(buffer, buffer_u8);
repeat (n_generic) {
    var data = instance_create_depth(0, 0, 0, DataAnonymous);
    
    data.name = buffer_read(buffer, buffer_string);
    data.type = buffer_read(buffer, buffer_u8);
    
    switch (data.type) {
        case DataTypes.INT: data.value_int = buffer_read(buffer, buffer_s32); break;
        case DataTypes.FLOAT: data.value_real = buffer_read(buffer, buffer_f32); break;
        case DataTypes.STRING: data.value_string = buffer_read(buffer, buffer_string); break;
        case DataTypes.BOOL: data.value_bool = buffer_read(buffer, buffer_u8); break;
        case DataTypes.CODE: data.value_code = buffer_read(buffer, buffer_string); break;
        case DataTypes.COLOR: data.value_color = buffer_read(buffer, buffer_u32); break;
        
        case DataTypes.ENUM:
        case DataTypes.DATA:
            data.value_type_guid = buffer_read(buffer, buffer_get_datatype(version));
            data.value_data = buffer_read(buffer, buffer_get_datatype(version));
            break;
        
        case DataTypes.MESH:
        case DataTypes.IMG_TEXTURE:
        case DataTypes.AUDIO_BGM:
        case DataTypes.AUDIO_SE:
        case DataTypes.ANIMATION:
        case DataTypes.MAP:
        case DataTypes.IMG_BATTLER:
        case DataTypes.IMG_OVERWORLD:
        case DataTypes.IMG_PARTICLE:
        case DataTypes.IMG_UI:
        case DataTypes.IMG_SKYBOX:
        case DataTypes.IMG_TILE_ANIMATION:
        case DataTypes.IMG_ETC:
        case DataTypes.EVENT:
        case DataTypes.ENTITY:
            data.value_data = buffer_read(buffer, buffer_get_datatype(version));
            break;
        
        case DataTypes.TILE: not_yet_implemented(); break;
    }
    
    ds_list_add(map.generic_data, data);
}
#endregion

var n_lights = buffer_read(buffer, buffer_u16);
ds_list_clear(map_contents.active_lights);
repeat (n_lights) {
    var data = buffer_read(buffer, buffer_get_datatype(version));
    if (ds_list_size(map_contents.active_lights) < MAX_LIGHTS) {
        ds_list_add(map_contents.active_lights, data);
    }
}