/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

Stuff.game_starting_map = buffer_read(buffer, buffer_datatype);

Stuff.game_starting_x = buffer_read(buffer, buffer_u16);
Stuff.game_starting_y = buffer_read(buffer, buffer_u16);
Stuff.game_starting_z = buffer_read(buffer, buffer_u16);
Stuff.game_starting_direction = buffer_read(buffer, buffer_u8);
if (version >= DataVersions.MAP_LIGHTING_FOG_DATA) {
    Stuff.game_lighting_buckets = buffer_read(buffer, buffer_f32);
    Stuff.game_lighting_default_ambient = buffer_read(buffer, buffer_u32);
}

var bools = buffer_read(buffer, buffer_u32);
Stuff.game_player_grid = unpack(bools, 0);
Stuff.game_battle_style = buffer_read(buffer, buffer_u8);

var n_switches = buffer_read(buffer, buffer_u16);
var n_variables = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_switches; i++) {
    var sw_data = ["", false];
    sw_data[0] = buffer_read(buffer, buffer_string);
    sw_data[1] = buffer_read(buffer, buffer_bool);
    ds_list_add(Stuff.switches, sw_data);
}

for (var i = 0; i < n_variables; i++) {
    var var_data = ["", false];
    var_data[0] = buffer_read(buffer, buffer_string);
    var_data[1] = buffer_read(buffer, buffer_f32);
    ds_list_add(Stuff.variables, var_data);
}

if (version >= DataVersions.THIRTY_TWO_FLAGS) {
    for (var i = 0; i < FLAG_COUNT; i++) {
        Stuff.all_event_triggers[| i] = buffer_read(buffer, buffer_string);
    }
} else {
    var n_event_triggers = buffer_read(buffer, buffer_u8);
    for (var i = 0; i < n_event_triggers; i++) {
        Stuff.all_event_triggers[| i] = buffer_read(buffer, buffer_string);
    }
    for (var i = n_event_triggers; i < FLAG_COUNT; i++) {
        Stuff.all_event_triggers[| i] = "";
    }
}

if (version >= DataVersions.COLLISION_TRIGGER_DATA) {
    if (version >= DataVersions.THIRTY_TWO_FLAGS) {
        for (var i = 0; i < FLAG_COUNT; i++) {
            Stuff.all_collision_triggers[| i] = buffer_read(buffer, buffer_string);
        }
    } else {
        var n_collision_triggers = buffer_read(buffer, buffer_u8);
        for (var i = 0; i < n_collision_triggers; i++) {
            Stuff.all_collision_triggers[| i] = buffer_read(buffer, buffer_string);
        }
        for (var i = n_collision_triggers; i < FLAG_COUNT; i++) {
            Stuff.all_collision_triggers[| i] = "";
        }
    }
}

var n_constants = buffer_read(buffer, buffer_u16);
repeat (n_constants) {
    var what = instance_create_depth(0, 0, 0, DataConstant);
    serialize_load_generic(buffer, what, version);
    
    what.type = buffer_read(buffer, buffer_u16);
    what.type_guid = buffer_read(buffer, buffer_datatype);
    what.value_real = buffer_read(buffer, buffer_f32);
    what.value_string = buffer_read(buffer, buffer_string);
    what.value_guid = buffer_read(buffer, buffer_datatype);
    
    ds_list_add(Stuff.all_game_constants, what);
}

if (version >= DataVersions.GAME_NOTES) {
    Stuff.game_notes = buffer_read(buffer, buffer_string);
}

if (version >= DataVersions.ASSET_FLAG_LIST) {
    if (version >= DataVersions.THIRTY_TWO_FLAGS) {
        for (var i = 0; i < FLAG_COUNT; i++) {
            Stuff.all_asset_flags[| i] = buffer_read(buffer, buffer_string);
        }
    } else {
        var n_asset_flags = buffer_read(buffer, buffer_u8);
        for (var i = 0; i < n_asset_flags; i++) {
            Stuff.all_asset_flags[| i] = buffer_read(buffer, buffer_string);
        }
        for (var i = n_asset_flags; i < FLAG_COUNT; i++) {
            Stuff.all_asset_flags[| i] = "";
        }
    }
}