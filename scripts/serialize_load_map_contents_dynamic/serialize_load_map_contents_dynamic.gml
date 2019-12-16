/// @param buffer
/// @param version
/// @param DataMapContainer
/// @param [is-temp?]

var buffer = argument[0];
var version = argument[1];
var map_container = argument[2];
var is_temp = (argument_count > 3) ? argument[3] : false;

var n_things = buffer_read(buffer, buffer_u32);

repeat (n_things) {
    var type = buffer_read(buffer, buffer_u16);
    var thing = instance_create_depth(0, 0, 0, Stuff.etype_objects[type]);
    thing.tmx_id = buffer_read(buffer, buffer_u32);
    script_execute(thing.load_script, buffer, thing, version);
    
    map_add_thing(thing, thing.xx, thing.yy, thing.zz, map_container, is_temp);
}