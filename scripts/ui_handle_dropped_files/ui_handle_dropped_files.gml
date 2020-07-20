/// @param UIThing

var thing = argument0;

if (array_length_1d(Stuff.files_dropped) > 0) {
    script_execute(thing.file_dropper_action, thing, Stuff.files_dropped);
}