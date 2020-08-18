/// @param UIThing
function dmu_dialog_commit(argument0) {

	var thing = argument0;

	script_execute(thing.root.commit, thing.root);


}
