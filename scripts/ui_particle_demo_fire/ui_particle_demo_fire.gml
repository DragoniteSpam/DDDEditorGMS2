/// @param UIButton

var button = argument0;

dialog_create_yes_or_no(button.root, "Would you like to load the demo fire particles? (Any current particle types and emitters will be cleared.)", ui_particle_demo_fire_execute);