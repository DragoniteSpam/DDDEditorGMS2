/// @param UIThing
function uivc_stash(argument0) {

	var thing = argument0;

	// currently only UIInput objects have validation/value conversation
	// scripts attached. that should probably change soon. they don't have
	// to be complicated and can probably automatically return "true"
	// though, since you already know that kind of data is good.

	// the value conversion is needed, since this is a genric type
	argument0.root.data[? argument0.key] = script_execute(argument0.value_conversion, argument0.value);


}
