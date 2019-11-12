/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.GLOBAL_METADATA);

buffer_write(buffer, buffer_datatype, Stuff.game_starting_map);
buffer_write(buffer, buffer_u16, Stuff.game_starting_x);
buffer_write(buffer, buffer_u16, Stuff.game_starting_y);
buffer_write(buffer, buffer_u16, Stuff.game_starting_z);
buffer_write(buffer, buffer_u8, Stuff.game_starting_direction);

var bools = pack(Stuff.game_player_grid);
buffer_write(buffer, buffer_u32, bools);

buffer_write(buffer, buffer_u8, Stuff.game_battle_style);

var n_switches = ds_list_size(Stuff.switches);
var n_variables = ds_list_size(Stuff.variables);
buffer_write(buffer, buffer_u16, n_switches);
buffer_write(buffer, buffer_u16, n_variables);

for (var i = 0; i < n_switches; i++) {
    var sw_data = Stuff.switches[| i];
    buffer_write(buffer, buffer_string, sw_data[0]);
    buffer_write(buffer, buffer_bool, sw_data[1]);
}

for (var i = 0; i < n_variables; i++) {
    var var_data = Stuff.variables[| i];
    buffer_write(buffer, buffer_string, var_data[0]);
    buffer_write(buffer, buffer_f32, var_data[1]);
}

var n_triggers = ds_list_size(Stuff.all_event_triggers);
buffer_write(buffer, buffer_u8, n_triggers);
for (var i = 0; i < n_triggers; i++) {
	buffer_write(buffer, buffer_string, Stuff.all_event_triggers[| i]);
}

var n_constants = ds_list_size(Stuff.all_game_constants);
buffer_write(buffer, buffer_u16, n_constants);
for (var i = 0; i < n_constants; i++) {
    var what = Stuff.all_game_constants[| i];
    serialize_save_generic(buffer, what);
    
    buffer_write(buffer, buffer_u16, what.type);
    buffer_write(buffer, buffer_datatype, what.type_guid);
    buffer_write(buffer, buffer_f32, what.value_real);
    buffer_write(buffer, buffer_string, what.value_string);
    buffer_write(buffer, buffer_datatype, what.value_guid);
}

return buffer_tell(buffer);