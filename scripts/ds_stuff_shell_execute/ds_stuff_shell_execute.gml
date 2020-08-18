/// @param verb
/// @param file
function ds_stuff_shell_execute(argument0, argument1) {

	// returns the ID of the process
	// the arguments go in reverse order because that's how it was set up way back when
	return external_call(global._ds_stuff_process, argument1, argument0);


}
