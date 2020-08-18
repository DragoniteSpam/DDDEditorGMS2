/// @param UIButton
function ui_particle_demo_glow(argument0) {

	var button = argument0;

	dialog_create_yes_or_no(button.root, "Would you like to load the demo glow particles? (Any current particle types and emitters will be cleared.)", ui_particle_demo_glow_execute);


}
