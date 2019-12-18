/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

entity.name = buffer_read(buffer, buffer_string);
entity.xx = buffer_read(buffer, buffer_u32);
entity.yy = buffer_read(buffer, buffer_u32);
entity.zz = buffer_read(buffer, buffer_u32);
refid_set(entity, buffer_read(buffer, buffer_u32));

var state_solid = entity.am_solid;
var state_static = entity.static;

var entity_bools = buffer_read(buffer, buffer_u32);
entity.am_solid = unpack(entity_bools, 0);
entity.static = unpack(entity_bools, 1);
entity.animate_idle = unpack(entity_bools, 2);
entity.animate_movement = unpack(entity_bools, 3);
entity.direction_fix = unpack(entity_bools, 4);
entity.reset_position = unpack(entity_bools, 5);

// meshes and pawns are solid by default, so if the state of their
// solidness changes, this needs to be reflected in the map stats counter
if (state_solid && !entity.am_solid) {
    Stuff.map.active_map.contents.population_solid--;
} else if (!state_solid && entity.am_solid) {
    Stuff.map.active_map.contents.population_solid++;
}

// same for statics
if (state_static && !entity.static) {
    Stuff.map.active_map.contents.population_static--;
} else if (!state_static && entity.static) {
    Stuff.map.active_map.contents.population_static++;
}

var n_events = buffer_read(buffer, buffer_u8);
repeat (n_events) {
    serialize_load_entity_event_page(buffer, entity, version);
}

entity.off_xx = buffer_read(buffer, buffer_f32);
entity.off_yy = buffer_read(buffer, buffer_f32);
entity.off_zz = buffer_read(buffer, buffer_f32);
    
entity.rot_xx = buffer_read(buffer, buffer_u16);
entity.rot_yy = buffer_read(buffer, buffer_u16);
entity.rot_zz = buffer_read(buffer, buffer_u16);
    
entity.scale_xx = buffer_read(buffer, buffer_f32);
entity.scale_yy = buffer_read(buffer, buffer_f32);
entity.scale_zz = buffer_read(buffer, buffer_f32);

entity.autonomous_movement = buffer_read(buffer, buffer_u8);
entity.autonomous_movement_speed = buffer_read(buffer, buffer_u8);
entity.autonomous_movement_frequency = buffer_read(buffer, buffer_u8);
entity.autonomous_movement_route = buffer_read(buffer, buffer_u32);
    
var n_move_routes = buffer_read(buffer, buffer_u8);
repeat (n_move_routes) {
    serialize_load_move_route(buffer, entity, version);
}

ds_list_clear(entity.switches);
ds_list_clear(entity.variables);

var n_variables = buffer_read(buffer, buffer_u8);
repeat (n_variables) {
    ds_list_add(entity.switches, buffer_read(buffer, buffer_bool));
    ds_list_add(entity.variables, buffer_read(buffer, buffer_f32));
}

while (ds_list_size(entity.switches) < BASE_SELF_VARIABLES) {
    ds_list_add(entity.switches, false);
}
while (ds_list_size(entity.variables) < BASE_SELF_VARIABLES) {
    ds_list_add(entity.variables, 0);
}

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
            data.value_type_guid = buffer_read(buffer, buffer_datatype);
            data.value_data = buffer_read(buffer, buffer_datatype);
            break;
        
        case DataTypes.MESH: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.IMG_TILESET: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.AUDIO_BGM: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.AUDIO_SE: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.ANIMATION: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.MAP: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.IMG_BATTLER: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.IMG_OVERWORLD: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.IMG_PARTICLE: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.IMG_UI: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.IMG_ETC: data.value_data = buffer_read(buffer, buffer_datatype); break;
        case DataTypes.EVENT: data.value_data = buffer_read(buffer, buffer_datatype); break;
        
        case DataTypes.TILE: not_yet_implemented(); break;
        case DataTypes.AUTOTILE: not_yet_implemented(); break;
        case DataTypes.ENTITY: not_yet_implemented(); break;
    }
    
    ds_list_add(entity.generic_data, data);
}